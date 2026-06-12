package com.finca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.finca.models.Usuario;
import com.finca.utils.DbConnection;

public class UsuarioDAO {

    // ==========================================
    // 1. MÉTODOS CRUD CLÁSICOS (Los que faltaban)
    // ==========================================

    public List<Usuario> obtenerTodos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios ORDER BY id ASC";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                lista.add(mapearUsuario(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean registrar(Usuario u) {
        String sql = "INSERT INTO usuarios (full_name, document_id, email, password, rol) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setString(1, u.getFullName());
            stmt.setString(2, u.getDocumentId());
            stmt.setString(3, u.getEmail());
            stmt.setString(4, u.getPassword());
            stmt.setString(5, u.getRol());
            
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizar(Usuario u) {
        // Este es el actualizar básico del panel de empleados (Admin)
        String sql = "UPDATE usuarios SET full_name=?, document_id=?, email=?, rol=? WHERE id=?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setString(1, u.getFullName());
            stmt.setString(2, u.getDocumentId());
            stmt.setString(3, u.getEmail());
            stmt.setString(4, u.getRol());
            stmt.setInt(5, u.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM usuarios WHERE id=?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==========================================
    // 2. MÉTODOS DE AUTENTICACIÓN Y OTP
    // ==========================================

    public Usuario validarLogin(String email, String password) {
        String sql = "SELECT * FROM usuarios WHERE email = ? AND password = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearUsuario(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Usuario obtenerPorEmail(String email) {
        String sql = "SELECT * FROM usuarios WHERE email = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearUsuario(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean guardarTokenOTP(int idUsuario, String otp) {
        String sql = "INSERT INTO otp_tokens (id_usuario, codigo, expira_en, usado) VALUES (?, ?, CURRENT_TIMESTAMP + INTERVAL '15 minutes', false)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, idUsuario);
            stmt.setString(2, otp);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean validarTokenOTP(int idUsuario, String otp) {
        String sqlSelect = "SELECT id FROM otp_tokens WHERE id_usuario = ? AND codigo = ? AND usado = false AND expira_en > CURRENT_TIMESTAMP ORDER BY id DESC LIMIT 1";
        String sqlUpdate = "UPDATE otp_tokens SET usado = true WHERE id = ?";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmtSelect = conn.prepareStatement(sqlSelect)) {
             
            stmtSelect.setInt(1, idUsuario);
            stmtSelect.setString(2, otp);
            ResultSet rs = stmtSelect.executeQuery();
            
            if (rs.next()) {
                int idToken = rs.getInt("id");
                try (PreparedStatement stmtUpdate = conn.prepareStatement(sqlUpdate)) {
                    stmtUpdate.setInt(1, idToken);
                    stmtUpdate.executeUpdate();
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizarPassword(int idUsuario, String newPassword) {
        String sql = "UPDATE usuarios SET password = ? WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setString(1, newPassword);
            stmt.setInt(2, idUsuario);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==========================================
    // 3. MÉTODOS DE RECURSOS HUMANOS (RRHH)
    // ==========================================

    public boolean actualizarPerfil(Usuario u) {
        String sql = "UPDATE usuarios SET " +
                     "full_name = ?, document_id = ?, email = ?, profile_picture = ?, " +
                     "fecha_nacimiento = ?, direccion = ?, telefono = ?, contacto_emergencia = ?, " +
                     "eps = ?, codigo_empleado = ?, cargo = ?, fecha_ingreso = ?, " +
                     "tipo_contrato = ?, salario_base = ?, horario = ?, departamento = ?, jefe_inmediato = ? " +
                     "WHERE id = ?";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, u.getFullName());
            stmt.setString(2, u.getDocumentId());
            stmt.setString(3, u.getEmail());
            stmt.setString(4, u.getProfilePicture());
            stmt.setDate(5, u.getFechaNacimiento());
            stmt.setString(6, u.getDireccion());
            stmt.setString(7, u.getTelefono());
            stmt.setString(8, u.getContactoEmergencia());
            stmt.setString(9, u.getEps());
            stmt.setString(10, u.getCodigoEmpleado());
            stmt.setString(11, u.getCargo());
            stmt.setDate(12, u.getFechaIngreso());
            stmt.setString(13, u.getTipoContrato());
            stmt.setDouble(14, u.getSalarioBase());
            stmt.setString(15, u.getHorario());
            stmt.setString(16, u.getDepartamento());
            stmt.setString(17, u.getJefeInmediato());
            stmt.setInt(18, u.getId());
            
            return stmt.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==========================================
    // 4. MAPEO CENTRALIZADO
    // ==========================================
    
    private Usuario mapearUsuario(ResultSet rs) throws Exception {
        Usuario u = new Usuario();
        
        // Datos de Sistema
        u.setId(rs.getInt("id"));
        u.setFullName(rs.getString("full_name"));
        u.setDocumentId(rs.getString("document_id"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRol(rs.getString("rol"));
        u.setProfilePicture(rs.getString("profile_picture"));
        
        // Datos Personales y Laborales (RRHH)
        u.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
        u.setDireccion(rs.getString("direccion"));
        u.setTelefono(rs.getString("telefono"));
        u.setContactoEmergencia(rs.getString("contacto_emergencia"));
        u.setEps(rs.getString("eps"));
        u.setCodigoEmpleado(rs.getString("codigo_empleado"));
        u.setCargo(rs.getString("cargo"));
        u.setFechaIngreso(rs.getDate("fecha_ingreso"));
        u.setTipoContrato(rs.getString("tipo_contrato"));
        u.setSalarioBase(rs.getDouble("salario_base"));
        u.setHorario(rs.getString("horario"));
        u.setDepartamento(rs.getString("departamento"));
        u.setJefeInmediato(rs.getString("jefe_inmediato"));
        
        return u;
    }
}