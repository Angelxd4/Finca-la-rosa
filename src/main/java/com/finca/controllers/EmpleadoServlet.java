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

@WebServlet("/empleados")
public class EmpleadoServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect("login");
            return;
        }

        request.setAttribute("empleados", usuarioDAO.obtenerTodos());

        String msg = request.getParameter("msg");
        String error = request.getParameter("error");
        
        if ("registrado".equals(msg)) request.setAttribute("successMessage", "Empleado registrado exitosamente.");
        if ("actualizado".equals(msg)) request.setAttribute("successMessage", "Datos del empleado actualizados correctamente.");
        if ("eliminado".equals(msg)) request.setAttribute("successMessage", "Empleado retirado del sistema.");
        if ("errorEliminar".equals(error)) request.setAttribute("errorMessage", "No se puede eliminar. Verifique que no tenga registros en producción asociados.");
        if ("errorGuardar".equals(error)) request.setAttribute("errorMessage", "Error al guardar. Verifique que el correo o documento no estén duplicados.");

        request.getRequestDispatcher("empleados.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // ACCIÓN: ELIMINAR EMPLEADO
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (usuarioDAO.eliminar(id)) {
                response.sendRedirect("empleados?msg=eliminado");
            } else {
                response.sendRedirect("empleados?error=errorEliminar");
            }
            return;
        }

        // ACCIÓN: ACTUALIZAR (EDITAR) EMPLEADO
        if ("edit".equals(action)) {
            Usuario u = new Usuario();
            u.setId(Integer.parseInt(request.getParameter("id")));
            u.setFullName(request.getParameter("fullName"));
            u.setDocumentId(request.getParameter("documentId"));
            u.setEmail(request.getParameter("email"));
            u.setRol(request.getParameter("rol"));
            
            if (usuarioDAO.actualizar(u)) {
                response.sendRedirect("empleados?msg=actualizado");
            } else {
                response.sendRedirect("empleados?error=errorGuardar");
            }
            return;
        }

        // ACCIÓN: REGISTRAR NUEVO EMPLEADO (Por defecto)
        Usuario u = new Usuario();
        u.setFullName(request.getParameter("fullName"));
        u.setDocumentId(request.getParameter("documentId"));
        u.setEmail(request.getParameter("email"));
        u.setPassword(request.getParameter("password"));
        u.setRol(request.getParameter("rol")); 

        if (usuarioDAO.registrar(u)) {
            response.sendRedirect("empleados?msg=registrado");
        } else {
            response.sendRedirect("empleados?error=errorGuardar");
        }
    }
}