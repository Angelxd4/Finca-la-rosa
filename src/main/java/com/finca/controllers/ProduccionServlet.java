package com.finca.controllers;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.finca.services.AuthService;
import com.finca.services.BovinoService;
import com.finca.services.ProduccionService;
import com.finca.models.Bovino;
import com.finca.models.DetalleOrdeno;
import com.finca.models.Ordeno;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/produccion")
public class ProduccionServlet extends HttpServlet {

    private final ProduccionService produccionService = new ProduccionService();
    private final AuthService authService = new AuthService();
    private final BovinoService bovinoService = new BovinoService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }

        if (!authService.tienePermisoProduccion(request)) {
            response.sendRedirect("dashboard?error=acceso_denegado");
            return;
        }

        String filtro = request.getParameter("f");
        if (filtro == null) filtro = "dia";
        request.setAttribute("filtroActivo", filtro);

        request.setAttribute("historial", produccionService.obtenerHistorial(filtro));
        request.setAttribute("stockFabrica", produccionService.obtenerStock("LAC-001"));
        request.setAttribute("stockVenta", produccionService.obtenerStock("LAC-002"));
        
        double[] stats = produccionService.obtenerEstadisticas(filtro);
        request.setAttribute("stats", stats);
        
        try {
            request.setAttribute("listaEmpleados", authService.obtenerTodosEmpleados());
            request.setAttribute("listaVacas", bovinoService.obtenerPorClasificacion("Producción"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (request.getParameter("msg") != null) {
            String m = request.getParameter("msg");
            if(m.equals("vaciado")) request.setAttribute("successMessage", "El tanque de descarte fue vaciado y lavado exitosamente.");
            else request.setAttribute("successMessage", "¡Operación completada exitosamente!");
        }
        
        if (request.getParameter("error") != null) {
            if ("duplicada".equals(request.getParameter("error"))) {
                request.setAttribute("errorMessage", "ALTO BIOLÓGICO: Una o más vacas seleccionadas ya fueron ordeñadas en el turno actual. La operación fue bloqueada.");
            } else {
                request.setAttribute("errorMessage", "Error al procesar la solicitud.");
            }
        }
        
        request.getRequestDispatcher("produccion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }

        if (!authService.tienePermisoProduccion(request)) {
            response.sendRedirect("dashboard?error=acceso_denegado");
            return;
        }

        String action = request.getParameter("action");
        String filtroRetorno = request.getParameter("filtroActual");
        if (filtroRetorno == null) filtroRetorno = "dia";

        // ACCIÓN: DISTRIBUIR LECHE AL TANQUE
        if ("asignar".equals(action)) {
            String turno = request.getParameter("turno");
            double porcFabrica = Double.parseDouble(request.getParameter("porcFabrica"));
            
            if (produccionService.asignarLeche(filtroRetorno, turno, porcFabrica)) {
                response.sendRedirect("produccion?f=" + filtroRetorno + "&msg=asignado");
            } else {
                response.sendRedirect("produccion?f=" + filtroRetorno + "&error=1");
            }
            return;
        }

        // ACCIÓN: VACIAR EL TANQUE DE DESCARTE
        if ("vaciar_descarte".equals(action)) {
            if (produccionService.vaciarDescartePendiente(filtroRetorno)) {
                response.sendRedirect("produccion?f=" + filtroRetorno + "&msg=vaciado");
            } else {
                response.sendRedirect("produccion?f=" + filtroRetorno + "&error=1");
            }
            return;
        }

        // ACCIÓN: REGISTRAR UN NUEVO ORDEÑO
        Ordeno sesionOrdeno = new Ordeno();
        String fechaStr = request.getParameter("fechaHora").replace("T", " ") + ":00";
        sesionOrdeno.setFechaHora(Timestamp.valueOf(fechaStr));
        sesionOrdeno.setLugar(request.getParameter("lugar"));
        sesionOrdeno.setSupervisorId(Integer.parseInt(request.getParameter("supervisorId"))); 
        
        String observaciones = request.getParameter("observaciones");
        if(observaciones == null) observaciones = "";

        List<Bovino> vacas = bovinoService.obtenerPorClasificacion("Producción");
        List<DetalleOrdeno> detalles = new ArrayList<>();
        double totalLitros = 0.0;
        int totalVacas = 0;
        double totalDescarte = 0.0;
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
                double lDescarte = Double.parseDouble(litrosDescarteStr);
                if(lDescarte > 0) {
                    totalDescarte += lDescarte;
                    anotacionDescarte.append("\n⚠️ Descarte (").append(v.getNumeroArete()).append("): ").append(lDescarte).append(" L.");
                }
            }
        }

        if(anotacionDescarte.length() > 0) observaciones += "\n" + anotacionDescarte.toString();

        if (detalles.isEmpty() && totalDescarte == 0) {
            response.sendRedirect("produccion?f=" + filtroRetorno + "&error=1");
            return;
        }

        // VALIDACIÓN BIOLÓGICA BACKEND
        for (DetalleOrdeno det : detalles) {
            if (produccionService.fueOrdenadaEnTurno(det.getIdBovino(), sesionOrdeno.getFechaHora())) {
                response.sendRedirect("produccion?f=" + filtroRetorno + "&error=duplicada");
                return;
            }
        }

        sesionOrdeno.setObservaciones(observaciones);
        sesionOrdeno.setTotalLitros(totalLitros);
        sesionOrdeno.setTotalVacas(totalVacas);
        sesionOrdeno.setTotalDescarte(totalDescarte);
        sesionOrdeno.setPromedioLitros(totalVacas > 0 ? (totalLitros / totalVacas) : 0.0);
        sesionOrdeno.setDetalles(detalles);

        if (produccionService.registrarSesion(sesionOrdeno)) {
            response.sendRedirect("produccion?f=" + filtroRetorno + "&msg=registrado");
        } else {
            response.sendRedirect("produccion?f=" + filtroRetorno + "&error=1");
        }
    }
}