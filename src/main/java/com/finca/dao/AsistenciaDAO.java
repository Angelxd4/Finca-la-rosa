package com.finca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.finca.utils.DbConnection;

public class AsistenciaDAO {

    public String registrarAsistencia(String documento, String tipo) throws Exception {
        try (Connection conn = DbConnection.getConnection()) {
            // Obtener el usuario
            PreparedStatement psUser = conn.prepareStatement("SELECT id FROM usuarios WHERE document_id = ?");
            psUser.setString(1, documento);
            ResultSet rs = psUser.executeQuery();
            
            if (!rs.next()) {
                return "ERROR: Usuario no encontrado.";
            }
            int userId = rs.getInt("id");
            
            // Comprobar si existe un registro de hoy para este usuario, tomando el más reciente
            PreparedStatement psCheck = conn.prepareStatement(
                "SELECT id_asistencia, hora_entrada, hora_salida FROM asistencia " +
                "WHERE id_usuario = ? AND fecha = CURRENT_DATE " +
                "ORDER BY id_asistencia DESC LIMIT 1"
            );
            psCheck.setInt(1, userId);
            ResultSet rsCheck = psCheck.executeQuery();
            
            boolean existeRegistroHoy = rsCheck.next();

            if ("entrada".equalsIgnoreCase(tipo)) {
                if (existeRegistroHoy) {
                    return "ERROR: Ya registraste tu entrada el día de hoy.";
                } else {
                    PreparedStatement psIns = conn.prepareStatement(
                        "INSERT INTO asistencia (id_usuario, fecha, hora_entrada, estado_asistencia) " +
                        "VALUES (?, CURRENT_DATE, CURRENT_TIMESTAMP, 'A Tiempo')"
                    );
                    psIns.setInt(1, userId);
                    psIns.executeUpdate();
                    return "OK: Entrada registrada correctamente.";
                }
            } else if ("salida".equalsIgnoreCase(tipo)) {
                if (!existeRegistroHoy) {
                    return "ERROR: Debes registrar tu entrada primero.";
                } else {
                    if (rsCheck.getTimestamp("hora_salida") != null) {
                        return "ERROR: Ya registraste tu salida el día de hoy.";
                    } else {
                        int idAsistencia = rsCheck.getInt("id_asistencia");
                        PreparedStatement psUpd = conn.prepareStatement(
                            "UPDATE asistencia SET hora_salida = CURRENT_TIMESTAMP WHERE id_asistencia = ?"
                        );
                        psUpd.setInt(1, idAsistencia);
                        psUpd.executeUpdate();
                        return "OK: Salida registrada correctamente.";
                    }
                }
            } else {
                return "ERROR: Tipo de registro no válido.";
            }
        }
    }

    public java.util.List<com.finca.models.Asistencia> obtenerHistorial() {
        java.util.List<com.finca.models.Asistencia> lista = new java.util.ArrayList<>();
        String sql = "SELECT a.*, u.full_name, u.document_id, u.rol, u.profile_picture, u.cargo, u.departamento, u.arl, u.eps, u.tipo_sangre, u.telefono FROM asistencia a " +
                     "JOIN usuarios u ON a.id_usuario = u.id ORDER BY a.fecha DESC, a.hora_entrada DESC";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                com.finca.models.Asistencia a = new com.finca.models.Asistencia();
                a.setIdAsistencia(rs.getInt("id_asistencia"));
                a.setIdUsuario(rs.getInt("id_usuario"));
                a.setFecha(rs.getDate("fecha"));
                a.setHoraEntrada(rs.getTimestamp("hora_entrada"));
                a.setHoraSalida(rs.getTimestamp("hora_salida"));
                a.setEstadoAsistencia(rs.getString("estado_asistencia"));
                
                a.setNombreUsuario(rs.getString("full_name"));
                a.setDocumentoUsuario(rs.getString("document_id"));
                a.setRolUsuario(rs.getString("rol"));
                a.setProfilePicture(rs.getString("profile_picture"));
                a.setCargo(rs.getString("cargo"));
                a.setDepartamento(rs.getString("departamento"));
                a.setArl(rs.getString("arl"));
                a.setEps(rs.getString("eps"));
                a.setTipoSangre(rs.getString("tipo_sangre"));
                a.setTelefono(rs.getString("telefono"));
                
                lista.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public com.finca.models.Asistencia obtenerPorId(int id) {
        String sql = "SELECT a.*, u.full_name, u.document_id, u.rol, u.profile_picture, u.cargo, u.departamento, u.arl, u.eps, u.tipo_sangre, u.telefono FROM asistencia a " +
                     "JOIN usuarios u ON a.id_usuario = u.id WHERE a.id_asistencia = ?";
                     
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    com.finca.models.Asistencia a = new com.finca.models.Asistencia();
                    a.setIdAsistencia(rs.getInt("id_asistencia"));
                    a.setIdUsuario(rs.getInt("id_usuario"));
                    a.setFecha(rs.getDate("fecha"));
                    a.setHoraEntrada(rs.getTimestamp("hora_entrada"));
                    a.setHoraSalida(rs.getTimestamp("hora_salida"));
                    a.setEstadoAsistencia(rs.getString("estado_asistencia"));
                    
                    a.setNombreUsuario(rs.getString("full_name"));
                    a.setDocumentoUsuario(rs.getString("document_id"));
                    a.setRolUsuario(rs.getString("rol"));
                    a.setProfilePicture(rs.getString("profile_picture"));
                    a.setCargo(rs.getString("cargo"));
                    a.setDepartamento(rs.getString("departamento"));
                    a.setArl(rs.getString("arl"));
                    a.setEps(rs.getString("eps"));
                    a.setTipoSangre(rs.getString("tipo_sangre"));
                    a.setTelefono(rs.getString("telefono"));
                    
                    return a;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
