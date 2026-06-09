package com.finca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.finca.models.ProductoLacteo;
import com.finca.utils.DbConnection;

public class ProductoLacteoDAO {

    public List<ProductoLacteo> obtenerTodos() {
        List<ProductoLacteo> lista = new ArrayList<>();
        String sql = "SELECT * FROM productos_lacteos ORDER BY id_producto DESC";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ProductoLacteo p = new ProductoLacteo();
                p.setIdProducto(rs.getInt("id_producto"));
                p.setCodigo(rs.getString("codigo"));
                p.setNombre(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setUnidadMedida(rs.getString("unidad_medida"));
                p.setStock(rs.getDouble("stock"));
                p.setPrecioUnitario(rs.getDouble("precio_unitario"));
                lista.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar lácteos: " + e.getMessage());
        }
        return lista;
    }

    public boolean registrar(ProductoLacteo p) {
        String sql = "INSERT INTO productos_lacteos (codigo, nombre, descripcion, unidad_medida, stock, precio_unitario) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, p.getCodigo());
            stmt.setString(2, p.getNombre());
            stmt.setString(3, p.getDescripcion());
            stmt.setString(4, p.getUnidadMedida());
            stmt.setDouble(5, p.getStock());
            stmt.setDouble(6, p.getPrecioUnitario());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar lácteo: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM productos_lacteos WHERE id_producto = ?";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar lácteo: " + e.getMessage());
            return false;
        }
    }
}