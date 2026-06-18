package com.finca.controllers;

import java.io.IOException;

import com.finca.services.AuthService;
import com.finca.services.BovinoService;
import com.finca.services.EmpleadoService;
import com.finca.models.Bovino;
import com.finca.models.HistorialClinico;
import com.finca.models.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/perfil-bovino")
public class PerfilBovinoServlet extends HttpServlet {
    
    private final BovinoService bovinoService = new BovinoService();
    private final EmpleadoService empleadoService = new EmpleadoService();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("inventario-ganado"); 
            return;
        }

        int idBovino = Integer.parseInt(idStr);
        Bovino vaca = bovinoService.obtenerPorId(idBovino);
        
        if (vaca == null) {
            response.sendRedirect("inventario-ganado");
            return;
        }

        // Si viene un mensaje de éxito, lo mandamos a la vista
        if ("ok".equals(request.getParameter("msg"))) {
            request.setAttribute("successMessage", "Evento médico registrado correctamente.");
        }

        request.setAttribute("bovino", vaca);
        request.setAttribute("historial", bovinoService.obtenerHistorial(idBovino));
        
        try {
            request.setAttribute("listaEmpleados", empleadoService.obtenerTodos());
        } catch (Exception e) {
            System.out.println("Error al cargar la lista de empleados: " + e.getMessage());
        }
        
        request.getRequestDispatcher("perfil-bovino.jsp").forward(request, response);
    }

    // Este método recibe el formulario cuando el Administrador añade un evento
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }

        try {
            HistorialClinico h = new HistorialClinico();
            int idBovino = Integer.parseInt(request.getParameter("idBovino"));
            h.setIdBovino(idBovino);
            h.setFechaEvento(java.sql.Date.valueOf(request.getParameter("fechaEvento")));
            h.setTipoEvento(request.getParameter("tipoEvento"));
            h.setDescripcion(request.getParameter("descripcion"));
            
            int idVeterinarioSeleccionado = Integer.parseInt(request.getParameter("veterinarioId"));
            h.setVeterinarioId(idVeterinarioSeleccionado); 

            if (bovinoService.registrarHistorial(h)) {
                
                String nuevoEstado = request.getParameter("nuevoEstadoSalud");
                
                // Si el JSP envió un nuevo estado (ej. "En Tratamiento"), actualizamos la vaca
                if (nuevoEstado != null && !nuevoEstado.isEmpty()) {
                    Bovino vacaUpdate = bovinoService.obtenerPorId(idBovino);
                    if (vacaUpdate != null) {
                        vacaUpdate.setEstadoSalud(nuevoEstado);
                        bovinoService.actualizarBovino(vacaUpdate); 
                    }
                }

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