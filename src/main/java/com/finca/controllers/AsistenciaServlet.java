package com.finca.controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.finca.utils.DbConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/asistencia-registro")
public class AsistenciaServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String qrData = request.getParameter("qrData"); // Ejemplo: FINCA-LAROSA-DOC-123456
        if (qrData == null || !qrData.startsWith("FINCA-LAROSA-DOC-")) {
            response.getWriter().write("ERROR: Código inválido");
            return;
        }

        String doc = qrData.replace("FINCA-LAROSA-DOC-", "");
        
        try (Connection conn = DbConnection.getConnection()) {
            // 1. Buscar usuario por documento
            PreparedStatement psUser = conn.prepareStatement("SELECT id FROM usuarios WHERE document_id = ?");
            psUser.setString(1, doc);
            ResultSet rs = psUser.executeQuery();
            
            if (rs.next()) {
                int userId = rs.getInt("id");
                // 2. Registrar entrada
                PreparedStatement psIns = conn.prepareStatement("INSERT INTO asistencia (id_usuario, hora_entrada) VALUES (?, CURRENT_TIMESTAMP)");
                psIns.setInt(1, userId);
                psIns.executeUpdate();
                response.getWriter().write("OK: Entrada registrada correctamente");
            } else {
                response.getWriter().write("ERROR: Usuario no encontrado");
            }
        } catch (Exception e) {
            response.getWriter().write("ERROR: " + e.getMessage());
        }
    }
}