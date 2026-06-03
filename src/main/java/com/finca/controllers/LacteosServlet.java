package com.finca.controllers;

import java.io.IOException;

import com.finca.dao.ProductoLacteoDAO;
import com.finca.models.ProductoLacteo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/lacteos")
public class LacteosServlet extends HttpServlet {

    private ProductoLacteoDAO lacteoDAO = new ProductoLacteoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Seguridad: Verificar sesión
        HttpSession session = request.getSession();
        if (session.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect("login");
            return;
        }

        // Obtener el inventario y mandarlo a la vista
        request.setAttribute("lacteos", lacteoDAO.obtenerTodos());

        String msg = request.getParameter("msg");
        String error = request.getParameter("error");
        
        if ("registrado".equals(msg)) request.setAttribute("successMessage", "Producto lácteo registrado exitosamente.");
        if ("eliminado".equals(msg)) request.setAttribute("successMessage", "Producto eliminado del catálogo.");
        if ("errorDuplicado".equals(error)) request.setAttribute("errorMessage", "Error: Ya existe un producto con ese código.");
        if ("errorEliminar".equals(error)) request.setAttribute("errorMessage", "No se puede eliminar este producto porque ya tiene ventas o transacciones asociadas.");

        request.getRequestDispatcher("lacteos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Acción: ELIMINAR
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (lacteoDAO.eliminar(id)) {
                response.sendRedirect("lacteos?msg=eliminado");
            } else {
                response.sendRedirect("lacteos?error=errorEliminar");
            }
            return;
        }

        // Acción: REGISTRAR NUEVO (Por defecto)
        ProductoLacteo p = new ProductoLacteo();
        p.setCodigo(request.getParameter("codigo"));
        p.setNombre(request.getParameter("nombre"));
        p.setDescripcion(request.getParameter("descripcion"));
        p.setUnidadMedida(request.getParameter("unidadMedida"));
        p.setStock(Double.parseDouble(request.getParameter("stock")));
        p.setPrecioUnitario(Double.parseDouble(request.getParameter("precioUnitario")));

        if (lacteoDAO.registrar(p)) {
            response.sendRedirect("lacteos?msg=registrado");
        } else {
            response.sendRedirect("lacteos?error=errorDuplicado");
        }
    }
}