package com.finca.controllers;

import java.io.IOException;
import java.sql.Date;

import com.finca.dao.BovinoDAO;
import com.finca.models.Bovino;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/inventario-ganado")
public class BovinoServlet extends HttpServlet {
    
    // CORRECCIÓN: Se agregó la palabra 'final' sugerida por el editor
    private final BovinoDAO bovinoDAO = new BovinoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("usuarioLogueado") == null) { 
            response.sendRedirect("login"); 
            return; 
        }
        
        request.setAttribute("listaProduccion", bovinoDAO.obtenerPorClasificacion("Producción"));
        request.setAttribute("listaVenta", bovinoDAO.obtenerPorClasificacion("Venta"));
        
        if ("registrado".equals(request.getParameter("msg"))) request.setAttribute("successMessage", "¡Animal registrado exitosamente!");
        if ("movido".equals(request.getParameter("msg"))) request.setAttribute("successMessage", "El animal ha sido transferido de inventario.");
        if ("error".equals(request.getParameter("error"))) request.setAttribute("errorMessage", "Hubo un error al procesar la solicitud.");
        
        request.getRequestDispatcher("inventario-ganado.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("mover".equals(action)) {
            bovinoDAO.cambiarClasificacion(Integer.parseInt(request.getParameter("id")), request.getParameter("destino"));
            response.sendRedirect("inventario-ganado?msg=movido");
            return;
        }
        
        try {
            Bovino b = new Bovino();
            b.setNumeroArete(request.getParameter("numeroArete"));
            b.setRaza(request.getParameter("raza"));
            b.setGenero(request.getParameter("genero"));
            b.setPesoKg(Double.parseDouble(request.getParameter("pesoKg")));
            b.setProposito(request.getParameter("proposito"));
            b.setEstadoSalud(request.getParameter("estadoSalud"));
            b.setFechaNacimiento(Date.valueOf(request.getParameter("fechaNacimiento")));
            b.setPrecioEstimado(Double.parseDouble(request.getParameter("precioEstimado")));
            b.setClasificacion(request.getParameter("clasificacion"));
            b.setNumeroPartos(request.getParameter("numeroPartos").isEmpty() ? 0 : Integer.parseInt(request.getParameter("numeroPartos")));
            b.setLitrosDiariosPromedio(request.getParameter("litrosDiarios").isEmpty() ? 0 : Double.parseDouble(request.getParameter("litrosDiarios")));
            b.setImageUrl(request.getParameter("imageUrl")); // 📸 Lee el Link de la foto

            bovinoDAO.registrar(b);
            response.sendRedirect("inventario-ganado?msg=registrado");
            
        } catch (IllegalArgumentException | NullPointerException e) {
            // CORRECCIÓN: Manejo de excepciones más específico y limpio
            System.err.println("Error al procesar los datos del formulario: " + e.getMessage());
            response.sendRedirect("inventario-ganado?error=1");
        } catch (Exception e) {
            // Captura cualquier otro error no previsto
            System.err.println("Error inesperado en el servidor: " + e.getMessage());
            response.sendRedirect("inventario-ganado?error=1");
        }
    }
}