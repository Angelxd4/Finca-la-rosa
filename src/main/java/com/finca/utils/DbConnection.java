package com.finca.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

@SuppressWarnings("CallToPrintStackTrace")
public class DbConnection {
    // URL usando el Session-mode pooler para asegurar compatibilidad IPv4
    private static final String URL = "jdbc:postgresql://aws-1-us-west-2.pooler.supabase.com:5432/postgres";
    
    // Tu usuario único del pooler
    private static final String USER = "postgres.jdzfbdkyskslgjmknoqz";
    
    // ATENCIÓN: Reemplaza esto por tu contraseña real
    private static final String PASSWORD = "holacomo3stas"; 

    static {
        try {
            // Cargar el driver de PostgreSQL
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Error crítico: Driver de PostgreSQL no encontrado.");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}