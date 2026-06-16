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
    
    private final ProductoLacteoDAO lacteoDAO = new ProductoLacteoDAO();
    private final LoteDAO loteDAO = new LoteDAO();

    // 🔒 NUEVO: Método de Seguridad para la Fábrica
    private boolean verificarPermisoOperarioYAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (usuarioLogueado == null) {
            response.sendRedirect("login");
            return false;
        }
        
        String rol = usuarioLogueado.getRol() != null ? usuarioLogueado.getRol() : "";
        // Solo permitimos interactuar con la fábrica a Administrador (1) y Operario (3)
        // (Si más adelante quieres que los Vendedores (4) vean esto, puedes agregarlo aquí)
        if (!rol.equals("1") && !rol.equalsIgnoreCase("Administrador") && 
            !rol.equals("3") && !rol.equalsIgnoreCase("Operario")) {
            
            response.sendRedirect("dashboard?error=acceso_denegado");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 🔒 BLINDAJE DE SEGURIDAD (Evita que el Veterinario mire el catálogo comercial/lotes)
        if (!verificarPermisoOperarioYAdmin(request, response)) {
            return;
        }

        request.setAttribute("lacteos", lacteoDAO.obtenerTodos());
        request.setAttribute("lotes", loteDAO.obtenerTodos());
        
        request.getRequestDispatcher("lacteos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 🔒 BLINDAJE DE SEGURIDAD (Bloquea creación de productos/lotes a roles ajenos)
        if (!verificarPermisoOperarioYAdmin(request, response)) {
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
        
        doGet(request, response);
    }
}