package com.finca.controllers;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.finca.dao.BovinoDAO;
import com.finca.dao.ProduccionDAO;
import com.finca.dao.UsuarioDAO;
import com.finca.models.Bovino;
import com.finca.models.DetalleOrdeno;
import com.finca.models.Ordeno;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/produccion")
public class ProduccionServlet extends HttpServlet {

    // CORRECCIÓN HINTS VS CODE: Añadimos 'final' para optimizar la memoria y quitar alertas
    private final ProduccionDAO produccionDAO = new ProduccionDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO(); 
    private final BovinoDAO bovinoDAO = new BovinoDAO(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("usuarioLogueado") == null) { response.sendRedirect("login"); return; }

        request.setAttribute("historial", produccionDAO.obtenerHistorial());
        request.setAttribute("stockLeche", produccionDAO.obtenerStockLeche());
        
        try {
            request.setAttribute("listaEmpleados", usuarioDAO.obtenerTodos());
            request.setAttribute("listaVacas", bovinoDAO.obtenerPorClasificacion("Producción"));
        } catch (Exception e) {}
        
        if (request.getParameter("msg") != null) request.setAttribute("successMessage", "¡Sesión de ordeño registrada exitosamente!");
        if (request.getParameter("error") != null) request.setAttribute("errorMessage", "Debe ingresar litros en al menos una vaca.");
        
        request.getRequestDispatcher("produccion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("usuarioLogueado") == null) { response.sendRedirect("login"); return; }

        Ordeno sesionOrdeno = new Ordeno();
        String fechaStr = request.getParameter("fechaHora").replace("T", " ") + ":00";
        sesionOrdeno.setFechaHora(Timestamp.valueOf(fechaStr));
        sesionOrdeno.setLugar(request.getParameter("lugar"));
        sesionOrdeno.setSupervisorId(Integer.parseInt(request.getParameter("supervisorId"))); 
        
        String observacionesOriginales = request.getParameter("observaciones");
        if(observacionesOriginales == null) observacionesOriginales = "";

        List<Bovino> vacas = bovinoDAO.obtenerPorClasificacion("Producción");
        List<DetalleOrdeno> detalles = new ArrayList<>();
        double totalLitros = 0.0;
        int totalVacas = 0;
        
        StringBuilder anotacionDescarte = new StringBuilder();

        for(Bovino v : vacas) {
            String litrosSanosStr = request.getParameter("litros_vaca_" + v.getIdBovino());
            if(litrosSanosStr != null && !litrosSanosStr.trim().isEmpty()) {
                double litrosObtenidos = Double.parseDouble(litrosSanosStr);
                if(litrosObtenidos > 0) {
                    DetalleOrdeno d = new DetalleOrdeno();
                    d.setIdBovino(v.getIdBovino());
                    d.setLitrosObtenidos(litrosObtenidos);
                    detalles.add(d);
                    
                    totalLitros += litrosObtenidos;
                    totalVacas++;
                }
            }
            
            String litrosDescarteStr = request.getParameter("litros_descarte_vaca_" + v.getIdBovino());
            if(litrosDescarteStr != null && !litrosDescarteStr.trim().isEmpty()) {
                double litrosDescarte = Double.parseDouble(litrosDescarteStr);
                if(litrosDescarte > 0) {
                    anotacionDescarte.append("\n⚠️ Ordeño de Descarte (").append(v.getNumeroArete()).append("): ").append(litrosDescarte).append(" Litros.");
                }
            }
        }

        if(anotacionDescarte.length() > 0) {
            observacionesOriginales += "\n" + anotacionDescarte.toString();
        }

        if (detalles.isEmpty() && anotacionDescarte.length() == 0) {
            response.sendRedirect("produccion?error=1");
            return;
        }

        // CORRECCIÓN: El error 8 ya no ocurrirá porque el método ha regresado
        sesionOrdeno.setObservaciones(observacionesOriginales);
        sesionOrdeno.setTotalLitros(totalLitros);
        sesionOrdeno.setTotalVacas(totalVacas);
        sesionOrdeno.setPromedioLitros(totalVacas > 0 ? (totalLitros / totalVacas) : 0.0);
        sesionOrdeno.setDetalles(detalles);

        if (produccionDAO.registrarSesion(sesionOrdeno)) {
            response.sendRedirect("produccion?msg=registrado");
        } else {
            response.sendRedirect("produccion?error=1");
        }
    }
}