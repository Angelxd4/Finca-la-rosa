package com.finca.servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.finca.dao.BovinoDAO;
import com.finca.dao.ProductoLacteoDAO;
import com.finca.dao.VentaDAO;
import com.finca.models.Bovino;
import com.finca.models.Cliente;
import com.finca.models.DetalleVenta;
import com.finca.models.ProductoLacteo;
import com.finca.models.Venta;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ventas")
public class VentasServlet extends HttpServlet {

    private VentaDAO ventaDAO = new VentaDAO();
    private BovinoDAO bovinoDAO = new BovinoDAO();
    private ProductoLacteoDAO lacteoDAO = new ProductoLacteoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        List<Cliente> clientes = ventaDAO.listarClientes();
        List<Venta> historialVentas = ventaDAO.listarVentasRecientes();
        
        // Cargar inventario para vender
        List<Bovino> ganadoParaVenta = bovinoDAO.obtenerPorClasificacion("Venta"); // Solo vacas marcadas para venta
        List<ProductoLacteo> catalogoLacteos = lacteoDAO.obtenerTodos(); // Todos los lacteos disponibles
        
        request.setAttribute("clientes", clientes);
        request.setAttribute("historialVentas", historialVentas);
        request.setAttribute("ganadoParaVenta", ganadoParaVenta);
        request.setAttribute("catalogoLacteos", catalogoLacteos);

        request.getRequestDispatcher("/ventas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("nuevo_cliente".equals(action)) {
            Cliente c = new Cliente();
            c.setNombreCompleto(request.getParameter("nombreCompleto"));
            c.setDocumentoIdentidad(request.getParameter("documentoIdentidad"));
            c.setTelefono(request.getParameter("telefono"));
            c.setCorreo(request.getParameter("correo"));
            c.setDireccion(request.getParameter("direccion"));
            
            if(ventaDAO.registrarCliente(c)) {
                response.sendRedirect(request.getContextPath() + "/ventas?success=cliente");
            } else {
                response.sendRedirect(request.getContextPath() + "/ventas?error=db_cliente");
            }
            return;
        }
        
        if ("registrar_venta".equals(action)) {
            try {
                String nombreCliente = request.getParameter("nombreCliente");
                String metodoPago = request.getParameter("metodoPago");
                
                // Formato esperado de arrays: idProducto_Tipo_Precio_Cantidad
                // Como es HTML estándar sin frameworks JS complejos, leeremos arrays.
                String[] items = request.getParameterValues("itemVenta"); 
                
                if (items == null || items.length == 0) {
                    response.sendRedirect(request.getContextPath() + "/ventas?error=vacio");
                    return;
                }

                Venta v = new Venta();
                v.setNombreCliente(nombreCliente);
                v.setMetodoPago(metodoPago);
                v.setEstado("Completada");
                
                double total = 0;
                List<DetalleVenta> detalles = new ArrayList<>();
                
                for (String itemStr : items) {
                    // split por | o similar, ej: 5|Ganado|1200.00|1|Vaca Productora
                    String[] partes = itemStr.split("\\|");
                    if (partes.length >= 5) {
                        DetalleVenta dv = new DetalleVenta();
                        dv.setIdProducto(Integer.parseInt(partes[0]));
                        dv.setTipoProducto(partes[1]);
                        dv.setPrecioUnitario(Double.parseDouble(partes[2]));
                        dv.setCantidad(Double.parseDouble(partes[3]));
                        dv.setDescripcion(partes[4]);
                        dv.setSubtotal(dv.getPrecioUnitario() * dv.getCantidad());
                        
                        total += dv.getSubtotal();
                        detalles.add(dv);
                    }
                }
                
                v.setTotal(total);
                v.setDetalles(detalles);
                
                boolean exito = ventaDAO.registrarVentaCompleta(v);
                
                if(exito) {
                    response.sendRedirect(request.getContextPath() + "/ventas?success=1");
                } else {
                    response.sendRedirect(request.getContextPath() + "/ventas?error=db");
                }
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/ventas?error=format");
            }
        } else if ("nuevo_cliente".equals(action)) {
            try {
                Cliente c = new Cliente();
                c.setNombreCompleto(request.getParameter("nombreCompleto"));
                c.setDocumentoIdentidad(request.getParameter("documentoIdentidad"));
                c.setTelefono(request.getParameter("telefono"));
                c.setCorreo(request.getParameter("correo"));
                c.setDireccion(request.getParameter("direccion"));
                
                boolean exito = ventaDAO.registrarCliente(c);
                if (exito) {
                    response.sendRedirect(request.getContextPath() + "/ventas?success=cliente");
                } else {
                    response.sendRedirect(request.getContextPath() + "/ventas?error=db_cliente");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/ventas?error=format_cliente");
            }
        }
    }
}
