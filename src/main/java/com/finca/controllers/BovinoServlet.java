package com.finca.controllers;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Date;

import com.finca.dao.BovinoDAO;
import com.finca.models.Bovino;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/inventario-ganado")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class BovinoServlet extends HttpServlet {
    
    private final BovinoDAO bovinoDAO = new BovinoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("usuarioLogueado") == null) { response.sendRedirect("login"); return; }
        
        request.setAttribute("listaProduccion", bovinoDAO.obtenerPorClasificacion("Producción"));
        request.setAttribute("listaVenta", bovinoDAO.obtenerPorClasificacion("Venta"));
        
        // ¡LA SOLUCIÓN ESTÁ AQUÍ! Ahora el Servlet busca las crías y se las envía al JSP
        request.setAttribute("listaCrias", bovinoDAO.obtenerPorClasificacion("Cría"));
        
        request.getRequestDispatcher("inventario-ganado.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("mover".equals(action)) {
                bovinoDAO.cambiarClasificacion(Integer.parseInt(request.getParameter("id")), request.getParameter("destino"));
                response.sendRedirect("inventario-ganado?msg=movido");
                return;
            }

            if ("delete".equals(action)) {
                bovinoDAO.eliminar(Integer.parseInt(request.getParameter("id")));
                response.sendRedirect("inventario-ganado?msg=eliminado");
                return;
            }

            Bovino b = new Bovino();
            if ("edit".equals(action)) b.setIdBovino(Integer.parseInt(request.getParameter("idBovino")));

            b.setNumeroArete(request.getParameter("numeroArete"));
            b.setRaza(request.getParameter("raza"));
            b.setGenero(request.getParameter("genero"));
            b.setPesoKg(Double.parseDouble(request.getParameter("pesoKg")));
            b.setProposito(request.getParameter("proposito"));
            b.setEstadoSalud(request.getParameter("estadoSalud"));
            b.setFechaNacimiento(Date.valueOf(request.getParameter("fechaNacimiento")));
            b.setPrecioEstimado(Double.parseDouble(request.getParameter("precioEstimado")));
            b.setClasificacion(request.getParameter("clasificacion"));
            b.setNumeroPartos(request.getParameter("numeroPartos").isEmpty() ? 0 : Integer.parseInt(request.getParameter("numeroPartos")));
            b.setLitrosDiariosPromedio(request.getParameter("litrosDiarios").isEmpty() ? 0 : Double.parseDouble(request.getParameter("litrosDiarios")));

            Part filePart = request.getPart("imageFile");
            String imagePath = request.getParameter("imageUrl");

            if (filePart != null && filePart.getSize() > 0) {
                String extension = ".png"; // Por defecto
                String submittedFileName = filePart.getSubmittedFileName();
                if (submittedFileName.contains(".")) extension = submittedFileName.substring(submittedFileName.lastIndexOf('.'));
                
                String dynamicFileName = "arete_" + b.getNumeroArete().replaceAll("[^a-zA-Z0-9]", "_") + extension;
                
                // Ruta Tomcat
                String tomcatPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
                new File(tomcatPath).mkdirs();
                String rutaTomcat = tomcatPath + File.separator + dynamicFileName;
                
                try (InputStream is = filePart.getInputStream(); FileOutputStream os = new FileOutputStream(rutaTomcat)) {
                    is.transferTo(os);
                }
                
                // Ruta Fuente (OneDrive)
                String sourcePath = "C:\\Users\\angel\\OneDrive\\Desktop\\Ejercicios Java\\Finca la rosa\\gestion-ganadera\\src\\main\\webapp\\uploads";
                File sourceDir = new File(sourcePath);
                if (sourceDir.exists()) {
                    Files.copy(new File(rutaTomcat).toPath(), new File(sourcePath + File.separator + dynamicFileName).toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                
                imagePath = "uploads/" + dynamicFileName;
            }
            b.setImageUrl(imagePath);

            if ("edit".equals(action)) {
                bovinoDAO.actualizar(b);
                response.sendRedirect("inventario-ganado?msg=actualizado");
            } else {
                bovinoDAO.registrar(b);
                response.sendRedirect("inventario-ganado?msg=registrado");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("inventario-ganado?error=1");
        }
    }
}