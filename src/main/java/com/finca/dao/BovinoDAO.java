package com.finca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.finca.models.Bovino;
import com.finca.models.HistorialClinico;
import com.finca.utils.DbConnection;

public class BovinoDAO {

    public List<Bovino> obtenerPorClasificacion(String clasificacion) {
        List<Bovino> lista = new ArrayList<>();
        String sql = "SELECT * FROM bovinos WHERE clasificacion = ? ORDER BY id_bovino DESC";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, clasificacion);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Bovino b = new Bovino();
                    b.setIdBovino(rs.getInt("id_bovino"));
                    b.setNumeroArete(rs.getString("numero_arete"));
                    b.setRaza(rs.getString("raza"));
                    b.setGenero(rs.getString("genero"));
                    b.setPesoKg(rs.getDouble("peso_kg"));
                    b.setProposito(rs.getString("proposito"));
                    b.setEstadoSalud(rs.getString("estado_salud"));
                    b.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    b.setPrecioEstimado(rs.getDouble("precio_estimado"));
                    b.setClasificacion(rs.getString("clasificacion"));
                    b.setNumeroPartos(rs.getInt("numero_partos"));
                    b.setLitrosDiariosPromedio(rs.getDouble("litros_diarios_promedio"));
                    b.setImageUrl(rs.getString("image_url")); // 📸 Carga la foto
                    lista.add(b);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    // Obtener 1 sola vaca completa (Para su Perfil)
    public Bovino obtenerPorId(int id) {
        Bovino b = null;
        String sql = "SELECT * FROM bovinos WHERE id_bovino = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    b = new Bovino();
                    b.setIdBovino(rs.getInt("id_bovino"));
                    b.setNumeroArete(rs.getString("numero_arete"));
                    b.setRaza(rs.getString("raza"));
                    b.setGenero(rs.getString("genero"));
                    b.setPesoKg(rs.getDouble("peso_kg"));
                    b.setProposito(rs.getString("proposito"));
                    b.setEstadoSalud(rs.getString("estado_salud"));
                    b.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    b.setPrecioEstimado(rs.getDouble("precio_estimado"));
                    b.setClasificacion(rs.getString("clasificacion"));
                    b.setNumeroPartos(rs.getInt("numero_partos"));
                    b.setLitrosDiariosPromedio(rs.getDouble("litros_diarios_promedio"));
                    b.setImageUrl(rs.getString("image_url"));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return b;
    }

    // Obtener el Historial de la Vaca
    public List<HistorialClinico> obtenerHistorial(int idBovino) {
        List<HistorialClinico> lista = new ArrayList<>();
        String sql = "SELECT h.*, u.full_name as veterinario FROM historial_clinico h " +
                     "LEFT JOIN usuarios u ON h.veterinario_id = u.id " +
                     "WHERE h.id_bovino = ? ORDER BY h.fecha_evento DESC";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idBovino);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    HistorialClinico h = new HistorialClinico();
                    h.setIdRegistro(rs.getInt("id_registro"));
                    h.setIdBovino(rs.getInt("id_bovino"));
                    h.setFechaEvento(rs.getDate("fecha_evento"));
                    h.setTipoEvento(rs.getString("tipo_evento"));
                    h.setDescripcion(rs.getString("descripcion"));
                    h.setNombreVeterinario(rs.getString("veterinario"));
                    lista.add(h);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public boolean registrar(Bovino b) {
        String sql = "INSERT INTO bovinos (numero_arete, raza, genero, peso_kg, proposito, estado_salud, fecha_nacimiento, precio_estimado, clasificacion, numero_partos, litros_diarios_promedio, image_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, b.getNumeroArete());
            stmt.setString(2, b.getRaza());
            stmt.setString(3, b.getGenero());
            stmt.setDouble(4, b.getPesoKg());
            stmt.setString(5, b.getProposito());
            stmt.setString(6, b.getEstadoSalud());
            stmt.setDate(7, b.getFechaNacimiento());
            stmt.setDouble(8, b.getPrecioEstimado());
            stmt.setString(9, b.getClasificacion());
            stmt.setInt(10, b.getNumeroPartos());
            stmt.setDouble(11, b.getLitrosDiariosPromedio());
            stmt.setString(12, b.getImageUrl()); // 📸 Guarda el link de la foto
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean cambiarClasificacion(int idBovino, String nuevaClasificacion) {
        String sql = "UPDATE bovinos SET clasificacion = ? WHERE id_bovino = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nuevaClasificacion);
            stmt.setInt(2, idBovino);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ¡NUEVO MÉTODO 100% COMPLETO! Guarda un nuevo evento médico en la base de datos
    public boolean registrarHistorial(HistorialClinico h) {
        String sql = "INSERT INTO historial_clinico (id_bovino, fecha_evento, tipo_evento, descripcion, veterinario_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, h.getIdBovino());
            stmt.setDate(2, h.getFechaEvento());
            stmt.setString(3, h.getTipoEvento());
            stmt.setString(4, h.getDescripcion());
            stmt.setInt(5, h.getVeterinarioId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}