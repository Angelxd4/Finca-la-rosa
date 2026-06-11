package com.finca.utils;

import java.sql.Connection;
import java.sql.SQLException;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

@SuppressWarnings("CallToPrintStackTrace")
public class DbConnection {
    
    // CAMBIO CRÍTICO: Puerto 6543 (Transaction Pooler) y prepareThreshold=0 (Requerido por Supabase PgBouncer)
    private static final String URL = "jdbc:postgresql://aws-1-us-west-2.pooler.supabase.com:6543/postgres?prepareThreshold=0&tcpKeepAlive=true&reWriteBatchedInserts=true";
    
    private static final String USER = "postgres.jdzfbdkyskslgjmknoqz";
    private static final String PASSWORD = "holacomo3stas"; 

    private static HikariDataSource dataSource;

    static {
        try {
            Class.forName("org.postgresql.Driver");
            
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(URL);
            config.setUsername(USER);
            config.setPassword(PASSWORD);
            
            // Límite conservador seguro para el entorno gratuito
            config.setMaximumPoolSize(5); 
            config.setMinimumIdle(1); 
            config.setConnectionTimeout(15000); 
            config.setIdleTimeout(300000); 
            config.setMaxLifetime(1800000); 
            
            // Para el puerto 6543 de Supabase, las consultas preparadas del servidor deben apagarse
            config.addDataSourceProperty("useServerPrepStmts", "false");

            dataSource = new HikariDataSource(config);

        } catch (Exception e) {
            System.err.println("Error crítico: Fallo al inicializar HikariCP.");
            e.printStackTrace();
            throw new RuntimeException("Fallo al cargar el pool JDBC", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}