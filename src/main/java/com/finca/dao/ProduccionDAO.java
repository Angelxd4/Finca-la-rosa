package com.finca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.finca.models.DetalleOrdeno;
import com.finca.models.Ordeno;
import com.finca.utils.DbConnection;

public class ProduccionDAO {

    public double obtenerStockLeche() {
        double stock = 0;
        String sql = "SELECT stock FROM productos_lacteos WHERE codigo = 'LAC-001'";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) { stock = rs.getDouble("stock"); }
        } catch (SQLException e) { System.err.println("Error stock: " + e.getMessage()); }
        return stock;
    }

    public List<Ordeno> obtenerHistorial() {
        List<Ordeno> lista = new ArrayList<>();
        String sqlSesion = "SELECT s.*, u.full_name as supervisor FROM sesiones_ordeno s LEFT JOIN usuarios u ON s.supervisor_id = u.id ORDER BY s.fecha_hora DESC";
        String sqlDetalle = "SELECT d.*, b.numero_arete, b.image_url FROM detalles_ordeno d JOIN bovinos b ON d.id_bovino = b.id_bovino WHERE d.id_sesion = ?";
                     
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt1 = conn.prepareStatement(sqlSesion);
             ResultSet rs1 = stmt1.executeQuery()) {
             
            while (rs1.next()) {
                Ordeno o = new Ordeno();
                o.setIdOrdeno(rs1.getInt("id_sesion"));
                o.setFechaHora(rs1.getTimestamp("fecha_hora"));
                o.setLugar(rs1.getString("lugar"));
                o.setTotalVacas(rs1.getInt("total_vacas"));
                o.setTotalLitros(rs1.getDouble("total_litros"));
                o.setPromedioLitros(rs1.getDouble("promedio_litros"));
                o.setNombreSupervisor(rs1.getString("supervisor"));
                
                // CORRECCIÓN: Leemos las observaciones desde la base de datos
                o.setObservaciones(rs1.getString("observaciones"));
                
                // Traer las vacas de esta sesión específica
                List<DetalleOrdeno> detalles = new ArrayList<>();
                try (PreparedStatement stmt2 = conn.prepareStatement(sqlDetalle)) {
                    stmt2.setInt(1, o.getIdOrdeno());
                    try (ResultSet rs2 = stmt2.executeQuery()) {
                        while(rs2.next()) {
                            DetalleOrdeno det = new DetalleOrdeno();
                            det.setIdBovino(rs2.getInt("id_bovino"));
                            det.setNumeroArete(rs2.getString("numero_arete"));
                            det.setImageUrl(rs2.getString("image_url"));
                            det.setLitrosObtenidos(rs2.getDouble("litros_obtenidos"));
                            detalles.add(det);
                        }
                    }
                }
                o.setDetalles(detalles);
                lista.add(o);
            }
        } catch (SQLException e) { System.err.println("Error historial: " + e.getMessage()); }
        return lista;
    }

    public boolean registrarSesion(Ordeno sesion) {
        // CORRECCIÓN: Añadimos 'observaciones' a la consulta de guardado (INSERT)
        String sqlSesion = "INSERT INTO sesiones_ordeno (fecha_hora, lugar, supervisor_id, total_vacas, total_litros, promedio_litros, observaciones) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlDetalle = "INSERT INTO detalles_ordeno (id_sesion, id_bovino, litros_obtenidos) VALUES (?, ?, ?)";
        String sqlUpdateStock = "UPDATE productos_lacteos SET stock = stock + ? WHERE codigo = 'LAC-001'";
        
        Connection conn = null;
        try {
            conn = DbConnection.getConnection();
            conn.setAutoCommit(false); 

            int idSesionGenerado = 0;
            try (PreparedStatement stmt1 = conn.prepareStatement(sqlSesion, Statement.RETURN_GENERATED_KEYS)) {
                stmt1.setTimestamp(1, sesion.getFechaHora());
                stmt1.setString(2, sesion.getLugar());
                stmt1.setInt(3, sesion.getSupervisorId());
                stmt1.setInt(4, sesion.getTotalVacas());
                stmt1.setDouble(5, sesion.getTotalLitros());
                stmt1.setDouble(6, sesion.getPromedioLitros());
                
                // CORRECCIÓN: Inyectamos el texto de la observación
                stmt1.setString(7, sesion.getObservaciones()); 
                
                stmt1.executeUpdate();
                
                try (ResultSet generatedKeys = stmt1.getGeneratedKeys()) {
                    if (generatedKeys.next()) { idSesionGenerado = generatedKeys.getInt(1); }
                }
            }

            try (PreparedStatement stmt2 = conn.prepareStatement(sqlDetalle)) {
                for(DetalleOrdeno det : sesion.getDetalles()) {
                    stmt2.setInt(1, idSesionGenerado);
                    stmt2.setInt(2, det.getIdBovino());
                    stmt2.setDouble(3, det.getLitrosObtenidos());
                    stmt2.addBatch();
                }
                stmt2.executeBatch();
            }

            try (PreparedStatement stmt3 = conn.prepareStatement(sqlUpdateStock)) {
                stmt3.setDouble(1, sesion.getTotalLitros());
                stmt3.executeUpdate();
            }

            conn.commit(); 
            return true;

        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
            System.err.println("Error registro sesión: " + e.getMessage());
            return false;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) {}
        }
    }
}