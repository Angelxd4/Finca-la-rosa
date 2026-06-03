package com.finca.controllers;

import java.io.IOException;

import com.finca.dao.ProduccionDAO;
import com.finca.models.Ordeno;
import com.finca.models.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/produccion")
public class ProduccionServlet extends HttpServlet {

    private ProduccionDAO produccionDAO = new ProduccionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Enviar historial y stock actual a la vista
        request.setAttribute("historial", produccionDAO.obtenerHistorial());
        request.setAttribute("stockLeche", produccionDAO.obtenerStockLeche());
        
        if (request.getParameter("msg") != null) {
            request.setAttribute("successMessage", "¡Ordeño registrado y litros sumados al inventario!");
        }
        
        request.getRequestDispatcher("produccion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener el usuario logueado para registrarlo como el supervisor
        HttpSession session = request.getSession();
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");

        if (usuarioLogueado == null) {
            response.sendRedirect("login");
            return;
        }

        Ordeno o = new Ordeno();
        o.setVacasOrdenadas(Integer.parseInt(request.getParameter("vacasOrdenadas")));
        o.setLitrosObtenidos(Double.parseDouble(request.getParameter("litrosObtenidos")));
        o.setSupervisorId(usuarioLogueado.getId()); // ¡El sistema detecta quién es automáticamente!
        o.setAsistentes(request.getParameter("asistentes"));
        o.setObservaciones(request.getParameter("observaciones"));

        if (produccionDAO.registrarOrdeno(o)) {
            response.sendRedirect("produccion?msg=registrado");
        } else {
            response.sendRedirect("produccion?error=1");
        }
    }
}