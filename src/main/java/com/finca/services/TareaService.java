package com.finca.services;

import com.finca.dao.NotificacionDAO;
import com.finca.dao.TareaDAO;
import com.finca.dao.UsuarioDAO;
import com.finca.models.Tarea;
import com.finca.utils.WhatsAppService;

import java.util.List;

public class TareaService {

    private final TareaDAO tareaDAO = new TareaDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final NotificacionDAO notificacionDAO = new NotificacionDAO();

    public List<Tarea> obtenerTodas() {
        return tareaDAO.obtenerTodas();
    }

    public List<Tarea> obtenerPorAsignado(int idUsuario) {
        return tareaDAO.obtenerPorAsignado(idUsuario);
    }

    public boolean actualizarEstado(int idTarea, String nuevoEstado) {
        // Obtenemos la tarea antes para saber quién la creó
        Tarea t = null;
        for (Tarea temp : tareaDAO.obtenerTodas()) {
            if (temp.getIdTarea() == idTarea) {
                t = temp;
                break;
            }
        }
        boolean ok = tareaDAO.actualizarEstado(idTarea, nuevoEstado);
        if (ok && t != null) {
            notificacionDAO.crearNotificacion(t.getCreadoPor(), "Estado de Tarea Actualizado", 
                "El empleado " + t.getAsignadoNombre() + " cambió la tarea '" + t.getTitulo() + "' a " + nuevoEstado, "info", "kanban.jsp");
        }
        return ok;
    }

    public void eliminarTarea(int idTarea) {
        tareaDAO.eliminar(idTarea);
    }

    public void crearTareaYNotificar(Tarea t, String nombreCreador) {
        tareaDAO.crear(t);
        notificacionDAO.crearNotificacion(t.getAsignadoA(), "Nueva Tarea Asignada", 
            "El administrador " + nombreCreador + " te asignó: " + t.getTitulo(), "info", "kanban.jsp");

        String[] infoEmp = obtenerInfoEmpleado(t.getAsignadoA());
        String waPhone = infoEmp[0].replaceAll("[^0-9]", ""); 
        
        if (waPhone.length() == 10 && waPhone.startsWith("3")) {
            waPhone = "57" + waPhone; 
        }
        
        if (!waPhone.isEmpty()) {
            String fechaLim = t.getFechaLimite() != null ? t.getFechaLimite().toString() : "Sin fecha límite";
            
            String mensaje = "🐄 *FINCA LA ROSA | Sistema de Gestión*\n"
                           + "--------------------------------------------------\n"
                           + "¡Hola, *" + infoEmp[1] + "*! 👋\n"
                           + "Se te ha asignado una nueva labor operativa:\n\n"
                           + "📋 *Tarea:* " + t.getTitulo() + "\n"
                           + "📝 *Instrucciones:* " + t.getDescripcion() + "\n"
                           + "⏳ *Fecha Límite:* " + fechaLim + "\n\n"
                           + "🚜 *Nota:* Por favor, cuando finalices esta labor, ingresa al Tablero Kanban y muévela a la columna de 'Completadas'.\n\n"
                           + "¡Que tengas un excelente turno! 🌾";
            
            WhatsAppService.enviarWhatsAppAutomatico(waPhone, mensaje);
        }
    }

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
}
