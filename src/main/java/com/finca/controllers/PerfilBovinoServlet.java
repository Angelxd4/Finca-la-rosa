package com.finca.controllers;

import java.io.IOException;

import com.finca.dao.BovinoDAO;
import com.finca.models.Bovino;
import com.finca.models.HistorialClinico;
import com.finca.models.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/perfil-bovino")
public class PerfilBovinoServlet extends HttpServlet {
    private BovinoDAO bovinoDAO = new BovinoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("usuarioLogueado") == null) { response.sendRedirect("login"); return; }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("inventario-ganado"); 
            return;
        }

        int idBovino = Integer.parseInt(idStr);
        Bovino vaca = bovinoDAO.obtenerPorId(idBovino);
        
        if (vaca == null) {
            response.sendRedirect("inventario-ganado");
            return;
        }

        // Si viene un mensaje de éxito, lo mandamos a la vista
        if ("ok".equals(request.getParameter("msg"))) {
            request.setAttribute("successMessage", "Evento médico registrado correctamente.");
        }

        request.setAttribute("bovino", vaca);
        request.setAttribute("historial", bovinoDAO.obtenerHistorial(idBovino));
        
        request.getRequestDispatcher("perfil-bovino.jsp").forward(request, response);
    }

    // ¡NUEVO! Este método recibe el formulario cuando el Veterinario añade una vacuna o enfermedad
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (usuarioLogueado == null) { response.sendRedirect("login"); return; }

        try {
            HistorialClinico h = new HistorialClinico();
            int idBovino = Integer.parseInt(request.getParameter("idBovino"));
            h.setIdBovino(idBovino);
            h.setFechaEvento(java.sql.Date.valueOf(request.getParameter("fechaEvento")));
            h.setTipoEvento(request.getParameter("tipoEvento"));
            h.setDescripcion(request.getParameter("descripcion"));
            
            // Registramos automáticamente al usuario que está usando el sistema como el veterinario
            h.setVeterinarioId(usuarioLogueado.getId()); 

            if (bovinoDAO.registrarHistorial(h)) {
                
                // ==============================================================================
                // LÓGICA AUTOMÁTICA: CAMBIO DE ESTADO DE SALUD
                // ==============================================================================
                String nuevoEstado = request.getParameter("nuevoEstadoSalud");
                
                // Si el JSP envió un nuevo estado (ej. "En Tratamiento"), actualizamos la vaca
                if (nuevoEstado != null && !nuevoEstado.isEmpty()) {
                    Bovino vacaUpdate = bovinoDAO.obtenerPorId(idBovino);
                    if (vacaUpdate != null) {
                        vacaUpdate.setEstadoSalud(nuevoEstado);
                        bovinoDAO.actualizar(vacaUpdate); // Actualiza la vaca en la base de datos
                    }
                }
                // ==============================================================================

                // Recargamos el perfil de esa misma vaca con mensaje de éxito
                response.sendRedirect("perfil-bovino?id=" + idBovino + "&msg=ok");
            } else {
                response.sendRedirect("perfil-bovino?id=" + idBovino + "&error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("inventario-ganado");
        }
    }
}