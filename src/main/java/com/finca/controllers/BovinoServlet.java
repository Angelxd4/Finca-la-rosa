package com.finca.controllers;

import java.io.IOException;
import java.sql.Date;

import com.finca.services.AuthService;
import com.finca.services.BovinoService;
import com.finca.services.FileService;
import com.finca.models.Bovino;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/inventario-ganado")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class BovinoServlet extends HttpServlet {
    
    private final BovinoService bovinoService = new BovinoService();
    private final AuthService authService = new AuthService();
    private final FileService fileService = new FileService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authService.estaAutenticado(request)) { response.sendRedirect("login"); return; }
        
        request.setAttribute("listaProduccion", bovinoService.obtenerPorClasificacion("Producción"));
        request.setAttribute("listaVenta", bovinoService.obtenerPorClasificacion("Venta"));
        request.setAttribute("listaCrias", bovinoService.obtenerPorClasificacion("Cría"));
        
        request.getRequestDispatcher("inventario-ganado.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }

        boolean esVeterinario = authService.esVeterinario(request);
        boolean esOperario = authService.esOperario(request);
        String action = request.getParameter("action");
        
        try {
            // 🔒 BLINDAJE DE SEGURIDAD: Veterinario y Operario no pueden vender ni eliminar
            if (esVeterinario || esOperario) {
                if ("delete".equals(action) || ("mover".equals(action) && "Venta".equals(request.getParameter("destino")))) {
                    response.sendRedirect("inventario-ganado?error=No tienes permisos para vender o dar de baja animales.");
                    return;
                }
            }

            // Operario tampoco puede mover a Producción/Cría/etc.
            if (esOperario && "mover".equals(action)) {
                response.sendRedirect("inventario-ganado?error=No tienes permisos para mover animales.");
                return;
            }

            if ("mover".equals(action)) {
                bovinoService.cambiarClasificacion(Integer.parseInt(request.getParameter("id")), request.getParameter("destino"));
                response.sendRedirect("inventario-ganado?msg=movido");
                return;
            }

            if ("delete".equals(action)) {
                bovinoService.eliminarBovino(Integer.parseInt(request.getParameter("id")));
                response.sendRedirect("inventario-ganado?msg=eliminado");
                return;
            }

            // Operario no puede crear nuevos bovinos
            if (esOperario && !"edit".equals(action)) {
                response.sendRedirect("inventario-ganado?error=No tienes permisos para registrar nuevos animales.");
                return;
            }

            Bovino b = new Bovino();
            if ("edit".equals(action)) {
                int idBovino = Integer.parseInt(request.getParameter("idBovino"));
                b.setIdBovino(idBovino);
                
                if (esOperario) {
                    // Solo puede editar el estado de salud, recuperamos el resto de la BDD
                    Bovino bovinoExistente = bovinoService.obtenerPorId(idBovino);
                    if (bovinoExistente != null) {
                        b.setNumeroArete(bovinoExistente.getNumeroArete());
                        b.setRaza(bovinoExistente.getRaza());
                        b.setGenero(bovinoExistente.getGenero());
                        b.setPesoKg(bovinoExistente.getPesoKg());
                        b.setProposito(bovinoExistente.getProposito());
                        b.setFechaNacimiento(bovinoExistente.getFechaNacimiento());
                        b.setPrecioEstimado(bovinoExistente.getPrecioEstimado());
                        b.setClasificacion(bovinoExistente.getClasificacion());
                        b.setNumeroPartos(bovinoExistente.getNumeroPartos());
                        b.setLitrosDiariosPromedio(bovinoExistente.getLitrosDiariosPromedio());
                        b.setImageUrl(bovinoExistente.getImageUrl());
                    }
                }
            }

            if (!esOperario) {
                b.setNumeroArete(request.getParameter("numeroArete"));
                b.setRaza(request.getParameter("raza"));
                b.setGenero(request.getParameter("genero"));
                b.setPesoKg(Double.parseDouble(request.getParameter("pesoKg")));
                b.setProposito(request.getParameter("proposito"));
                b.setFechaNacimiento(Date.valueOf(request.getParameter("fechaNacimiento")));
                b.setPrecioEstimado(Double.parseDouble(request.getParameter("precioEstimado")));
                b.setClasificacion(request.getParameter("clasificacion"));
                b.setNumeroPartos(request.getParameter("numeroPartos").isEmpty() ? 0 : Integer.parseInt(request.getParameter("numeroPartos")));
                b.setLitrosDiariosPromedio(request.getParameter("litrosDiarios").isEmpty() ? 0 : Double.parseDouble(request.getParameter("litrosDiarios")));

                Part filePart = request.getPart("imageFile");
                String imagePath = request.getParameter("imageUrl");
                imagePath = fileService.guardarImagenBovino(request, filePart, b.getNumeroArete(), imagePath);
                b.setImageUrl(imagePath);
            }

            // Ambos pueden actualizar el estado de salud
            b.setEstadoSalud(request.getParameter("estadoSalud"));

            if ("edit".equals(action)) {
                bovinoService.actualizarBovino(b);
                response.sendRedirect("inventario-ganado?msg=actualizado");
            } else {
                bovinoService.registrarBovino(b);
                response.sendRedirect("inventario-ganado?msg=registrado");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("inventario-ganado?error=1");
        }
    }
}