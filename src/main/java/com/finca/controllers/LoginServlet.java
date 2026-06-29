package com.finca.controllers;

import java.io.IOException;
import java.io.PrintWriter;

import com.finca.services.AuthService;
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

    private final AuthService authService = new AuthService();

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
        } else if ("change_first_password".equals(action)) {
            handleChangeFirstPassword(request, response, out);
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
        
        JsonObject json = new JsonObject();
        try {
            Usuario u = authService.verificarCredencialesYEnviarOTP(email, password);
            if (u != null) {
                json.addProperty("success", true);
                json.addProperty("idUsuario", u.getId());
                json.addProperty("email", email);
            } else {
                json.addProperty("success", false);
                json.addProperty("message", "El correo electrónico o la contraseña son incorrectos.");
            }
        } catch (Exception e) {
            e.printStackTrace(); 
            json.addProperty("success", false);
            json.addProperty("message", "Falla en el servidor: " + e.getMessage());
        }
        out.print(json.toString());
    }

    private void handleLoginWithOtp(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        JsonObject json = new JsonObject();
        try {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            String email = request.getParameter("email");
            String otp = request.getParameter("otp");
            
            if (authService.validarOTP(idUsuario, otp)) {
                Usuario u = authService.obtenerPorEmail(email);
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
        JsonObject json = new JsonObject();
        
        try {
            Usuario u = authService.solicitarOTPRecuperacion(email);
            if (u != null) {
                json.addProperty("success", true);
                json.addProperty("idUsuario", u.getId());
            } else {
                json.addProperty("success", false);
                json.addProperty("message", "El correo no existe en nuestro sistema.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("success", false);
            json.addProperty("message", "Falla de servidor: " + e.getMessage());
        }
        out.print(json.toString());
    }

    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        JsonObject json = new JsonObject();
        try {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            String otp = request.getParameter("otp");
            
            if (authService.validarOTP(idUsuario, otp)) {
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
            
            if (authService.actualizarContrasena(idUsuario, newPassword)) {
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

    private void handleChangeFirstPassword(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        JsonObject json = new JsonObject();
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("usuarioLogueado") == null) {
                json.addProperty("success", false);
                json.addProperty("message", "No hay una sesión activa para realizar esta acción.");
                out.print(json.toString());
                return;
            }

            Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
            String newPassword = request.getParameter("newPassword");
            
            com.finca.dao.UsuarioDAO usuarioDAO = new com.finca.dao.UsuarioDAO();
            
            // Reutilizamos el servicio para encriptar si es necesario (asumiremos que Auth lo hace o el DAO lo guarda, 
            // aunque aquí llamaremos directamente al DAO, normalmente se hace hash, usaremos el mismo que actualizarPassword).
            // Usando actualizarPasswordObligatorio del DAO
            if (usuarioDAO.actualizarPasswordObligatorio(u.getId(), newPassword)) {
                // Actualizar la sesión para que ya no pida el cambio de password
                u.setRequiereCambioPassword(false);
                session.setAttribute("usuarioLogueado", u);
                json.addProperty("success", true);
            } else {
                json.addProperty("success", false);
                json.addProperty("message", "Error al guardar la nueva contraseña en el sistema.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("success", false);
            json.addProperty("message", "Error interno en el servidor.");
        }
        out.print(json.toString());
    }
}