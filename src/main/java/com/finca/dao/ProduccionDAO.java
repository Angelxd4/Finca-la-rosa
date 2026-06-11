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

    public ProduccionDAO() {
        actualizarEsquemaBD();
    }

    private void actualizarEsquemaBD() {
        String[] queries = {
            "ALTER TABLE sesiones_ordeno ADD COLUMN IF NOT EXISTS litros_venta numeric DEFAULT 0.00;",
            "ALTER TABLE sesiones_ordeno ADD COLUMN IF NOT EXISTS litros_fabrica numeric DEFAULT 0.00;",
            "ALTER TABLE sesiones_ordeno ADD COLUMN IF NOT EXISTS total_descarte numeric DEFAULT 0.00;",
            "ALTER TABLE sesiones_ordeno ADD COLUMN IF NOT EXISTS asignado boolean DEFAULT false;",
            "ALTER TABLE sesiones_ordeno ADD COLUMN IF NOT EXISTS descarte_vaciado boolean DEFAULT false;",
            "INSERT INTO productos_lacteos (codigo, nombre, descripcion, unidad_medida, stock, precio_unitario) VALUES ('LAC-002', 'Leche Cruda (Para Venta)', 'Leche refrigerada lista para cliente final', 'Litros', 0, 2000) ON CONFLICT (codigo) DO NOTHING;",
            "ALTER TABLE productos_lacteos ADD COLUMN IF NOT EXISTS ultima_actualizacion timestamp DEFAULT CURRENT_TIMESTAMP;"
        };
        try (Connection conn = DbConnection.getConnection(); Statement stmt = conn.createStatement()) {
            for (String q : queries) { stmt.execute(q); }
        } catch (Exception e) {}
    }

    public double obtenerStock(String codigo) {
        if ("LAC-001".equals(codigo) || "LAC-002".equals(codigo)) {
            String sqlClean = "UPDATE productos_lacteos SET stock = 0 WHERE codigo IN ('LAC-001', 'LAC-002') AND CURRENT_TIMESTAMP >= (ultima_actualizacion + INTERVAL '24 hours')";
            try (Connection conn = DbConnection.getConnection(); Statement st = conn.createStatement()) {
                st.executeUpdate(sqlClean);
            } catch(Exception e) {}
        }

        double stock = 0;
        String sql = "SELECT stock FROM productos_lacteos WHERE codigo = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, codigo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) { stock = rs.getDouble("stock"); }
            }
        } catch (SQLException e) { System.err.println("Error stock: " + e.getMessage()); }
        return stock;
    }

    private String getWhereClause(String filtro) {
        if ("ayer".equals(filtro)) return "DATE(fecha_hora) = CURRENT_DATE - INTERVAL '1 day'";
        if ("semana".equals(filtro)) return "fecha_hora >= date_trunc('week', CURRENT_DATE)";
        if ("semana_pasada".equals(filtro)) return "fecha_hora >= date_trunc('week', CURRENT_DATE - INTERVAL '1 week') AND fecha_hora < date_trunc('week', CURRENT_DATE)";
        if ("mes".equals(filtro)) return "date_trunc('month', fecha_hora) = date_trunc('month', CURRENT_DATE)";
        if ("mes_pasado".equals(filtro)) return "date_trunc('month', fecha_hora) = date_trunc('month', CURRENT_DATE - INTERVAL '1 month')";
        if ("todo".equals(filtro)) return "1=1";
        return "DATE(fecha_hora) = CURRENT_DATE"; 
    }

    public double[] obtenerEstadisticas(String filtro) {
        double[] stats = new double[7];
        String where = getWhereClause(filtro);
        
        String sql = "SELECT " +
            "COALESCE(SUM(CASE WHEN EXTRACT(HOUR FROM fecha_hora) < 12 THEN total_litros ELSE 0 END), 0) as manana, " +
            "COALESCE(SUM(CASE WHEN EXTRACT(HOUR FROM fecha_hora) >= 12 THEN total_litros ELSE 0 END), 0) as tarde, " +
            "COALESCE(SUM(CASE WHEN descarte_vaciado = false THEN total_descarte ELSE 0 END), 0) as descarte_pendiente, " +
            "COALESCE(SUM(CASE WHEN EXTRACT(HOUR FROM fecha_hora) < 12 AND asignado = false THEN total_litros ELSE 0 END), 0) as pend_manana, " +
            "COALESCE(SUM(CASE WHEN EXTRACT(HOUR FROM fecha_hora) >= 12 AND asignado = false THEN total_litros ELSE 0 END), 0) as pend_tarde, " +
            "COALESCE(SUM(litros_fabrica), 0) as asig_fab, " +
            "COALESCE(SUM(litros_venta), 0) as asig_venta " +
            "FROM sesiones_ordeno WHERE " + where;
            
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                stats[0] = rs.getDouble("manana");
                stats[1] = rs.getDouble("tarde");
                stats[2] = rs.getDouble("descarte_pendiente");
                stats[3] = rs.getDouble("pend_manana");
                stats[4] = rs.getDouble("pend_tarde");
                stats[5] = rs.getDouble("asig_fab");
                stats[6] = rs.getDouble("asig_venta");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return stats;
    }

    public boolean vaciarDescartePendiente(String filtro) {
        String where = getWhereClause(filtro);
        String sql = "UPDATE sesiones_ordeno SET descarte_vaciado = true WHERE descarte_vaciado = false AND total_descarte > 0 AND " + where;
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate(); 
            return true;
        } catch (SQLException e) {
            System.err.println("Error vaciando descarte: " + e.getMessage());
            return false;
        }
    }

    // =========================================================================
    // LÓGICA BIOLÓGICA: Verifica si la vaca ya se ordeñó en ese mismo turno
    // =========================================================================
    public boolean fueOrdenadaEnTurno(int idBovino, java.sql.Timestamp fechaHora) {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTime(fechaHora);
        boolean isMorning = cal.get(java.util.Calendar.HOUR_OF_DAY) < 12;
        
        // Comprueba si el registro previo ocurrió en la mañana (<12) o en la tarde (>=12)
        String timeCondition = isMorning ? "EXTRACT(HOUR FROM s.fecha_hora) < 12" : "EXTRACT(HOUR FROM s.fecha_hora) >= 12";
        
        String sql = "SELECT COUNT(*) FROM detalles_ordeno d " +
                     "JOIN sesiones_ordeno s ON d.id_sesion = s.id_sesion " +
                     "WHERE d.id_bovino = ? AND DATE(s.fecha_hora) = DATE(?) AND " + timeCondition;
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idBovino);
            stmt.setTimestamp(2, fechaHora);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true; // Ya se ordeñó en este turno
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Ordeno> obtenerHistorial(String filtro) {
        List<Ordeno> lista = new ArrayList<>();
        String where = getWhereClause(filtro);
        String sqlSesion = "SELECT s.*, u.full_name as supervisor FROM sesiones_ordeno s LEFT JOIN usuarios u ON s.supervisor_id = u.id WHERE " + where + " ORDER BY s.fecha_hora DESC";
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
                o.setObservaciones(rs1.getString("observaciones"));
                o.setLitrosVenta(rs1.getDouble("litros_venta"));
                o.setLitrosFabrica(rs1.getDouble("litros_fabrica"));
                o.setTotalDescarte(rs1.getDouble("total_descarte"));
                o.setAsignado(rs1.getBoolean("asignado"));
                
                boolean descarVaciado = true;
                try { descarVaciado = rs1.getBoolean("descarte_vaciado"); } catch(Exception e){}
                o.setObservaciones(o.getObservaciones() + (descarVaciado ? "[VACIADO]" : ""));
                
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
        String sqlSesion = "INSERT INTO sesiones_ordeno (fecha_hora, lugar, supervisor_id, total_vacas, total_litros, promedio_litros, observaciones, litros_venta, litros_fabrica, total_descarte, asignado, descarte_vaciado) VALUES (?, ?, ?, ?, ?, ?, ?, 0, 0, ?, false, false)";
        String sqlDetalle = "INSERT INTO detalles_ordeno (id_sesion, id_bovino, litros_obtenidos) VALUES (?, ?, ?)";
        
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
                stmt1.setString(7, sesion.getObservaciones()); 
                stmt1.setDouble(8, sesion.getTotalDescarte()); 
                
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

            conn.commit(); 
            return true;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
            return false;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) {}
        }
    }

    public boolean asignarLeche(String filtro, String turno, double porcentajeFabrica) {
        String where = getWhereClause(filtro);
        String turnoWhere = "";
        if ("manana".equals(turno)) turnoWhere = " AND EXTRACT(HOUR FROM fecha_hora) < 12 ";
        else if ("tarde".equals(turno)) turnoWhere = " AND EXTRACT(HOUR FROM fecha_hora) >= 12 ";
        
        String sqlSelect = "SELECT id_sesion, total_litros FROM sesiones_ordeno WHERE asignado = false AND " + where + turnoWhere;
        String sqlUpdateSesion = "UPDATE sesiones_ordeno SET litros_fabrica = ?, litros_venta = ?, asignado = true WHERE id_sesion = ?";
        String sqlUpdateFabrica = "UPDATE productos_lacteos SET stock = stock + ?, ultima_actualizacion = CURRENT_TIMESTAMP WHERE codigo = 'LAC-001'";
        String sqlUpdateVenta = "UPDATE productos_lacteos SET stock = stock + ?, ultima_actualizacion = CURRENT_TIMESTAMP WHERE codigo = 'LAC-002'";
        
        Connection conn = null;
        try {
            conn = DbConnection.getConnection();
            conn.setAutoCommit(false);
            
            double totalParaFabrica = 0;
            double totalParaVenta = 0;
            
            try (PreparedStatement selectStmt = conn.prepareStatement(sqlSelect);
                 ResultSet rs = selectStmt.executeQuery();
                 PreparedStatement updateStmt = conn.prepareStatement(sqlUpdateSesion)) {
                
                while(rs.next()) {
                    int id = rs.getInt("id_sesion");
                    double total = rs.getDouble("total_litros");
                    double aFabrica = total * (porcentajeFabrica / 100.0);
                    double aVenta = total - aFabrica; 
                    
                    updateStmt.setDouble(1, aFabrica);
                    updateStmt.setDouble(2, aVenta);
                    updateStmt.setInt(3, id);
                    updateStmt.addBatch();
                    
                    totalParaFabrica += aFabrica;
                    totalParaVenta += aVenta;
                }
                updateStmt.executeBatch();
            }
            
            if (totalParaFabrica > 0 || totalParaVenta > 0) {
                try (PreparedStatement pFab = conn.prepareStatement(sqlUpdateFabrica)) {
                    pFab.setDouble(1, totalParaFabrica);
                    pFab.executeUpdate();
                }
                try (PreparedStatement pVen = conn.prepareStatement(sqlUpdateVenta)) {
                    pVen.setDouble(1, totalParaVenta);
                    pVen.executeUpdate();
                }
            }
            
            conn.commit();
            return true;
        } catch(SQLException e) {
            if(conn != null) try{ conn.rollback(); }catch(Exception ex){}
            e.printStackTrace();
            return false;
        } finally {
            if(conn != null) try{ conn.setAutoCommit(true); conn.close(); }catch(Exception ex){}
        }
    }
}