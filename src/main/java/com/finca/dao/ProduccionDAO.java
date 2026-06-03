package com.finca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.finca.models.Ordeno;
import com.finca.utils.DbConnection;

public class ProduccionDAO {

    // 1. Obtener la cantidad de litros de Leche Cruda actuales en inventario
    public double obtenerStockLeche() {
        double stock = 0;
        String sql = "SELECT stock FROM productos_lacteos WHERE codigo = 'LAC-001'";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) { stock = rs.getDouble("stock"); }
        } catch (SQLException e) { 
            // CORRECCIÓN: Manejo de error limpio
            System.err.println("Error al obtener stock de leche: " + e.getMessage()); 
        }
        return stock;
    }

    // 2. Obtener el historial de ordeños (uniendo con la tabla usuarios para ver quién supervisó)
    public List<Ordeno> obtenerHistorial() {
        List<Ordeno> lista = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name as supervisor FROM registro_ordeno o " +
                     "JOIN usuarios u ON o.supervisor_id = u.id ORDER BY o.fecha_hora DESC";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Ordeno o = new Ordeno();
                o.setIdOrdeno(rs.getInt("id_ordeno"));
                o.setFechaHora(rs.getTimestamp("fecha_hora"));
                o.setVacasOrdenadas(rs.getInt("vacas_ordenadas"));
                o.setLitrosObtenidos(rs.getDouble("litros_obtenidos"));
                o.setNombreSupervisor(rs.getString("supervisor"));
                o.setAsistentes(rs.getString("asistentes"));
                o.setObservaciones(rs.getString("observaciones"));
                lista.add(o);
            }
        } catch (SQLException e) { 
            // CORRECCIÓN: Manejo de error limpio
            System.err.println("Error al obtener historial de ordeños: " + e.getMessage()); 
        }
        return lista;
    }

    // 3. TRANSACCIÓN: Guardar el ordeño Y sumar la leche al inventario
    public boolean registrarOrdeno(Ordeno o) {
        String sqlInsert = "INSERT INTO registro_ordeno (vacas_ordenadas, litros_obtenidos, supervisor_id, asistentes, observaciones) VALUES (?, ?, ?, ?, ?)";
        String sqlUpdateStock = "UPDATE productos_lacteos SET stock = stock + ? WHERE codigo = 'LAC-001'";
        
        Connection conn = null;
        try {
            conn = DbConnection.getConnection();
            conn.setAutoCommit(false); // Iniciar Transacción

            // Paso A: Guardar el registro de ordeño
            try (PreparedStatement stmt1 = conn.prepareStatement(sqlInsert)) {
                stmt1.setInt(1, o.getVacasOrdenadas());
                stmt1.setDouble(2, o.getLitrosObtenidos());
                stmt1.setInt(3, o.getSupervisorId());
                stmt1.setString(4, o.getAsistentes());
                stmt1.setString(5, o.getObservaciones());
                stmt1.executeUpdate();
            }

            // Paso B: Sumar los litros al inventario de leche
            try (PreparedStatement stmt2 = conn.prepareStatement(sqlUpdateStock)) {
                stmt2.setDouble(1, o.getLitrosObtenidos());
                stmt2.executeUpdate();
            }

            conn.commit(); // Confirmar ambos cambios
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try { 
                    conn.rollback(); 
                } catch (SQLException ex) { 
                    // CORRECCIÓN: Eliminado printStackTrace
                    System.err.println("Error grave al intentar deshacer la transacción (rollback): " + ex.getMessage()); 
                }
            }
            // CORRECCIÓN: Eliminado printStackTrace
            System.err.println("Error durante el registro del ordeño: " + e.getMessage());
            return false;
        } finally {
            if (conn != null) {
                try { 
                    conn.setAutoCommit(true); 
                    conn.close(); 
                } catch (SQLException ex) { 
                    // CORRECCIÓN: Eliminado printStackTrace
                    System.err.println("Error al cerrar la conexión: " + ex.getMessage()); 
                }
            }
        }
    }
}