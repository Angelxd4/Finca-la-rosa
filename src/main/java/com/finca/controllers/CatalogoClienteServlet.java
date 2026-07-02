package com.finca.controllers;

import java.io.IOException;
import java.util.List;

import com.finca.dao.ProductoLacteoDAO;
import com.finca.models.ProductoLacteo;
import com.finca.models.Usuario;
import com.finca.services.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonElement;
import com.finca.dao.VentaDAO;
import com.finca.dao.BovinoDAO;
import com.finca.models.Venta;
import com.finca.models.Bovino;
import com.finca.models.DetalleVenta;
import com.finca.utils.EmailService;
import java.util.ArrayList;

@WebServlet("/catalogo")
public class CatalogoClienteServlet extends HttpServlet {

    private final ProductoLacteoDAO productoLacteoDAO = new ProductoLacteoDAO();
    private final BovinoDAO bovinoDAO = new BovinoDAO();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Verificar si está autenticado y tiene rol de Cliente (u otro)
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }

        Usuario usuarioLogueado = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        request.setAttribute("nombreCorto", authService.obtenerNombreCorto(usuarioLogueado));
        request.setAttribute("rolTexto", authService.obtenerRolTexto(usuarioLogueado));

        List<ProductoLacteo> todos = productoLacteoDAO.obtenerTodos();
        request.setAttribute("productos", todos);

        List<Bovino> bovinosVenta = bovinoDAO.obtenerPorClasificacion("Venta");
        request.setAttribute("bovinosVenta", bovinosVenta);

        request.getRequestDispatcher("catalogo-cliente.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("checkout".equals(action)) {
            handleCheckout(request, response);
        }
    }

    private void handleCheckout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        Usuario usuarioLogueado = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        JsonObject responseJson = new JsonObject();

        if (usuarioLogueado == null) {
            responseJson.addProperty("success", false);
            responseJson.addProperty("message", "No autenticado.");
            response.getWriter().print(responseJson);
            return;
        }

        try {
            BufferedReader reader = request.getReader();
            Gson gson = new Gson();
            JsonObject cartData = gson.fromJson(reader, JsonObject.class);
            JsonArray items = cartData.getAsJsonArray("items");
            double total = cartData.get("total").getAsDouble();

            Venta venta = new Venta();
            venta.setNombreCliente(usuarioLogueado.getFullName());
            venta.setMetodoPago("Mixto"); // Puede ser Lácteo o Ganado
            venta.setEstado("Pendiente");
            venta.setTotal(total);

            List<DetalleVenta> detalles = new ArrayList<>();
            for (JsonElement element : items) {
                JsonObject item = element.getAsJsonObject();
                DetalleVenta det = new DetalleVenta();
                det.setIdProducto(item.get("idProducto").getAsInt());
                // Chequeamos el tipo que viene del frontend
                String tipo = item.has("tipo") ? item.get("tipo").getAsString() : "Lacteo";
                det.setTipoProducto(tipo);
                det.setCantidad(item.get("cantidad").getAsDouble());
                det.setSubtotal(item.get("subtotal").getAsDouble());
                detalles.add(det);
            }
            venta.setDetalles(detalles);

            VentaDAO ventaDAO = new VentaDAO();
            boolean ok = ventaDAO.registrarVentaCompleta(venta);

            if (ok) {
                // Verificar si hay ganado para personalizar el mensaje
                boolean hasGanado = false;
                for (DetalleVenta det : detalles) {
                    if ("Ganado".equals(det.getTipoProducto())) {
                        hasGanado = true;
                        break;
                    }
                }

                // Enviar correo de confirmación
                String subject = "Finca La Rosa - Confirmación de Pedido #" + System.currentTimeMillis();
                String emailBody = "<div style='font-family: Arial, sans-serif; padding: 20px; color: #333;'>"
                        + "<h2 style='color: #464704;'>¡Gracias por tu pedido, " + usuarioLogueado.getFullName() + "!</h2>"
                        + "<p>Hemos recibido tu solicitud correctamente y tu pedido está en estado <strong>Pendiente</strong>.</p>"
                        + "<p>Para coordinar el pago, por favor escríbenos a nuestro WhatsApp oficial: <strong>+57 310 000 0000</strong>.</p>";
                
                if (hasGanado) {
                    emailBody += "<p style='color: #B5651D; font-weight: bold;'>Como tu pedido incluye ganado, por favor indícanos en WhatsApp la dirección de tu finca para coordinar la logística de envío.</p>";
                }
                
                emailBody += "<br><p>Atentamente,<br>El equipo de Finca La Rosa</p></div>";
                
                // Enviar el correo en un hilo separado para no bloquear la respuesta al cliente
                final String destinatario = usuarioLogueado.getEmail();
                final String body = emailBody;
                new Thread(() -> {
                    EmailService.enviarEmail(destinatario, subject, body);
                }).start();

                responseJson.addProperty("success", true);
                responseJson.addProperty("message", "Pedido realizado con éxito. Te enviamos un correo con las instrucciones.");
            } else {
                responseJson.addProperty("success", false);
                responseJson.addProperty("message", "Error al registrar el pedido.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            responseJson.addProperty("success", false);
            responseJson.addProperty("message", "Fallo al procesar el carrito.");
        }
        
        response.getWriter().print(responseJson);
    }
}
