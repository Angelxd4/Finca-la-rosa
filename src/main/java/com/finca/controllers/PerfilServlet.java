package com.finca.controllers;

import java.io.IOException;

import com.finca.services.AuthService;
import com.finca.services.EmpleadoService;
import com.finca.services.FileService;
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

    private final AuthService authService = new AuthService();
    private final EmpleadoService empleadoService = new EmpleadoService();
    private final FileService fileService = new FileService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }

        HttpSession session = request.getSession();
        Usuario sessionUser = (Usuario) session.getAttribute("usuarioLogueado");
        
        // Consultamos la base de datos para traer los datos más frescos del usuario
        Usuario usuario = authService.obtenerPorEmail(sessionUser.getEmail());
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
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }

        HttpSession session = request.getSession();
        Usuario sessionUser = (Usuario) session.getAttribute("usuarioLogueado");

        Usuario u = authService.obtenerPorEmail(sessionUser.getEmail());
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
        try {
            Part filePart = request.getPart("profilePicture");
            String fileName = fileService.guardarImagenEmpleado(request, filePart, u.getProfilePicture());
            u.setProfilePicture(fileName);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Guardamos y actualizamos la sesión
        if (empleadoService.actualizarPerfil(u)) {
            session.setAttribute("usuarioLogueado", u); // Refrescar foto en el menú
            response.sendRedirect("perfil?msg=actualizado");
        } else {
            response.sendRedirect("perfil?error=error");
        }
    }
}