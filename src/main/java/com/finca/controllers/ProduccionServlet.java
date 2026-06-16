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
import com.finca.models.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/produccion")
public class ProduccionServlet extends HttpServlet {

    private final ProduccionDAO produccionDAO = new ProduccionDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO(); 
    private final BovinoDAO bovinoDAO = new BovinoDAO(); 

    // 🔒 NUEVO: Método de Seguridad para restringir el acceso a la Lechería
    private boolean verificarPermisoOperarioYAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (usuarioLogueado == null) {
            response.sendRedirect("login");
            return false;
        }
        
        String rol = usuarioLogueado.getRol() != null ? usuarioLogueado.getRol() : "";
        // Solo permitimos el paso a Administrador (1) y Operario/Vaquero (3)
        if (!rol.equals("1") && !rol.equalsIgnoreCase("Administrador") && 
            !rol.equals("3") && !rol.equalsIgnoreCase("Operario")) {
            
            response.sendRedirect("dashboard?error=acceso_denegado");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 🔒 BLINDAJE DE SEGURIDAD (Si no es Admin u Operario, se detiene la ejecución)
        if (!verificarPermisoOperarioYAdmin(request, response)) {
            return;
        }

        String filtro = request.getParameter("f");
        if (filtro == null) filtro = "dia";
        request.setAttribute("filtroActivo", filtro);

        request.setAttribute("historial", produccionDAO.obtenerHistorial(filtro));
        
        request.setAttribute("stockFabrica", produccionDAO.obtenerStock("LAC-001"));
        request.setAttribute("stockVenta", produccionDAO.obtenerStock("LAC-002"));
        
        double[] stats = produccionDAO.obtenerEstadisticas(filtro);
        request.setAttribute("stats", stats);
        
        try {
            request.setAttribute("listaEmpleados", usuarioDAO.obtenerTodos());
            request.setAttribute("listaVacas", bovinoDAO.obtenerPorClasificacion("Producción"));
        } catch (Exception e) {}
        
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
        // 🔒 BLINDAJE DE SEGURIDAD PARA OPERACIONES DE ESCRITURA (Guardar/Vaciar tanques)
        if (!verificarPermisoOperarioYAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        String filtroRetorno = request.getParameter("filtroActual");
        if (filtroRetorno == null) filtroRetorno = "dia";

        // ACCIÓN: DISTRIBUIR LECHE AL TANQUE
        if ("asignar".equals(action)) {
            String turno = request.getParameter("turno");
            double porcFabrica = Double.parseDouble(request.getParameter("porcFabrica"));
            
            if (produccionDAO.asignarLeche(filtroRetorno, turno, porcFabrica)) {
                response.sendRedirect("produccion?f=" + filtroRetorno + "&msg=asignado");
            } else {
                response.sendRedirect("produccion?f=" + filtroRetorno + "&error=1");
            }
            return;
        }

        // ACCIÓN: VACIAR EL TANQUE DE DESCARTE
        if ("vaciar_descarte".equals(action)) {
            if (produccionDAO.vaciarDescartePendiente(filtroRetorno)) {
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

        List<Bovino> vacas = bovinoDAO.obtenerPorClasificacion("Producción");
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
            if (produccionDAO.fueOrdenadaEnTurno(det.getIdBovino(), sesionOrdeno.getFechaHora())) {
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

        if (produccionDAO.registrarSesion(sesionOrdeno)) {
            response.sendRedirect("produccion?f=" + filtroRetorno + "&msg=registrado");
        } else {
            response.sendRedirect("produccion?f=" + filtroRetorno + "&error=1");
        }
    }
}