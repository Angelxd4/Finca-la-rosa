package com.finca.controllers;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// IMPORTANTE: Esta ruta es la que el HTML usará para pedir la foto.
@WebServlet("/uploads/*")
public class ImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filename = request.getPathInfo();
        if (filename == null || filename.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        filename = filename.substring(1);
        
        // RUTA DONDE ESTÁN GUARDADAS TUS FOTOS (La que usamos en BovinoServlet)
        String uploadPath = "C:\\Users\\angel\\OneDrive\\Desktop\\Ejercicios Java\\Finca la rosa\\gestion-ganadera\\src\\main\\webapp\\uploads";
        File file = new File(uploadPath, filename);
        
        if (file.exists()) {
            // DETECTA EL TIPO DE ARCHIVO (png, jpg)
            String mimeType = getServletContext().getMimeType(file.getName());
            if (mimeType == null) mimeType = "application/octet-stream";
            
            response.setContentType(mimeType);
            response.setContentLength((int) file.length());
            Files.copy(file.toPath(), response.getOutputStream());
        } else {
            System.err.println("IMAGEN NO ENCONTRADA: " + file.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}