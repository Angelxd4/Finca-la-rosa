package com.finca.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

import com.finca.dao.UsuarioDAO;
import com.finca.models.Usuario;

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
        
        // ======================================================
        // FLUJO AJAX: RECUPERACIÓN DE CONTRASEÑA OTP
        // ======================================================
        if ("request_otp".equals(action)) {
            handleRequestOtp(request, response);
            return;
        } else if ("verify_otp".equals(action)) {
            handleVerifyOtp(request, response);
            return;
        } else if ("reset_password".equals(action)) {
            handleResetPassword(request, response);
            return;
        }

        // ======================================================
        // FLUJO NORMAL: INICIO DE SESIÓN
        // ======================================================
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        Usuario usuario = usuarioDAO.validarLogin(email, password);
        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", usuario);
            response.sendRedirect("dashboard");
        } else {
            response.sendRedirect("login?error=1");
        }
    }

    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
        String otp = request.getParameter("otp");
        
        if (usuarioDAO.validarTokenOTP(idUsuario, otp)) {
            out.print("{\"success\": true}");
        } else {
            out.print("{\"success\": false, \"message\": \"El código es incorrecto o ya ha expirado.\"}");
        }
        out.flush();
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
        String newPassword = request.getParameter("newPassword");
        
        if (usuarioDAO.actualizarPassword(idUsuario, newPassword)) {
            out.print("{\"success\": true}");
        } else {
            out.print("{\"success\": false, \"message\": \"Error al guardar la nueva contraseña en el sistema.\"}");
        }
        out.flush();
    }

    // Se mantiene únicamente la versión correcta que envía el email real
    private void handleRequestOtp(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        String email = request.getParameter("email");
        
        Usuario u = usuarioDAO.obtenerPorEmail(email);
        if (u != null) {
            String otp = String.format("%06d", new Random().nextInt(999999));
            usuarioDAO.guardarTokenOTP(u.getId(), otp);
            
            try {
                // AQUÍ SE ENVÍA EL CORREO REAL
                com.finca.utils.EmailService.enviarCodigoOTP(email, otp);
                out.print("{\"success\": true, \"idUsuario\": " + u.getId() + "}");
            } catch (Exception e) {
                out.print("{\"success\": false, \"message\": \"Error al enviar el correo: " + e.getMessage() + "\"}");
            }
        } else {
            out.print("{\"success\": false, \"message\": \"El correo no existe.\"}");
        }
        out.flush();
    }
}