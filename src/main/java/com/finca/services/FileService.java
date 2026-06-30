package com.finca.services;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

public class FileService {

    /**
     * Guarda la imagen del bovino tanto en Tomcat como en la ruta local del repositorio.
     * Retorna la ruta relativa que se guardará en la base de datos (ej. "uploads/arete_123.png").
     */
    public String guardarImagenBovino(HttpServletRequest request, Part filePart, String numeroArete, String currentImagePath) throws Exception {
        if (filePart != null && filePart.getSize() > 0) {
            String extension = ".png"; // Por defecto
            String submittedFileName = filePart.getSubmittedFileName();
            if (submittedFileName != null && submittedFileName.contains(".")) {
                extension = submittedFileName.substring(submittedFileName.lastIndexOf('.'));
            }
            
            String dynamicFileName = "arete_" + numeroArete.replaceAll("[^a-zA-Z0-9]", "_") + extension;
            
            // Ruta Tomcat o Ruta Externa en Railway
            String tomcatPath;
            if (File.separator.equals("/")) {
                // Estamos en Linux (Railway Docker)
                tomcatPath = "/app/uploads";
            } else {
                // Estamos en Windows (Entorno Local)
                tomcatPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
            }
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
            
            return "uploads/" + dynamicFileName;
        }
        
        return currentImagePath; // Retorna la original si no se subió ninguna
    }

    public String guardarImagenEmpleado(HttpServletRequest request, Part filePart, String currentImagePath) throws Exception {
        if (filePart != null && filePart.getSize() > 0) {
            String extension = ".png"; // Por defecto
            String submittedFileName = filePart.getSubmittedFileName();
            if (submittedFileName != null && submittedFileName.contains(".")) {
                extension = submittedFileName.substring(submittedFileName.lastIndexOf('.'));
            }
            
            String dynamicFileName = "avatar_" + java.util.UUID.randomUUID().toString() + extension;
            
            // Ruta Tomcat o Ruta Externa en Railway
            String tomcatPath;
            if (File.separator.equals("/")) {
                tomcatPath = "/app/uploads";
            } else {
                tomcatPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
            }
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
            
            return dynamicFileName;
        }
        
        return currentImagePath;
    }
}
