package com.finca.controllers;

import java.io.IOException;

import com.finca.services.AuthService;
import com.finca.services.LacteosService;
import com.finca.models.LoteProduccion;
import com.finca.models.ProductoLacteo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/lacteos")
public class LacteosServlet extends HttpServlet {
    
    private final LacteosService lacteosService = new LacteosService();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }

        if (!authService.tienePermisoProduccion(request)) {
            response.sendRedirect("dashboard?error=acceso_denegado");
            return;
        }

        request.setAttribute("lacteos", lacteosService.obtenerTodosProductos());
        request.setAttribute("lotes", lacteosService.obtenerTodosLotes());
        
        request.getRequestDispatcher("lacteos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }

        if (!authService.tienePermisoProduccion(request)) {
            response.sendRedirect("dashboard?error=acceso_denegado");
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
                
                if (lacteosService.registrarProducto(p)) {
                    request.setAttribute("successMessage", "El producto se agregó al catálogo comercial correctamente.");
                } else {
                    request.setAttribute("errorMessage", "Error: Verifica que el código interno no esté duplicado.");
                }
                
            } else if ("delete_producto".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (lacteosService.eliminarProducto(id)) {
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

                if (lacteosService.iniciarProduccion(lote)) {
                    request.setAttribute("successMessage", "Producción iniciada. La leche cruda fue descontada del tanque.");
                } else {
                    request.setAttribute("errorMessage", "No hay suficiente Leche Cruda en el inventario para iniciar este lote.");
                }
            } else if ("estado_lote".equals(action)) {
                int idLote = Integer.parseInt(request.getParameter("idLote"));
                String nuevoEstado = request.getParameter("nuevoEstado");

                if (lacteosService.cambiarEstadoLote(idLote, nuevoEstado)) {
                    request.setAttribute("successMessage", "El estado del lote ha sido actualizado en la fábrica.");
                } else {
                    request.setAttribute("errorMessage", "Ocurrió un error al intentar actualizar el lote.");
                }
            }
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error en los datos ingresados: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}