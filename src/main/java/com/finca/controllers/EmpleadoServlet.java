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

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Seguridad: Verificar sesión
        HttpSession session = request.getSession();
        if (session.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect("login");
            return;
        }

        // Obtener la lista y mandarla a la vista
        request.setAttribute("empleados", usuarioDAO.obtenerTodos());

        // Manejo de mensajes
        String msg = request.getParameter("msg");
        String error = request.getParameter("error");
        
        if ("registrado".equals(msg)) request.setAttribute("successMessage", "Empleado registrado exitosamente.");
        if ("eliminado".equals(msg)) request.setAttribute("successMessage", "Empleado eliminado del sistema.");
        if ("errorEliminar".equals(error)) request.setAttribute("errorMessage", "No se puede eliminar este empleado porque tiene registros de producción asociados.");
        if ("errorGuardar".equals(error)) request.setAttribute("errorMessage", "Error al guardar. Verifica que el correo o documento no estén duplicados.");

        request.getRequestDispatcher("empleados.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Acción: ELIMINAR EMPLEADO
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (usuarioDAO.eliminar(id)) {
                response.sendRedirect("empleados?msg=eliminado");
            } else {
                response.sendRedirect("empleados?error=errorEliminar");
            }
            return;
        }

        // Acción: REGISTRAR EMPLEADO (Por defecto si no es delete)
        Usuario u = new Usuario();
        u.setFullName(request.getParameter("fullName"));
        u.setDocumentId(request.getParameter("documentId"));
        u.setEmail(request.getParameter("email"));
        u.setPassword(request.getParameter("password"));
        u.setRoleId(Integer.parseInt(request.getParameter("roleId")));
        // Generar un código de barras de ejemplo basado en el documento
        u.setBarcode("EMP-" + request.getParameter("documentId"));

        if (usuarioDAO.registrar(u)) {
            response.sendRedirect("empleados?msg=registrado");
        } else {
            response.sendRedirect("empleados?error=errorGuardar");
        }
    }
}