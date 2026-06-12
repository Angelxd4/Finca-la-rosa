package com.finca.controllers;

import java.io.IOException;
import java.sql.Date;

import com.finca.dao.TareaDAO;
import com.finca.dao.UsuarioDAO;
import com.finca.models.Tarea;
import com.finca.models.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/kanban")
public class KanbanServlet extends HttpServlet {

    private final TareaDAO tareaDAO = new TareaDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        if (usuario == null) {
            response.sendRedirect("login");
            return;
        }

        // =========================================================
        // LÓGICA DE ROLES Y PERMISOS DE VISTA
        // =========================================================
        String r = usuario.getRol() != null ? usuario.getRol() : "3";
        boolean esAdmin = r.equals("1") || r.equalsIgnoreCase("Administrador") || r.equals("2") || r.equalsIgnoreCase("Veterinario");

        if (esAdmin) {
            // El Admin ve todo el tablero y todos los empleados para poder asignar
            request.setAttribute("tareas", tareaDAO.obtenerTodas());
            request.setAttribute("empleados", usuarioDAO.obtenerTodos()); 
            request.setAttribute("tituloTablero", "Tablero General");
            request.setAttribute("subTitulo", "Supervisa y delega tareas a los operarios.");
        } else {
            // El Operario SOLO ve sus tareas asignadas
            request.setAttribute("tareas", tareaDAO.obtenerPorAsignado(usuario.getId()));
            request.setAttribute("tituloTablero", "Mis Tareas Asignadas");
            request.setAttribute("subTitulo", "Arrastra tus tareas a 'En Progreso' o 'Completada'.");
        }
        
        request.setAttribute("esAdmin", esAdmin); // Enviamos el permiso a la vista HTML

        String msg = request.getParameter("msg");
        String error = request.getParameter("error");
        if ("creada".equals(msg)) request.setAttribute("successMessage", "Tarea asignada exitosamente.");
        if ("eliminada".equals(msg)) request.setAttribute("successMessage", "Tarea eliminada.");
        if ("nopermiso".equals(error)) request.setAttribute("errorMessage", "No tienes permisos de Administrador para hacer eso.");

        request.getRequestDispatcher("kanban.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario usuarioLogueado = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        String action = request.getParameter("action");
        
        String r = usuarioLogueado.getRol() != null ? usuarioLogueado.getRol() : "3";
        boolean esAdmin = r.equals("1") || r.equalsIgnoreCase("Administrador") || r.equals("2") || r.equalsIgnoreCase("Veterinario");

        // ACCIÓN 1: Mover Tarjeta (AJAX). ¡Todos pueden mover sus tarjetas!
        if ("mover".equals(action)) {
            int idTarea = Integer.parseInt(request.getParameter("idTarea"));
            String nuevoEstado = request.getParameter("estado");
            boolean exito = tareaDAO.actualizarEstado(idTarea, nuevoEstado);
            response.setContentType("text/plain");
            response.getWriter().write(exito ? "OK" : "ERROR");
            return;
        }

        // ACCIÓN 2: Crear Tarea (¡SOLO ADMINS!)
        if ("crear".equals(action)) {
            if (!esAdmin) { response.sendRedirect("kanban?error=nopermiso"); return; }
            
            Tarea t = new Tarea();
            t.setTitulo(request.getParameter("titulo"));
            t.setDescripcion(request.getParameter("descripcion"));
            
            String fechaStr = request.getParameter("fechaLimite");
            if(fechaStr != null && !fechaStr.isEmpty()) t.setFechaLimite(Date.valueOf(fechaStr));
            
            t.setAsignadoA(Integer.parseInt(request.getParameter("asignadoA")));
            t.setCreadoPor(usuarioLogueado.getId());

            tareaDAO.crear(t);
            response.sendRedirect("kanban?msg=creada");
            return;
        } 
        
        // ACCIÓN 3: Eliminar Tarea (¡SOLO ADMINS!)
        if ("eliminar".equals(action)) {
            if (!esAdmin) { response.sendRedirect("kanban?error=nopermiso"); return; }

            int idTarea = Integer.parseInt(request.getParameter("idTarea"));
            tareaDAO.eliminar(idTarea);
            response.sendRedirect("kanban?msg=eliminada");
            return;
        }
    }
}