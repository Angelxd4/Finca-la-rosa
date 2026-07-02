package com.finca.controllers;

import java.io.IOException;
import java.sql.Date;

import com.finca.models.Tarea;
import com.finca.models.Usuario;
import com.finca.services.AuthService;
import com.finca.services.TareaService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/kanban")
public class KanbanServlet extends HttpServlet {

    private final TareaService tareaService = new TareaService();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }
        if (authService.esCliente(request)) {
            response.sendRedirect("catalogo");
            return;
        }

        Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        
        boolean esAdmin = authService.esAdministrador(request) || authService.esVeterinario(request);

        if (esAdmin) {
            request.setAttribute("tareas", tareaService.obtenerTodas());
            try {
                java.util.List<Usuario> todos = authService.obtenerTodosEmpleados();
                java.util.List<Usuario> disponibles = new java.util.ArrayList<>();
                for(Usuario u : todos) {
                    boolean esInactivo = "Inactivo".equalsIgnoreCase(u.getEstado());
                    if (!esInactivo && u.getId() != usuario.getId()) {
                        disponibles.add(u);
                    }
                }
                request.setAttribute("empleados", disponibles);
            } catch (Exception e) {
                e.printStackTrace();
            }
            request.setAttribute("tituloTablero", "Tablero General");
            request.setAttribute("subTitulo", "Supervisa y delega tareas a los operarios.");
        } else {
            request.setAttribute("tareas", tareaService.obtenerPorAsignado(usuario.getId()));
            request.setAttribute("tituloTablero", "Mis Tareas Asignadas");
            request.setAttribute("subTitulo", "Arrastra tus tareas a 'En Progreso' o 'Completada'.");
        }
        
        request.setAttribute("esAdmin", esAdmin); 

        String msg = request.getParameter("msg");
        String error = request.getParameter("error");

        if ("creada".equals(msg)) request.setAttribute("successMessage", "Tarea asignada. Se notificó al empleado por WhatsApp.");
        if ("eliminada".equals(msg)) request.setAttribute("successMessage", "Tarea eliminada del tablero.");
        if ("nopermiso".equals(error)) request.setAttribute("errorMessage", "No tienes permisos para hacer eso.");

        request.getRequestDispatcher("kanban.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }
        if (authService.esCliente(request)) {
            response.sendRedirect("catalogo");
            return;
        }

        Usuario usuarioLogueado = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        String action = request.getParameter("action");
        
        boolean esAdmin = authService.esAdministrador(request) || authService.esVeterinario(request);

        // ACCIÓN 1: MOVER TAREA (AJAX)
        if ("mover".equals(action)) {
            int idTarea = Integer.parseInt(request.getParameter("idTarea"));
            String nuevoEstado = request.getParameter("estado");
            boolean exito = tareaService.actualizarEstado(idTarea, nuevoEstado);
            response.setContentType("text/plain");
            response.getWriter().write(exito ? "OK" : "ERROR");
            return;
        }

        // ACCIÓN 2: CREAR TAREA Y ENVIAR WHATSAPP AUTOMÁTICO
        if ("crear".equals(action)) {
            if (!esAdmin) { response.sendRedirect("kanban?error=nopermiso"); return; }
            
            Tarea t = new Tarea();
            t.setTitulo(request.getParameter("titulo"));
            t.setDescripcion(request.getParameter("descripcion"));
            
            String fechaStr = request.getParameter("fechaLimite");
            if(fechaStr != null && !fechaStr.isEmpty()) t.setFechaLimite(Date.valueOf(fechaStr));
            
            int idAsignado = Integer.parseInt(request.getParameter("asignadoA"));
            t.setAsignadoA(idAsignado);
            t.setCreadoPor(usuarioLogueado.getId());

            tareaService.crearTareaYNotificar(t, usuarioLogueado.getFullName()); // O usar el nombre real, aquí pasaremos el nombre si fuera necesario
            
            response.sendRedirect("kanban?msg=creada");
            return;
        } 
        
        // ACCIÓN 3: ELIMINAR TAREA
        if ("eliminar".equals(action)) {
            if (!esAdmin) { response.sendRedirect("kanban?error=nopermiso"); return; }
            int idTarea = Integer.parseInt(request.getParameter("idTarea"));
            tareaService.eliminarTarea(idTarea);
            response.sendRedirect("kanban?msg=eliminada");
            return;
        }
    }
}