package com.finca.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

import com.finca.dao.UsuarioDAO;
import com.finca.models.Usuario;
import com.google.gson.JsonObject; // Importación clave para blindar el JSON

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        if ("verify_credentials".equals(action)) {
            handleVerifyCredentials(request, response, out);
        } else if ("login_with_otp".equals(action)) {
            handleLoginWithOtp(request, response, out);
        } else if ("request_otp".equals(action)) {
            handleRequestOtp(request, response, out);
        } else if ("verify_otp".equals(action)) {
            handleVerifyOtp(request, response, out);
        } else if ("reset_password".equals(action)) {
            handleResetPassword(request, response, out);
        } else {
            JsonObject json = new JsonObject();
            json.addProperty("success", false);
            json.addProperty("message", "Acción no reconocida por el servidor.");
            out.print(json.toString());
        }
        out.flush();
    }

    private void handleVerifyCredentials(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        Usuario u = usuarioDAO.validarLogin(email, password);
        JsonObject json = new JsonObject();
        
        if (u != null) {
            String otp = String.format("%06d", new Random().nextInt(999999));
            
            // ========================================================
            // IMPRESIÓN DEL CÓDIGO OTP EN LA CONSOLA (INICIO DE SESIÓN)
            // ========================================================
            System.out.println("\n=========================================");
            System.out.println("🔑 CÓDIGO OTP PARA INICIO DE SESIÓN");
            System.out.println("👤 Usuario ID: " + u.getId() + " (" + email + ")");
            System.out.println("🔢 CÓDIGO OTP: " + otp);
            System.out.println("=========================================\n");
            
            usuarioDAO.guardarTokenOTP(u.getId(), otp);
            
            try {
                com.finca.utils.EmailService.enviarCodigoOTP(email, otp);
                json.addProperty("success", true);
                json.addProperty("idUsuario", u.getId());
                json.addProperty("email", email);
            } catch (Throwable e) {
                e.printStackTrace(); 
                json.addProperty("success", false);
                json.addProperty("message", "Falla enviando correo: " + e.toString());
            }
        } else {
            json.addProperty("success", false);
            json.addProperty("message", "El correo electrónico o la contraseña son incorrectos.");
        }
        out.print(json.toString());
    }

    private void handleLoginWithOtp(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        JsonObject json = new JsonObject();
        try {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            String email = request.getParameter("email");
            String otp = request.getParameter("otp");
            
            if (usuarioDAO.validarTokenOTP(idUsuario, otp)) {
                Usuario u = usuarioDAO.obtenerPorEmail(email);
                if (u != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("usuarioLogueado", u);
                    json.addProperty("success", true);
                } else {
                    json.addProperty("success", false);
                    json.addProperty("message", "Error al cargar la información del usuario.");
                }
            } else {
                json.addProperty("success", false);
                json.addProperty("message", "El código de seguridad es incorrecto o ya ha expirado.");
            }
        } catch (NumberFormatException e) {
            json.addProperty("success", false);
            json.addProperty("message", "Datos inválidos enviados al servidor.");
        }
        out.print(json.toString());
    }

    private void handleRequestOtp(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        String email = request.getParameter("email");
        Usuario u = usuarioDAO.obtenerPorEmail(email);
        JsonObject json = new JsonObject();
        
        if (u != null) {
            String otp = String.format("%06d", new Random().nextInt(999999));
            
            // ========================================================
            // IMPRESIÓN DEL CÓDIGO OTP EN LA CONSOLA (RECUPERAR CLAVE)
            // ========================================================
            System.out.println("\n=========================================");
            System.out.println("🔑 CÓDIGO OTP PARA RECUPERAR CONTRASEÑA");
            System.out.println("👤 Usuario ID: " + u.getId() + " (" + email + ")");
            System.out.println("🔢 CÓDIGO OTP: " + otp);
            System.out.println("=========================================\n");

            usuarioDAO.guardarTokenOTP(u.getId(), otp);
            
            try {
                com.finca.utils.EmailService.enviarCodigoOTP(email, otp);
                json.addProperty("success", true);
                json.addProperty("idUsuario", u.getId());
            } catch (Throwable e) {
                e.printStackTrace();
                json.addProperty("success", false);
                json.addProperty("message", "Falla de correo: " + e.toString());
            }
        } else {
            json.addProperty("success", false);
            json.addProperty("message", "El correo no existe en nuestro sistema.");
        }
        out.print(json.toString());
    }

    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        JsonObject json = new JsonObject();
        try {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            String otp = request.getParameter("otp");
            
            if (usuarioDAO.validarTokenOTP(idUsuario, otp)) {
                json.addProperty("success", true);
            } else {
                json.addProperty("success", false);
                json.addProperty("message", "El código es incorrecto o ya ha expirado.");
            }
        } catch (NumberFormatException e) {
            json.addProperty("success", false);
            json.addProperty("message", "ID de usuario inválido.");
        }
        out.print(json.toString());
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        JsonObject json = new JsonObject();
        try {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            String newPassword = request.getParameter("newPassword");
            
            if (usuarioDAO.actualizarPassword(idUsuario, newPassword)) {
                json.addProperty("success", true);
            } else {
                json.addProperty("success", false);
                json.addProperty("message", "Error al guardar la nueva contraseña en el sistema.");
            }
        } catch (NumberFormatException e) {
            json.addProperty("success", false);
            json.addProperty("message", "ID de usuario inválido.");
        }
        out.print(json.toString());
    }
}