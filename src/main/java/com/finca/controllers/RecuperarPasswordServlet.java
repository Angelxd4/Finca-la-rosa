package com.finca.controllers;

import com.finca.dao.UsuarioDAO;
import com.finca.models.Usuario;
import com.finca.utils.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.SecureRandom;

@WebServlet("/recuperar_password")
public class RecuperarPasswordServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"El correo es obligatorio.\"}");
            return;
        }

        Usuario usuario = usuarioDAO.obtenerPorEmail(email.trim());

        if (usuario == null) {
            // Por seguridad, es mejor no revelar si el correo existe o no, pero para esta app interna está bien.
            response.getWriter().write("{\"success\": false, \"message\": \"No se encontró ninguna cuenta con este correo.\"}");
            return;
        }

        // 1. Generar contraseña temporal segura (8 caracteres)
        String tempPassword = generarPasswordTemporal(8);

        // 2. Actualizar la base de datos y forzar cambio obligatorio
        boolean actualizado = usuarioDAO.restablecerPasswordTemporal(usuario.getId(), tempPassword);

        if (!actualizado) {
            response.getWriter().write("{\"success\": false, \"message\": \"Ocurrió un error en la base de datos. Inténtalo más tarde.\"}");
            return;
        }

        // 3. Enviar correo
        String asunto = "Recuperación de Contraseña - Finca La Rosa";
        String mensajeHtml = "<html><body style='font-family: Arial, sans-serif; color: #333; max-width: 600px; margin: auto;'>"
                           + "<h2 style='color: #464704;'>Restablecimiento de Contraseña</h2>"
                           + "<p>Hola <strong>" + usuario.getFullName() + "</strong>,</p>"
                           + "<p>Hemos recibido una solicitud para restablecer tu contraseña en el sistema de Gestión Ganadera.</p>"
                           + "<p>Tu clave temporal es:</p>"
                           + "<div style='background-color: #F8F9F3; padding: 15px; text-align: center; font-size: 24px; font-weight: bold; letter-spacing: 3px; border: 1px solid #9CA889; border-radius: 10px; margin: 20px 0;'>"
                           + tempPassword + "</div>"
                           + "<p style='color: #dc3545;'><strong>Importante:</strong> Al iniciar sesión con esta clave temporal, el sistema te exigirá crear una nueva contraseña definitiva por tu seguridad.</p>"
                           + "<p>Si no solicitaste este cambio, por favor contacta al administrador del sistema de inmediato.</p>"
                           + "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'/>"
                           + "<p style='font-size: 12px; color: #7F8C8D;'>Este es un mensaje automático, por favor no respondas a este correo.</p>"
                           + "</body></html>";

        boolean emailEnviado = EmailService.enviarEmail(usuario.getEmail(), asunto, mensajeHtml);

        if (emailEnviado) {
            response.getWriter().write("{\"success\": true, \"message\": \"Correo enviado correctamente.\"}");
        } else {
            // Si el correo falla, deberíamos revertir, pero para no complicar el flujo, informamos al usuario
            response.getWriter().write("{\"success\": false, \"message\": \"La clave se generó pero hubo un error enviando el correo. Contacta al soporte técnico.\"}");
        }
    }

    private String generarPasswordTemporal(int length) {
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(CHARACTERS.charAt(random.nextInt(CHARACTERS.length())));
        }
        return sb.toString();
    }
}
