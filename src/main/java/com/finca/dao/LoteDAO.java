package com.finca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.finca.models.LoteProduccion;
import com.finca.utils.DbConnection;

public class LoteDAO {

    // 1. Obtener todos los lotes de producción
    public List<LoteProduccion> obtenerTodos() {
        List<LoteProduccion> lista = new ArrayList<>();
        String sql = "SELECT l.*, p.nombre as nombre_producto FROM lotes_produccion l " +
                     "JOIN productos_lacteos p ON l.id_producto = p.id_producto ORDER BY l.id_lote DESC";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                LoteProduccion lote = new LoteProduccion();
                lote.setIdLote(rs.getInt("id_lote"));
                lote.setIdProducto(rs.getInt("id_producto"));
                lote.setNombreProducto(rs.getString("nombre_producto"));
                lote.setCantidad(rs.getDouble("cantidad"));
                lote.setLitrosLecheUsados(rs.getDouble("litros_leche_usados"));
                lote.setEstado(rs.getString("estado"));
                lote.setFechaInicio(rs.getTimestamp("fecha_inicio"));
                lote.setFechaFin(rs.getTimestamp("fecha_fin"));
                lista.add(lote);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    // 2. Registrar un nuevo lote y RESTAR LA LECHE CRUDA (Transacción)
    public boolean iniciarProduccion(LoteProduccion lote) {
        String sqlInsertLote = "INSERT INTO lotes_produccion (id_producto, cantidad, litros_leche_usados, estado) VALUES (?, ?, ?, 'En Producción')";
        String sqlRestarLeche = "UPDATE productos_lacteos SET stock = stock - ? WHERE codigo = 'LAC-001' AND stock >= ?";
        
        Connection conn = null;
        try {
            conn = DbConnection.getConnection();
            conn.setAutoCommit(false); // Iniciamos transacción

            // Intentar restar la leche cruda
            try (PreparedStatement stmtLeche = conn.prepareStatement(sqlRestarLeche)) {
                stmtLeche.setDouble(1, lote.getLitrosLecheUsados());
                stmtLeche.setDouble(2, lote.getLitrosLecheUsados()); // Verificamos que haya suficiente stock
                int filasAfectadas = stmtLeche.executeUpdate();
                
                if (filasAfectadas == 0) {
                    conn.rollback(); // No hay leche suficiente, deshacemos todo
                    return false;
                }
            }

            // Crear el lote de producción
            try (PreparedStatement stmtLote = conn.prepareStatement(sqlInsertLote)) {
                stmtLote.setInt(1, lote.getIdProducto());
                stmtLote.setDouble(2, lote.getCantidad());
                stmtLote.setDouble(3, lote.getLitrosLecheUsados());
                stmtLote.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }

    // 3. Cambiar el estado del lote (Botones)
    public boolean cambiarEstado(int idLote, String nuevoEstado) {
        String sqlUpdateEstado = "UPDATE lotes_produccion SET estado = ? WHERE id_lote = ?";
        // Si el estado es 'En Venta', sumamos el queso al inventario
        String sqlSumarQueso = "UPDATE productos_lacteos SET stock = stock + (SELECT cantidad FROM lotes_produccion WHERE id_lote = ?) WHERE id_producto = (SELECT id_producto FROM lotes_produccion WHERE id_lote = ?)";

        Connection conn = null;
        try {
            conn = DbConnection.getConnection();
            conn.setAutoCommit(false);

            // Cambiamos el estado
            try (PreparedStatement stmtEstado = conn.prepareStatement(sqlUpdateEstado)) {
                stmtEstado.setString(1, nuevoEstado);
                stmtEstado.setInt(2, idLote);
                stmtEstado.executeUpdate();
            }

            // Si es para la venta, sumamos al inventario
            if ("En Venta".equals(nuevoEstado)) {
                try (PreparedStatement stmtQueso = conn.prepareStatement(sqlSumarQueso)) {
                    stmtQueso.setInt(1, idLote);
                    stmtQueso.setInt(2, idLote);
                    stmtQueso.executeUpdate();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }
}