package com.finca.controllers;

import java.io.IOException;
import java.util.Map;

import com.finca.services.AuthService;
import com.finca.services.DashboardService;
import com.finca.models.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final AuthService authService = new AuthService();
    private final DashboardService dashboardService = new DashboardService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }

        Usuario usuarioLogueado = (Usuario) request.getSession().getAttribute("usuarioLogueado");

        // Si el usuario es un Cliente, redirigirlo a su portal de catálogo
        String r = usuarioLogueado.getRol();
        if (r != null && (r.equals("5") || r.equalsIgnoreCase("Cliente"))) {
            response.sendRedirect("catalogo");
            return;
        }

        // Enviamos el nombre y el rol traducido a la vista
        request.setAttribute("nombreCorto", authService.obtenerNombreCorto(usuarioLogueado));
        request.setAttribute("rolTexto", authService.obtenerRolTexto(usuarioLogueado));

        try {
            Map<String, Object> stats = dashboardService.obtenerEstadisticasDashboard();
            for (Map.Entry<String, Object> entry : stats.entrySet()) {
                request.setAttribute(entry.getKey(), entry.getValue());
            }
        } catch (Exception e) {
            System.err.println("Error procesando los datos del Dashboard: " + e.getMessage());
        }

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}