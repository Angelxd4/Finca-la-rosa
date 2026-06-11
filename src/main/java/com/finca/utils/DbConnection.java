package com.finca.utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

@SuppressWarnings("CallToPrintStackTrace")
public class DbConnection {
    
    // URL usando el Session-mode pooler para asegurar compatibilidad IPv4
    private static final String URL = "jdbc:postgresql://aws-1-us-west-2.pooler.supabase.com:5432/postgres";
    
    // Tu usuario único del pooler
    private static final String USER = "postgres.jdzfbdkyskslgjmknoqz";
    
    // ATENCIÓN: Reemplaza esto por tu contraseña real
    private static final String PASSWORD = "holacomo3stas"; 

    // El Pool de conexiones (HikariCP)
    private static final HikariDataSource dataSource;

    static {
        try {
            // Cargar el driver de PostgreSQL
            Class.forName("org.postgresql.Driver");
            
            // Configurar el Pool de Conexiones HikariCP
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(URL);
            config.setUsername(USER);
            config.setPassword(PASSWORD);
            
            // ==========================================
            // OPTIMIZACIONES DE RENDIMIENTO (LA MAGIA)
            // ==========================================
            
            // Número máximo de conexiones simultáneas a la base de datos
            config.setMaximumPoolSize(12); 
            
            // Mantiene al menos 2 conexiones vivas siempre para responder instantáneamente
            config.setMinimumIdle(2); 
            
            // Si la base de datos demora más de 20 segundos en responder, cancela para no congelar el sistema
            config.setConnectionTimeout(20000); 
            
            // Cierra conexiones inactivas después de 5 minutos para ahorrar memoria
            config.setIdleTimeout(300000); 
            
            // Configuraciones recomendadas para hacer que PostgreSQL vuele (Caché de consultas)
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
            config.addDataSourceProperty("useServerPrepStmts", "true");

            // Inicializamos el Pool
            dataSource = new HikariDataSource(config);

        } catch (ClassNotFoundException e) {
            System.err.println("Error crítico: Driver de PostgreSQL no encontrado.");
            e.printStackTrace();
            throw new RuntimeException("Fallo al cargar el driver JDBC", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        // En lugar de viajar a Supabase y conectarse desde cero, 
        // simplemente pide una conexión ya abierta y lista al Pool.
        return dataSource.getConnection();
    }
}