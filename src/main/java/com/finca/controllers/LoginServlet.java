package com.finca.controllers;

import java.io.IOException;

import com.finca.dao.UsuarioDAO;
import com.finca.models.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Si el usuario ya inició sesión, lo mandamos al inventario
        HttpSession session = request.getSession();
        if (session.getAttribute("usuarioLogueado") != null) {
            response.sendRedirect("inventario-ganado");
            return;
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Usuario usuario = usuarioDAO.validarLogin(email, password);

        if (usuario != null) {
            // Login exitoso: Guardamos el usuario en la sesión
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", usuario);
            
            // Lo redirigimos al inventario
            response.sendRedirect("inventario-ganado");
        } else {
            // Login fallido: Volvemos al login con mensaje de error
            request.setAttribute("error", "Correo o contraseña incorrectos.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}