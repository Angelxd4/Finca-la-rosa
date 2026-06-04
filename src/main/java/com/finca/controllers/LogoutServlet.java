package com.finca.controllers;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtenemos la sesión actual (pasando 'false' para no crear una nueva si no existe)
        HttpSession session = request.getSession(false);
        
        // Si hay una sesión activa, la invalidamos (destruimos)
        if (session != null) {
            session.invalidate();
        }
        
        // Redirigimos al usuario de vuelta a la página de login
        response.sendRedirect("login");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // En caso de que se llame por POST, ejecutamos la misma lógica del GET
        doGet(request, response);
    }
}