package com.finca.controllers;

import java.io.IOException;

import com.finca.models.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Validar Seguridad
        HttpSession session = request.getSession();
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
        if (usuarioLogueado == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // =========================================================
            // 2. AQUÍ CONECTAS TUS DAO PARA TRAER DATOS REALES
            // (Estos son ejemplos de variables que enviarás al JSP)
            // =========================================================
            
            // Tarjetas Superiores
            request.setAttribute("totalBovinos", 124); // Ejemplo: bovinoDAO.contarTodos()
            request.setAttribute("stockLeche", 850.0); // Ejemplo: produccionDAO.obtenerStock()
            request.setAttribute("atencionesMedicas", 4); // Ejemplo: clinicaDAO.contarEnTratamiento()
            request.setAttribute("lotesQueso", 28); // Ejemplo: lacteosDAO.contarStock()

            // Gráfico Circular (Porcentajes)
            request.setAttribute("porcProduccion", 65);
            request.setAttribute("porcCrias", 20);
            request.setAttribute("porcToros", 15);

            // Gráfico de Líneas (Últimos 7 días)
            // Se envían como un String de texto listo para que JavaScript lo lea
            request.setAttribute("labelsGrafico", "'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'");
            request.setAttribute("datosGrafico", "120, 135, 125, 145, 150, 140, 160");

        } catch (Exception e) {
            System.err.println("Error en Dashboard: " + e.getMessage());
        }

        // 3. Despachamos la vista con los datos cargados
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}