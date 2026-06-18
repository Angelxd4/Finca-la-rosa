package com.finca.controllers;

import java.io.IOException;

import com.finca.services.AsistenciaService;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/asistencia-registro")
public class AsistenciaServlet extends HttpServlet {
    
    private final AsistenciaService asistenciaService = new AsistenciaService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String qrData = request.getParameter("qrData");
        String tipoRegistro = request.getParameter("tipoRegistro");
        
        if (qrData == null || !qrData.startsWith("FINCA-LAROSA-DOC-")) {
            response.getWriter().write("ERROR: Código QR inválido.");
            return;
        }

        if (tipoRegistro == null || (!tipoRegistro.equals("entrada") && !tipoRegistro.equals("salida"))) {
            response.getWriter().write("ERROR: Tipo de registro no válido.");
            return;
        }

        String doc = qrData.replace("FINCA-LAROSA-DOC-", "");
        
        try {
            String resultado = asistenciaService.registrarAsistencia(doc, tipoRegistro);
            response.getWriter().write(resultado);
        } catch (Exception e) {
            response.getWriter().write("ERROR: Error interno del servidor.");
            e.printStackTrace();
        }
    }
}