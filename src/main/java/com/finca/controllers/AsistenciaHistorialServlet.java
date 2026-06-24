package com.finca.controllers;

import java.io.IOException;

import com.finca.models.Asistencia;
import com.finca.services.AsistenciaService;
import com.finca.services.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/asistencias")
public class AsistenciaHistorialServlet extends HttpServlet {

    private final AsistenciaService asistenciaService = new AsistenciaService();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }

        // Solo Administradores pueden ver el historial completo
        if (!authService.esAdministrador(request)) {
            response.sendRedirect("dashboard?error=acceso_denegado");
            return;
        }

        String action = request.getParameter("action");

        if ("pdf".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int idAsistencia = Integer.parseInt(idStr);
                Asistencia asistencia = asistenciaService.obtenerPorId(idAsistencia);
                
                if (asistencia != null) {
                    response.setContentType("application/pdf");
                    response.setHeader("Content-Disposition", "attachment; filename=Comprobante_Asistencia_" + asistencia.getIdAsistencia() + ".pdf");
                    
                    try {
                        String uploadPath = request.getServletContext().getRealPath("") + java.io.File.separator + "uploads";
                        asistenciaService.generarPdfAsistencia(asistencia, response.getOutputStream(), uploadPath);
                    } catch (Exception e) {
                        e.printStackTrace();
                        response.sendRedirect("asistencias?error=pdf");
                    }
                    return;
                }
            }
            response.sendRedirect("asistencias?error=notfound");
            return;
        }

        // Si no hay acción específica, listar el historial
        request.setAttribute("historialAsistencias", asistenciaService.obtenerHistorial());
        
        String error = request.getParameter("error");
        if ("pdf".equals(error)) request.setAttribute("errorMessage", "Error al generar el documento PDF.");
        if ("notfound".equals(error)) request.setAttribute("errorMessage", "El registro de asistencia no fue encontrado.");

        request.getRequestDispatcher("asistencias.jsp").forward(request, response);
    }
}
