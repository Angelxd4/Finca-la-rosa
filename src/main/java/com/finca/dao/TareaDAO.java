package com.finca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.finca.models.Tarea;
import com.finca.utils.DbConnection;

public class TareaDAO {

    // 1. Para los Administradores (Trae TODO)
    public List<Tarea> obtenerTodas() {
        List<Tarea> lista = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name, u.profile_picture " +
                     "FROM tareas t " +
                     "LEFT JOIN usuarios u ON t.asignado_a = u.id " +
                     "ORDER BY t.created_at DESC";
                     
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
             
            while (rs.next()) {
                lista.add(mapearTarea(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    // 2. Para los Operarios y Veterinarios (Trae SOLO sus tareas)
    public List<Tarea> obtenerPorAsignado(int idEmpleado) {
        List<Tarea> lista = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name, u.profile_picture " +
                     "FROM tareas t " +
                     "LEFT JOIN usuarios u ON t.asignado_a = u.id " +
                     "WHERE t.asignado_a = ? " +
                     "ORDER BY t.created_at DESC";
                     
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, idEmpleado);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearTarea(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public boolean crear(Tarea t) {
        String sql = "INSERT INTO tareas (titulo, descripcion, estado, fecha_limite, asignado_a, creado_por) VALUES (?, ?, 'Pendiente', ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setString(1, t.getTitulo());
            stmt.setString(2, t.getDescripcion());
            stmt.setDate(3, t.getFechaLimite());
            stmt.setInt(4, t.getAsignadoA());
            stmt.setInt(5, t.getCreadoPor());
            
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean actualizarEstado(int idTarea, String nuevoEstado) {
        // Asegúrate de que la columna en la BD sea id_tarea (si es 'id', cámbialo en esta query)
        String sql = "UPDATE tareas SET estado = ? WHERE id_tarea = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setString(1, nuevoEstado);
            stmt.setInt(2, idTarea);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean eliminar(int idTarea) {
        String sql = "DELETE FROM tareas WHERE id_tarea = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, idTarea);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // Método auxiliar para no repetir código
    private Tarea mapearTarea(ResultSet rs) throws Exception {
        Tarea t = new Tarea();
        t.setIdTarea(rs.getInt("id_tarea"));
        t.setTitulo(rs.getString("titulo"));
        t.setDescripcion(rs.getString("descripcion"));
        t.setEstado(rs.getString("estado"));
        t.setFechaLimite(rs.getDate("fecha_limite"));
        t.setAsignadoA(rs.getInt("asignado_a"));
        t.setCreadoPor(rs.getInt("creado_por"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        t.setAsignadoNombre(rs.getString("full_name"));
        t.setAsignadoFoto(rs.getString("profile_picture"));
        return t;
    }
}