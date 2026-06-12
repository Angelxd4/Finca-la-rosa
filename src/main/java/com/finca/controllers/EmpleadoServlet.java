package com.finca.controllers;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Date;
import java.util.UUID;

import com.finca.dao.UsuarioDAO;
import com.finca.models.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/empleados")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
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
        
        if ("registrado".equals(msg)) request.setAttribute("successMessage", "Empleado registrado exitosamente con foto y ficha técnica.");
        if ("actualizado".equals(msg)) request.setAttribute("successMessage", "Ficha técnica y foto del empleado actualizadas correctamente.");
        if ("eliminado".equals(msg)) request.setAttribute("successMessage", "Empleado dado de baja del sistema.");
        if ("errorEliminar".equals(error)) request.setAttribute("errorMessage", "No se puede eliminar. El empleado tiene registros históricos, producciones o ventas asociadas.");
        if ("errorGuardar".equals(error)) request.setAttribute("errorMessage", "Error al procesar. Verifique que el correo o documento no estén duplicados.");

        request.getRequestDispatcher("empleados.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (usuarioDAO.eliminar(id)) {
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

        // ==========================================
        // LÓGICA DE DOBLE GUARDADO (DUAL SAVE)
        // ==========================================
        String fileName = request.getParameter("oldProfilePicture"); 
        Part filePart = request.getPart("profilePicture");

        if (filePart != null && filePart.getSize() > 0) {
            String extension = filePart.getSubmittedFileName().substring(filePart.getSubmittedFileName().lastIndexOf("."));
            fileName = "avatar_" + UUID.randomUUID().toString() + extension;
            
            // 1. Guardar en la carpeta Target de Tomcat (Para verla instantáneamente en el HTML)
            String targetPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
            File targetDir = new File(targetPath);
            if (!targetDir.exists()) targetDir.mkdir();
            filePart.write(targetPath + File.separator + fileName);
            
            // 2. Hacer una copia de seguridad física en el código fuente (Para que Maven no la borre)
            String srcPath = "C:\\Users\\angel\\OneDrive\\Desktop\\Ejercicios Java\\Finca la rosa\\gestion-ganadera\\src\\main\\webapp\\uploads";
            File srcDir = new File(srcPath);
            if (!srcDir.exists()) srcDir.mkdir();
            
            Files.copy(
                new File(targetPath + File.separator + fileName).toPath(), 
                new File(srcPath + File.separator + fileName).toPath(),
                StandardCopyOption.REPLACE_EXISTING
            );
        }
        u.setProfilePicture(fileName);

        // ==========================================
        // ACCIONES DE BASE DE DATOS
        // ==========================================
        if ("edit".equals(action)) {
            if (usuarioDAO.actualizarPerfil(u)) {
                response.sendRedirect("empleados?msg=actualizado");
            } else {
                response.sendRedirect("empleados?error=errorGuardar");
            }
            return;
        }

        if (usuarioDAO.registrar(u)) { 
            Usuario recienCreado = usuarioDAO.obtenerPorEmail(u.getEmail());
            if (recienCreado != null) {
                u.setId(recienCreado.getId());
                usuarioDAO.actualizarPerfil(u);
            }
            response.sendRedirect("empleados?msg=registrado");
        } else {
            response.sendRedirect("empleados?error=errorGuardar");
        }
    }
}