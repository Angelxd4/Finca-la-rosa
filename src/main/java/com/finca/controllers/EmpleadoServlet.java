package com.finca.controllers;

import java.io.IOException;
import java.sql.Date;

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
import jakarta.servlet.http.Part;

@WebServlet("/empleados")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
public class EmpleadoServlet extends HttpServlet {

    private final EmpleadoService empleadoService = new EmpleadoService();
    private final AuthService authService = new AuthService();
    private final FileService fileService = new FileService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }

        if (!authService.esAdministrador(request)) {
            response.sendRedirect("dashboard?error=acceso_denegado");
            return;
        }

        request.setAttribute("empleados", empleadoService.obtenerTodos());

        String msg = request.getParameter("msg");
        String error = request.getParameter("error");
        
        if ("registrado".equals(msg)) request.setAttribute("successMessage", "Empleado registrado exitosamente con foto y ficha técnica.");
        if ("actualizado".equals(msg)) request.setAttribute("successMessage", "Ficha técnica y foto del empleado actualizadas correctamente.");
        if ("eliminado".equals(msg)) request.setAttribute("successMessage", "Empleado dado de baja del sistema.");
        if ("errorEliminar".equals(error)) request.setAttribute("errorMessage", "No se puede eliminar. El empleado tiene registros históricos, producciones o ventas asociadas.");
        if ("errorGuardar".equals(error)) request.setAttribute("errorMessage", "Error al procesar. Verifique que el correo o documento no estén duplicados.");

        request.getRequestDispatcher("empleados.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }

        if (!authService.esAdministrador(request)) {
            response.sendRedirect("dashboard?error=acceso_denegado");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (empleadoService.eliminar(id)) {
                response.sendRedirect("empleados?msg=eliminado");
            } else {
                response.sendRedirect("empleados?error=errorEliminar");
            }
            return;
        }

        Usuario u = new Usuario();
        if ("edit".equals(action)) {
            u.setId(Integer.parseInt(request.getParameter("id")));
        } else {
            u.setPassword(request.getParameter("password")); 
        }

        u.setFullName(request.getParameter("fullName"));
        u.setDocumentId(request.getParameter("documentId"));
        u.setEmail(request.getParameter("email"));
        u.setRol(request.getParameter("rol")); 
        u.setCodigoEmpleado(request.getParameter("codigoEmpleado"));
        u.setCargo(request.getParameter("cargo"));
        u.setTipoContrato(request.getParameter("tipoContrato"));
        u.setDepartamento(request.getParameter("departamento"));
        u.setJefeInmediato(request.getParameter("jefeInmediato"));
        u.setEps(request.getParameter("eps"));
        u.setContactoEmergencia(request.getParameter("contactoEmergencia"));
        u.setTelefono(request.getParameter("telefono"));
        u.setDireccion(request.getParameter("direccion"));
        u.setHorario(request.getParameter("horario"));
        u.setArl(request.getParameter("arl"));
        u.setTipoSangre(request.getParameter("tipoSangre"));
        u.setEstado(request.getParameter("estado"));

        try {
            String fechaIngresoStr = request.getParameter("fechaIngreso");
            if (fechaIngresoStr != null && !fechaIngresoStr.isEmpty()) u.setFechaIngreso(Date.valueOf(fechaIngresoStr));
            
            String fechaNacStr = request.getParameter("fechaNacimiento");
            if (fechaNacStr != null && !fechaNacStr.isEmpty()) u.setFechaNacimiento(Date.valueOf(fechaNacStr));
            
            String salarioStr = request.getParameter("salarioBase");
            if (salarioStr != null && !salarioStr.isEmpty()) u.setSalarioBase(Double.parseDouble(salarioStr));
        } catch (IllegalArgumentException e) {
            e.printStackTrace(); 
        }

        String fileName = request.getParameter("oldProfilePicture"); 
        try {
            Part filePart = request.getPart("profilePicture");
            fileName = fileService.guardarImagenEmpleado(request, filePart, fileName);
        } catch (Exception e) {
            e.printStackTrace();
        }
        u.setProfilePicture(fileName);

        // ==========================================
        // ACCIONES DE BASE DE DATOS
        // ==========================================
        if ("edit".equals(action)) {
            if (empleadoService.actualizarPerfil(u)) {
                response.sendRedirect("empleados?msg=actualizado");
            } else {
                response.sendRedirect("empleados?error=errorGuardar");
            }
            return;
        }

        if (empleadoService.registrar(u)) { 
            response.sendRedirect("empleados?msg=registrado");
        } else {
            response.sendRedirect("empleados?error=errorGuardar");
        }
    }
}