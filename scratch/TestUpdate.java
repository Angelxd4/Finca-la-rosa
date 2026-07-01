import com.finca.dao.UsuarioDAO;
import com.finca.models.Usuario;

public class TestUpdate {
    public static void main(String[] args) {
        UsuarioDAO dao = new UsuarioDAO();
        try {
            Usuario u = dao.obtenerTodos().get(0); // get first user
            System.out.println("User: " + u.getFullName());
            u.setTelefono("999999");
            boolean res = dao.actualizarPerfil(u);
            System.out.println("Update result: " + res);
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}
