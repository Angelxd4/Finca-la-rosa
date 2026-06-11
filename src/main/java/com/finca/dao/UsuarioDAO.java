package com.finca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.finca.models.Usuario;
import com.finca.utils.DbConnection;

public class UsuarioDAO {

    public Usuario validarLogin(String email, String password) {
        String sql = "SELECT * FROM usuarios WHERE email = ? AND password = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setString(2, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setDocumentId(rs.getString("document_id"));
                    u.setEmail(rs.getString("email"));
                    u.setRol(rs.getString("rol"));
                    u.setProfilePicture(rs.getString("profile_picture"));
                    return u;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en login: " + e.getMessage());
        }
        return null;
    }

    public List<Usuario> obtenerTodos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios ORDER BY id DESC";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setFullName(rs.getString("full_name"));
                u.setDocumentId(rs.getString("document_id"));
                u.setEmail(rs.getString("email"));
                u.setRol(rs.getString("rol"));
                lista.add(u);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener usuarios: " + e.getMessage());
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
        } catch (SQLException e) {
            System.err.println("Error al registrar usuario: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(Usuario u) {
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
            System.err.println("Error al actualizar usuario: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM usuarios WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar usuario: " + e.getMessage());
            return false;
        }
    }

    // =========================================================================
    // MÉTODOS PARA RECUPERACIÓN DE CONTRASEÑA (OTP)
    // =========================================================================

    public Usuario obtenerPorEmail(String email) {
        String sql = "SELECT * FROM usuarios WHERE email = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setEmail(rs.getString("email"));
                    return u;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean guardarTokenOTP(int idUsuario, String codigoOTP) {
        String sql = "INSERT INTO otp_tokens (id_usuario, codigo, expira_en, usado) " +
                     "VALUES (?, ?, CURRENT_TIMESTAMP + INTERVAL '15 minutes', false)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            stmt.setString(2, codigoOTP);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al guardar el token OTP: " + e.getMessage());
            return false;
        }
    }

    public boolean validarTokenOTP(int idUsuario, String codigoOTP) {
        String sqlSelect = "SELECT id FROM otp_tokens " +
                           "WHERE id_usuario = ? AND codigo = ? AND usado = false AND expira_en > CURRENT_TIMESTAMP " +
                           "ORDER BY fecha_gen DESC LIMIT 1";
        String sqlUpdate = "UPDATE otp_tokens SET usado = true WHERE id = ?";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmtSelect = conn.prepareStatement(sqlSelect)) {
            stmtSelect.setInt(1, idUsuario);
            stmtSelect.setString(2, codigoOTP);
            
            try (ResultSet rs = stmtSelect.executeQuery()) {
                if (rs.next()) {
                    int idToken = rs.getInt("id");
                    try (PreparedStatement stmtUpdate = conn.prepareStatement(sqlUpdate)) {
                        stmtUpdate.setInt(1, idToken);
                        stmtUpdate.executeUpdate();
                    }
                    return true;
                }
            }
        } catch (SQLException e) { System.err.println("Error validando token: " + e.getMessage()); }
        return false;
    }

    public boolean actualizarPassword(int idUsuario, String nuevaClave) {
        String sql = "UPDATE usuarios SET password = ? WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nuevaClave);
            stmt.setInt(2, idUsuario);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}