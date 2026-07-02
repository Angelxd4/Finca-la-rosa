package com.finca.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;

public class AlterDb {
    public static void main(String[] args) {
        try (Connection con = DbConnection.getConnection();
             Statement st = con.createStatement()) {
            
            String insertUser = "INSERT INTO usuarios (full_name, document_id, email, password, rol, qr_codigo) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(insertUser)) {
                ps.setString(1, "Cliente de Prueba");
                ps.setString(2, "123456789");
                ps.setString(3, "cliente@prueba.com");
                ps.setString(4, "123456");
                ps.setString(5, "5"); // Rol 5 = Cliente
                ps.setString(6, "FINCA-LAROSA-DOC-123456789");
                ps.executeUpdate();
                System.out.println("Usuario de prueba creado exitosamente: cliente@prueba.com / 123456");
            } catch (Exception e) {
                System.out.println("Error insertando usuario: " + e.getMessage());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
