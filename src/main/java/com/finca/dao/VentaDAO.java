package com.finca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.finca.models.Cliente;
import com.finca.models.Venta;
import com.finca.models.DetalleVenta;
import com.finca.utils.DbConnection;

public class VentaDAO {

    public List<Cliente> listarClientes() {
        List<Cliente> lista = new ArrayList<>();
        String sql = "SELECT * FROM clientes ORDER BY nombre_completo";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Cliente c = new Cliente();
                c.setIdCliente(rs.getInt("id_cliente"));
                c.setNombreCompleto(rs.getString("nombre_completo"));
                c.setDocumentoIdentidad(rs.getString("documento_identidad"));
                c.setTelefono(rs.getString("telefono"));
                c.setDireccion(rs.getString("direccion"));
                lista.add(c);
            }
        } catch (SQLException e) { 
            // Si la tabla no existe, no falla catastróficamente, retorna vacío
            System.out.println("No se pudo listar clientes (probablemente falta la tabla): " + e.getMessage()); 
        }
        return lista;
    }

    public List<Venta> listarVentasRecientes() {
        List<Venta> lista = new ArrayList<>();
        String sql = "SELECT * FROM ventas ORDER BY sale_date DESC LIMIT 50";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Venta v = new Venta();
                v.setIdVenta(rs.getInt("id_venta"));
                v.setNombreCliente(rs.getString("nombre_cliente"));
                v.setFechaVenta(rs.getTimestamp("sale_date"));
                v.setTotal(rs.getDouble("total_price"));
                v.setMetodoPago(rs.getString("tipo_venta")); // Mostrar Ganado o Lacteo
                v.setEstado("Completada");
                lista.add(v);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public boolean registrarVentaCompleta(Venta venta) {
        String sqlVenta = "INSERT INTO ventas (nombre_cliente, documento_cliente, cashier_id, tipo_venta, id_bovino, id_producto, cantidad, total_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        Connection con = null;
        try {
            con = DbConnection.getConnection();
            con.setAutoCommit(false); // Iniciar Transacción

            if (venta.getDetalles() != null) {
                try (PreparedStatement psVenta = con.prepareStatement(sqlVenta)) {
                    for (DetalleVenta det : venta.getDetalles()) {
                        String nombreC = (venta.getNombreCliente() == null || venta.getNombreCliente().isEmpty()) ? "Consumidor Final" : venta.getNombreCliente();
                        psVenta.setString(1, nombreC);
                        
                        // Extraer el documento del ID/String si se implementa, por ahora asumimos que no viene en el nombre
                        // Pero como necesitamos el documento, se lo pasaremos en el modelo Venta.
                        // Para simplificar, si no hay documento, es null.
                        psVenta.setNull(2, java.sql.Types.VARCHAR);
                        
                        psVenta.setInt(3, 1); // TODO: cashier_id desde sesión. Temporal: 1 (Usuario Administrador)
                        psVenta.setString(4, det.getTipoProducto());
                        
                        if ("Ganado".equals(det.getTipoProducto())) {
                            psVenta.setInt(5, det.getIdProducto());
                            psVenta.setNull(6, java.sql.Types.INTEGER);
                        } else {
                            psVenta.setNull(5, java.sql.Types.INTEGER);
                            psVenta.setInt(6, det.getIdProducto());
                        }
                        
                        psVenta.setDouble(7, det.getCantidad());
                        psVenta.setDouble(8, det.getSubtotal());
                        psVenta.addBatch();
                    }
                    psVenta.executeBatch();
                }
                
                // Actualizar Estado en DB Real (Descontar Inventario)
                for (DetalleVenta det : venta.getDetalles()) {
                    if ("Ganado".equals(det.getTipoProducto())) {
                        String sqlUpdateBovino = "UPDATE bovinos SET clasificacion = 'Vendido' WHERE id_bovino = ?";
                        try (PreparedStatement psUp = con.prepareStatement(sqlUpdateBovino)) {
                            psUp.setInt(1, det.getIdProducto());
                            psUp.executeUpdate();
                        }
                    } else if ("Lacteo".equals(det.getTipoProducto())) {
                        String sqlUpdateLacteo = "UPDATE productos_lacteos SET stock = stock - ? WHERE id_producto = ?";
                        try (PreparedStatement psUp = con.prepareStatement(sqlUpdateLacteo)) {
                            psUp.setDouble(1, det.getCantidad());
                            psUp.setInt(2, det.getIdProducto());
                            psUp.executeUpdate();
                        }
                    }
                }
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    public boolean registrarCliente(Cliente c) {
        String sql = "INSERT INTO clientes (nombre_completo, documento_identidad, telefono, correo, direccion) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getNombreCompleto());
            ps.setString(2, c.getDocumentoIdentidad());
            ps.setString(3, c.getTelefono());
            ps.setString(4, c.getCorreo());
            ps.setString(5, c.getDireccion());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
