package com.finca.controllers;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import com.finca.dao.UsuarioDAO;
import com.finca.models.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/perfil")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
public class PerfilServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario sessionUser = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (sessionUser == null) {
            response.sendRedirect("login");
            return;
        }

        // Consultamos la base de datos para traer los datos más frescos del usuario
        Usuario usuario = usuarioDAO.obtenerPorEmail(sessionUser.getEmail());
        if (usuario == null) {
            response.sendRedirect("login");
            return;
        }
        
        request.setAttribute("usuario", usuario);
        
        String msg = request.getParameter("msg");
        if ("actualizado".equals(msg)) request.setAttribute("successMessage", "¡Tu perfil se ha actualizado correctamente!");
        if ("error".equals(request.getParameter("error"))) request.setAttribute("errorMessage", "Hubo un error al actualizar los datos.");

        request.getRequestDispatcher("perfil.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario sessionUser = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (sessionUser == null) {
            response.sendRedirect("login");
            return;
        }

        Usuario u = usuarioDAO.obtenerPorEmail(sessionUser.getEmail());
        if (u == null) {
            response.sendRedirect("login");
            return;
        }

        // El usuario solo tiene permiso de actualizar campos básicos de contacto
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        String contactoEmergencia = request.getParameter("contactoEmergencia");
        
        if(telefono != null) u.setTelefono(telefono);
        if(direccion != null) u.setDireccion(direccion);
        if(contactoEmergencia != null) u.setContactoEmergencia(contactoEmergencia);

        // Lógica para actualizar la Foto de Perfil
        Part filePart = request.getPart("profilePicture");
        if (filePart != null && filePart.getSize() > 0) {
            String extension = filePart.getSubmittedFileName().substring(filePart.getSubmittedFileName().lastIndexOf("."));
            String fileName = "avatar_" + UUID.randomUUID().toString() + extension;
            
            String targetPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
            File targetDir = new File(targetPath);
            if (!targetDir.exists()) targetDir.mkdir();
            filePart.write(targetPath + File.separator + fileName);
            
            String srcPath = "C:\\Users\\angel\\OneDrive\\Desktop\\Ejercicios Java\\Finca la rosa\\gestion-ganadera\\src\\main\\webapp\\uploads";
            File srcDir = new File(srcPath);
            if (!srcDir.exists()) srcDir.mkdir();
            
            Files.copy(
                new File(targetPath + File.separator + fileName).toPath(), 
                new File(srcPath + File.separator + fileName).toPath(),
                StandardCopyOption.REPLACE_EXISTING
            );
            u.setProfilePicture(fileName);
        }

        // Guardamos y actualizamos la sesión
        if (usuarioDAO.actualizarPerfil(u)) {
            session.setAttribute("usuarioLogueado", u); // Refrescar foto en el menú
            response.sendRedirect("perfil?msg=actualizado");
        } else {
            response.sendRedirect("perfil?error=error");
        }
    }
}