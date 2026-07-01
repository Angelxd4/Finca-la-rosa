import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import com.finca.utils.DbConnection;
import com.finca.dao.TareaDAO;

public class CheckDb {
    public static void main(String[] args) {
        try {
            // Inicializar DAO que crea la tabla
            new TareaDAO();
            
            try (Connection conn = DbConnection.getConnection();
                 Statement stmt = conn.createStatement()) {
                
                ResultSet rs = stmt.executeQuery("SELECT count(*) FROM tareas");
                if(rs.next()) {
                    System.out.println("Tareas table has " + rs.getInt(1) + " rows.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
