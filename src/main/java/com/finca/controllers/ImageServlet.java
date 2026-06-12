package com.finca.controllers;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/uploads/*")
public class ImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filename = request.getPathInfo();
        
        // Evita que busquen la carpeta vacía
        if (filename == null || filename.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        filename = filename.substring(1); // Quitar el slash inicial "/"
        
        // =================================================================
        // CORRECCIÓN: RUTA DINÁMICA ABSOLUTA
        // Esto garantiza que busque en la misma carpeta donde EmpleadoServlet
        // y PerfilServlet guardan las fotografías.
        // =================================================================
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File file = new File(uploadPath, filename);
        
        if (file.exists()) {
            // DETECTA EL TIPO DE ARCHIVO (png, jpg)
            String mimeType = getServletContext().getMimeType(file.getName());
            if (mimeType == null) {
                mimeType = "application/octet-stream";
            }
            
            // Envía la imagen al HTML
            response.setContentType(mimeType);
            response.setContentLength((int) file.length());
            Files.copy(file.toPath(), response.getOutputStream());
        } else {
            // Si la foto no existe, imprime la ruta exacta donde la buscó para ayudar a depurar
            System.err.println("IMAGEN NO ENCONTRADA EN: " + file.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}