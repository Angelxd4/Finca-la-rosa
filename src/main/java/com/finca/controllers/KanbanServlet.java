package com.finca.controllers;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Date;
import java.util.Base64;

import com.finca.dao.TareaDAO;
import com.finca.dao.UsuarioDAO;
import com.finca.models.Tarea;
import com.finca.models.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/kanban")
public class KanbanServlet extends HttpServlet {

    private final TareaDAO tareaDAO = new TareaDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    // =========================================================
    // 🔴 CREDENCIALES DE TWILIO OFICIALES
    // =========================================================
    private final String TWILIO_ACCOUNT_SID = "AQUI_VA_EL_SID"; 
    private final String TWILIO_AUTH_TOKEN = "AQUI_VA_EL_TOKEN"; 
    private final String TWILIO_NUMBER = "+14155238886";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        if (usuario == null) {
            response.sendRedirect("login");
            return;
        }

        // Lógica de roles
        String r = usuario.getRol() != null ? usuario.getRol() : "3";
        boolean esAdmin = r.equals("1") || r.equalsIgnoreCase("Administrador") || r.equals("2") || r.equalsIgnoreCase("Veterinario");

        if (esAdmin) {
            request.setAttribute("tareas", tareaDAO.obtenerTodas());
            request.setAttribute("empleados", usuarioDAO.obtenerTodos()); 
            request.setAttribute("tituloTablero", "Tablero General");
            request.setAttribute("subTitulo", "Supervisa y delega tareas a los operarios.");
        } else {
            request.setAttribute("tareas", tareaDAO.obtenerPorAsignado(usuario.getId()));
            request.setAttribute("tituloTablero", "Mis Tareas Asignadas");
            request.setAttribute("subTitulo", "Arrastra tus tareas a 'En Progreso' o 'Completada'.");
        }
        
        request.setAttribute("esAdmin", esAdmin); 

        String msg = request.getParameter("msg");
        String error = request.getParameter("error");

        if ("creada".equals(msg)) request.setAttribute("successMessage", "Tarea asignada. Se notificó al empleado por WhatsApp.");
        if ("eliminada".equals(msg)) request.setAttribute("successMessage", "Tarea eliminada del tablero.");
        if ("nopermiso".equals(error)) request.setAttribute("errorMessage", "No tienes permisos para hacer eso.");

        request.getRequestDispatcher("kanban.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario usuarioLogueado = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        String action = request.getParameter("action");
        
        String r = usuarioLogueado.getRol() != null ? usuarioLogueado.getRol() : "3";
        boolean esAdmin = r.equals("1") || r.equalsIgnoreCase("Administrador") || r.equals("2") || r.equalsIgnoreCase("Veterinario");

        // ACCIÓN 1: MOVER TAREA (AJAX)
        if ("mover".equals(action)) {
            int idTarea = Integer.parseInt(request.getParameter("idTarea"));
            String nuevoEstado = request.getParameter("estado");
            boolean exito = tareaDAO.actualizarEstado(idTarea, nuevoEstado);
            response.setContentType("text/plain");
            response.getWriter().write(exito ? "OK" : "ERROR");
            return;
        }

        // ACCIÓN 2: CREAR TAREA Y ENVIAR WHATSAPP AUTOMÁTICO
        if ("crear".equals(action)) {
            if (!esAdmin) { response.sendRedirect("kanban?error=nopermiso"); return; }
            
            Tarea t = new Tarea();
            t.setTitulo(request.getParameter("titulo"));
            t.setDescripcion(request.getParameter("descripcion"));
            
            String fechaStr = request.getParameter("fechaLimite");
            if(fechaStr != null && !fechaStr.isEmpty()) t.setFechaLimite(Date.valueOf(fechaStr));
            
            int idAsignado = Integer.parseInt(request.getParameter("asignadoA"));
            t.setAsignadoA(idAsignado);
            t.setCreadoPor(usuarioLogueado.getId());

            tareaDAO.crear(t);

            // Obtener el teléfono del empleado desde la BD
            String[] infoEmp = obtenerInfoEmpleado(idAsignado);
            String waPhone = infoEmp[0].replaceAll("[^0-9]", ""); 
            
            // Si tiene 10 dígitos (Colombia), agrega el prefijo 57
            if(waPhone.length() == 10 && waPhone.startsWith("3")) {
                waPhone = "57" + waPhone; 
            }
            
            // Si el empleado tiene un número registrado, disparar el mensaje
            if (!waPhone.isEmpty()) {
                String fechaLim = t.getFechaLimite() != null ? t.getFechaLimite().toString() : "Sin fecha límite";
                
                // =========================================================
                // MENSAJE MEJORADO Y CORPORATIVO
                // =========================================================
                String mensaje = "🐄 *FINCA LA ROSA | Sistema de Gestión*\n"
                               + "--------------------------------------------------\n"
                               + "¡Hola, *" + infoEmp[1] + "*! 👋\n"
                               + "Se te ha asignado una nueva labor operativa:\n\n"
                               + "📋 *Tarea:* " + t.getTitulo() + "\n"
                               + "📝 *Instrucciones:* " + t.getDescripcion() + "\n"
                               + "⏳ *Fecha Límite:* " + fechaLim + "\n\n"
                               + "🚜 *Nota:* Por favor, cuando finalices esta labor, ingresa al Tablero Kanban y muévela a la columna de 'Completadas'.\n\n"
                               + "¡Que tengas un excelente turno! 🌾";
                
                enviarWhatsAppAutomatico(waPhone, mensaje);
            }

            response.sendRedirect("kanban?msg=creada");
            return;
        } 
        
        // ACCIÓN 3: ELIMINAR TAREA
        if ("eliminar".equals(action)) {
            if (!esAdmin) { response.sendRedirect("kanban?error=nopermiso"); return; }
            int idTarea = Integer.parseInt(request.getParameter("idTarea"));
            tareaDAO.eliminar(idTarea);
            response.sendRedirect("kanban?msg=eliminada");
            return;
        }
    }

    // UTILIDAD PARA BUSCAR TELÉFONO EN BD
    private String[] obtenerInfoEmpleado(int id) {
        String[] info = new String[]{"", "Empleado"}; 
        String sql = "SELECT telefono, full_name FROM usuarios WHERE id = ?";
        try (java.sql.Connection conn = com.finca.utils.DbConnection.getConnection();
             java.sql.PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (java.sql.ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    info[0] = rs.getString("telefono") != null ? rs.getString("telefono") : "";
                    info[1] = rs.getString("full_name") != null ? rs.getString("full_name") : "Empleado";
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return info;
    }

    // =========================================================
    // 🚀 ENVÍO OFICIAL POR TWILIO (API REST)
    // =========================================================
    private void enviarWhatsAppAutomatico(String telefono, String mensaje) {
        try {
            // Twilio requiere que el número inicie con un '+'
            if (!telefono.startsWith("+")) {
                telefono = "+" + telefono;
            }

            String urlString = "https://api.twilio.com/2010-04-01/Accounts/" + TWILIO_ACCOUNT_SID + "/Messages.json";
            URL url = new URL(urlString);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setDoOutput(true);

            // Autenticación Básica (Usuario:Password en Base64)
            String auth = TWILIO_ACCOUNT_SID + ":" + TWILIO_AUTH_TOKEN;
            String encodedAuth = Base64.getEncoder().encodeToString(auth.getBytes("UTF-8"));
            con.setRequestProperty("Authorization", "Basic " + encodedAuth);
            con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            // Cuerpo del mensaje según las reglas de Twilio
            String postData = "To=" + URLEncoder.encode("whatsapp:" + telefono, "UTF-8")
                            + "&From=" + URLEncoder.encode("whatsapp:" + TWILIO_NUMBER, "UTF-8")
                            + "&Body=" + URLEncoder.encode(mensaje, "UTF-8");

            // Ejecutar la petición
            try (OutputStream os = con.getOutputStream()) {
                byte[] input = postData.getBytes("UTF-8");
                os.write(input, 0, input.length);
            }

            // Validar respuesta
            int responseCode = con.getResponseCode();
            if (responseCode == 201 || responseCode == 200) {
                System.out.println("✅ WhatsApp enviado por Twilio a: " + telefono);
            } else {
                System.out.println("❌ Error enviando WhatsApp por Twilio. Código: " + responseCode);
                try(BufferedReader br = new BufferedReader(new InputStreamReader(con.getErrorStream(), "UTF-8"))) {
                    StringBuilder err = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        err.append(line.trim());
                    }
                    System.out.println("Detalle del error Twilio: " + err.toString());
                }
            }
        } catch (Exception e) {
            System.err.println("❌ Fallo interno enviando WhatsApp por Twilio: " + e.getMessage());
        }
    }
}