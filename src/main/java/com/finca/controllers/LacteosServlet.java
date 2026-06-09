package com.finca.controllers;

import java.io.IOException;

import com.finca.dao.LoteDAO;
import com.finca.dao.ProductoLacteoDAO;
import com.finca.models.LoteProduccion;
import com.finca.models.ProductoLacteo;
import com.finca.models.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/lacteos")
public class LacteosServlet extends HttpServlet {
    
    // Instanciamos AMBOS DAOs para la fábrica
    private final ProductoLacteoDAO lacteoDAO = new ProductoLacteoDAO();
    private final LoteDAO loteDAO = new LoteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // SEGURIDAD: Verificamos que haya sesión
        HttpSession session = request.getSession();
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
        if (usuarioLogueado == null) {
            response.sendRedirect("login");
            return;
        }

        // Cargamos la data de ambos mundos (Catálogo y Lotes)
        request.setAttribute("lacteos", lacteoDAO.obtenerTodos());
        request.setAttribute("lotes", loteDAO.obtenerTodos());
        
        request.getRequestDispatcher("lacteos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // SEGURIDAD
        HttpSession session = request.getSession();
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
        if (usuarioLogueado == null) {
            response.sendRedirect("login");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            // ==========================================
            // ACCIONES DEL CATÁLOGO DE LÁCTEOS
            // ==========================================
            if ("add_producto".equals(action)) {
                ProductoLacteo p = new ProductoLacteo();
                p.setCodigo(request.getParameter("codigo"));
                p.setNombre(request.getParameter("nombre"));
                p.setDescripcion(request.getParameter("descripcion"));
                p.setUnidadMedida(request.getParameter("unidadMedida"));
                p.setStock(Double.parseDouble(request.getParameter("stock")));
                p.setPrecioUnitario(Double.parseDouble(request.getParameter("precioUnitario")));
                
                if (lacteoDAO.registrar(p)) {
                    request.setAttribute("successMessage", "El producto se agregó al catálogo comercial correctamente.");
                } else {
                    request.setAttribute("errorMessage", "Error: Verifica que el código interno no esté duplicado.");
                }
                
            } else if ("delete_producto".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (lacteoDAO.eliminar(id)) {
                    request.setAttribute("successMessage", "El producto fue retirado del inventario exitosamente.");
                } else {
                    request.setAttribute("errorMessage", "No se pudo eliminar el producto, tiene lotes asociados.");
                }
            } 
            // ==========================================
            // ACCIONES DE LOS LOTES DE PRODUCCIÓN
            // ==========================================
            else if ("iniciar_lote".equals(action)) {
                LoteProduccion lote = new LoteProduccion();
                lote.setIdProducto(Integer.parseInt(request.getParameter("idProducto")));
                lote.setCantidad(Double.parseDouble(request.getParameter("cantidad")));
                lote.setLitrosLecheUsados(Double.parseDouble(request.getParameter("litrosLecheUsados")));

                if (loteDAO.iniciarProduccion(lote)) {
                    request.setAttribute("successMessage", "Producción iniciada. La leche cruda fue descontada del tanque.");
                } else {
                    request.setAttribute("errorMessage", "No hay suficiente Leche Cruda en el inventario para iniciar este lote.");
                }
            } else if ("estado_lote".equals(action)) {
                int idLote = Integer.parseInt(request.getParameter("idLote"));
                String nuevoEstado = request.getParameter("nuevoEstado");

                if (loteDAO.cambiarEstado(idLote, nuevoEstado)) {
                    request.setAttribute("successMessage", "El estado del lote ha sido actualizado en la fábrica.");
                } else {
                    request.setAttribute("errorMessage", "Ocurrió un error al intentar actualizar el lote.");
                }
            }
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error en los datos ingresados: " + e.getMessage());
        }
        
        // Recargamos la vista manteniendo las alertas
        doGet(request, response);
    }
}