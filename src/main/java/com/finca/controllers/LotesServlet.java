package com.finca.controllers;

import java.io.IOException;

import com.finca.dao.LoteDAO;
import com.finca.dao.ProductoLacteoDAO;
import com.finca.models.LoteProduccion;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/lotes-produccion")
public class LotesServlet extends HttpServlet {

    private LoteDAO loteDAO = new LoteDAO();
    private ProductoLacteoDAO lacteoDAO = new ProductoLacteoDAO(); // Para traer la lista de quesos

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect("login");
            return;
        }

        request.setAttribute("lotes", loteDAO.obtenerTodos());
        request.setAttribute("catalogoLacteos", lacteoDAO.obtenerTodos()); // Pasamos los quesos para el formulario

        String msg = request.getParameter("msg");
        String error = request.getParameter("error");
        
        if ("iniciado".equals(msg)) request.setAttribute("successMessage", "Producción iniciada. La leche fue descontada.");
        if ("actualizado".equals(msg)) request.setAttribute("successMessage", "Estado actualizado con éxito.");
        if ("errorLeche".equals(error)) request.setAttribute("errorMessage", "Error: No hay suficiente Leche Cruda en el inventario para iniciar este lote.");
        if ("errorGeneral".equals(error)) request.setAttribute("errorMessage", "Ocurrió un error al procesar la solicitud.");

        request.getRequestDispatcher("lotes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Acción: INICIAR PRODUCCIÓN
        if ("iniciar".equals(action)) {
            LoteProduccion lote = new LoteProduccion();
            lote.setIdProducto(Integer.parseInt(request.getParameter("idProducto")));
            lote.setCantidad(Double.parseDouble(request.getParameter("cantidad")));
            lote.setLitrosLecheUsados(Double.parseDouble(request.getParameter("litrosLecheUsados")));

            if (loteDAO.iniciarProduccion(lote)) {
                response.sendRedirect("lotes-produccion?msg=iniciado");
            } else {
                response.sendRedirect("lotes-produccion?error=errorLeche");
            }
        } 
        // Acción: CAMBIAR ESTADO (Botones)
        else if ("cambiarEstado".equals(action)) {
            int idLote = Integer.parseInt(request.getParameter("idLote"));
            String nuevoEstado = request.getParameter("nuevoEstado");

            if (loteDAO.cambiarEstado(idLote, nuevoEstado)) {
                response.sendRedirect("lotes-produccion?msg=actualizado");
            } else {
                response.sendRedirect("lotes-produccion?error=errorGeneral");
            }
        }
    }
}