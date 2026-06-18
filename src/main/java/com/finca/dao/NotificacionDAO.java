package com.finca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.finca.models.Notificacion;
import com.finca.utils.DbConnection;
import java.sql.Statement;

public class NotificacionDAO {

    public NotificacionDAO() {
        actualizarEsquemaBD();
    }

    private void actualizarEsquemaBD() {
        String sql = "CREATE TABLE IF NOT EXISTS notificaciones (" +
                     "id_notificacion SERIAL PRIMARY KEY," +
                     "id_usuario integer NOT NULL," +
                     "titulo character varying NOT NULL," +
                     "mensaje text NOT NULL," +
                     "leida boolean DEFAULT false," +
                     "tipo character varying," +
                     "link character varying," +
                     "created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP," +
                     "CONSTRAINT notificaciones_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES usuarios(id)" +
                     ");";
        try (Connection conn = DbConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean crearNotificacion(int idUsuario, String titulo, String mensaje, String tipo, String link) {
        String sql = "INSERT INTO notificaciones (id_usuario, titulo, mensaje, tipo, link) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, idUsuario);
            ps.setString(2, titulo);
            ps.setString(3, mensaje);
            ps.setString(4, tipo);
            ps.setString(5, link);
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Notificacion> obtenerPorUsuario(int idUsuario) {
        List<Notificacion> lista = new ArrayList<>();
        String sql = "SELECT * FROM notificaciones WHERE id_usuario = ? ORDER BY created_at DESC";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notificacion n = new Notificacion();
                    n.setIdNotificacion(rs.getInt("id_notificacion"));
                    n.setIdUsuario(rs.getInt("id_usuario"));
                    n.setTitulo(rs.getString("titulo"));
                    n.setMensaje(rs.getString("mensaje"));
                    n.setLeida(rs.getBoolean("leida"));
                    n.setTipo(rs.getString("tipo"));
                    n.setLink(rs.getString("link"));
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    n.setTiempoRelativo(calcularTiempoRelativo(n.getCreatedAt()));
                    lista.add(n);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public int contarNoLeidas(int idUsuario) {
        String sql = "SELECT COUNT(*) FROM notificaciones WHERE id_usuario = ? AND leida = false";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean marcarComoLeidas(int idUsuario) {
        String sql = "UPDATE notificaciones SET leida = true WHERE id_usuario = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private String calcularTiempoRelativo(Timestamp ts) {
        if (ts == null) return "";
        long dif = System.currentTimeMillis() - ts.getTime();
        long min = dif / 60000;
        if (min < 1) return "Ahora";
        if (min < 60) return "Hace " + min + " min";
        long horas = min / 60;
        if (horas < 24) return "Hace " + horas + " h";
        long dias = horas / 24;
        return "Hace " + dias + " d";
    }
}
