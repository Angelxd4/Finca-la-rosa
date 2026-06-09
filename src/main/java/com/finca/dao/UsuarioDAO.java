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

    // Método que ya teníamos para el Login
    public Usuario validarLogin(String email, String password) {
        Usuario usuario = null;
        String sql = "SELECT * FROM usuarios WHERE email = ? AND password = ?";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setFullName(rs.getString("full_name"));
                    usuario.setDocumentId(rs.getString("document_id"));
                    usuario.setEmail(rs.getString("email"));
                    // CORRECCIÓN: Leemos "rol" como texto
                    usuario.setRol(rs.getString("rol")); 
                    usuario.setProfilePicture(rs.getString("profile_picture"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en login: " + e.getMessage());
        }
        return usuario;
    }

    // NUEVO: Listar todos los empleados/usuarios
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
                // CORRECCIÓN: Leemos "rol" como texto
                u.setRol(rs.getString("rol"));
                lista.add(u);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener usuarios: " + e.getMessage());
        }
        return lista;
    }

    // NUEVO: Registrar un empleado
    public boolean registrar(Usuario u) {
        // CORRECCIÓN: Quitamos barcode y cambiamos role_id por rol
        String sql = "INSERT INTO usuarios (full_name, document_id, email, password, rol) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, u.getFullName());
            stmt.setString(2, u.getDocumentId());
            stmt.setString(3, u.getEmail());
            stmt.setString(4, u.getPassword()); // En un proyecto real esto se encriptaría
            stmt.setString(5, u.getRol()); // Insertamos el rol como texto

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar usuario: " + e.getMessage());
            return false;
        }
    }

    // NUEVO: Eliminar un empleado
    public boolean eliminar(int id) {
        String sql = "DELETE FROM usuarios WHERE id = ?";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            // Nota de error: Si intentas borrar un empleado que ya registró un ordeño, 
            // la base de datos lanzará un error de "Violación de llave foránea".
            System.err.println("Error al eliminar usuario (Probablemente tiene registros asociados): " + e.getMessage());
            return false;
        }
    }
}