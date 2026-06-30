package com.finca.services;

import com.finca.dao.UsuarioDAO;
import com.finca.models.Usuario;
import com.finca.utils.EmailService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Random;

public class AuthService {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    public List<Usuario> obtenerTodosEmpleados() throws Exception {
        return usuarioDAO.obtenerTodos();
    }

    public Usuario obtenerPorEmail(String email) {
        return usuarioDAO.obtenerPorEmail(email);
    }

    /**
     * Valida las credenciales del usuario, y si son correctas, genera y envía un OTP.
     * @return El usuario si es válido, o null si no.
     */
    public Usuario verificarCredencialesYEnviarOTP(String email, String password) throws Exception {
        Usuario u = usuarioDAO.validarLogin(email, password);
        if (u != null) {
            enviarYGuardarOTP(u, email, "INICIO DE SESIÓN");
            return u;
        }
        return null;
    }

    public Usuario solicitarOTPRecuperacion(String email) throws Exception {
        Usuario u = usuarioDAO.obtenerPorEmail(email);
        if (u != null) {
            enviarYGuardarOTP(u, email, "RECUPERAR CONTRASEÑA");
            return u;
        }
        return null;
    }

    private void enviarYGuardarOTP(Usuario u, String email, String tipo) throws Exception {
        String otp = String.format("%06d", new Random().nextInt(999999));
        
        System.out.println("\n=========================================");
        System.out.println("🔑 CÓDIGO OTP PARA " + tipo);
        System.out.println("👤 Usuario ID: " + u.getId() + " (" + email + ")");
        System.out.println("🔢 CÓDIGO OTP: " + otp);
        System.out.println("=========================================\n");

        usuarioDAO.guardarTokenOTP(u.getId(), otp);
        try {
            EmailService.enviarCodigoOTP(email, otp);
        } catch (Exception e) {
            System.err.println("⚠️ No se pudo enviar el correo (posible bloqueo SMTP de Render). Usa el código OTP de arriba para ingresar.");
        }
    }

    public boolean validarOTP(int idUsuario, String otp) {
        return usuarioDAO.validarTokenOTP(idUsuario, otp);
    }
    
    public boolean actualizarContrasena(int idUsuario, String newPassword) {
        return usuarioDAO.actualizarPassword(idUsuario, newPassword);
    }

    public String obtenerNombreCorto(Usuario u) {
        if (u != null && u.getFullName() != null && !u.getFullName().isEmpty()) {
            return u.getFullName().split(" ")[0];
        }
        return "Usuario";
    }

    public String obtenerRolTexto(Usuario u) {
        String r = u != null && u.getRol() != null ? u.getRol() : "";
        if(r.equals("1") || r.equalsIgnoreCase("Administrador")) return "Administrador";
        else if(r.equals("2") || r.equalsIgnoreCase("Veterinario")) return "Veterinario";
        else if(r.equals("3") || r.equalsIgnoreCase("Operario")) return "Operario (Vaquero)";
        else if(r.equals("4") || r.equalsIgnoreCase("Vendedor")) return "Vendedor";
        else if(r.equals("5") || r.equalsIgnoreCase("Cliente")) return "Cliente";
        return r.isEmpty() ? "Desconocido" : r;
    }
    
    /**
     * Verifica si hay una sesión activa. Redirige si la redirección no es null y no hay sesión.

     */
    public boolean estaAutenticado(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("usuarioLogueado") != null;
    }

    /**
     * Obtiene el rol del usuario logueado en la sesión.
     */
    public String getRolUsuarioLogueado(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
            if (u != null && u.getRol() != null) {
                return u.getRol();
            }
        }
        return "";
    }

    public boolean esVeterinario(HttpServletRequest request) {
        String rol = getRolUsuarioLogueado(request);
        return rol.equals("2") || rol.equalsIgnoreCase("Veterinario");
    }

    public boolean esAdministrador(HttpServletRequest request) {
        String rol = getRolUsuarioLogueado(request);
        return rol.equals("1") || rol.equalsIgnoreCase("Administrador");
    }

    public boolean esOperario(HttpServletRequest request) {
        String rol = getRolUsuarioLogueado(request);
        return rol.equals("3") || rol.equalsIgnoreCase("Operario");
    }

    /**
     * Verifica si el usuario actual es Admin u Operario (acceso a Producción).
     */
    public boolean tienePermisoProduccion(HttpServletRequest request) {
        return esAdministrador(request) || esOperario(request);
    }
}
