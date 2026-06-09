package com.finca.controllers;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

import com.finca.dao.BovinoDAO;
import com.finca.dao.LoteDAO;
import com.finca.dao.ProduccionDAO;
import com.finca.dao.ProductoLacteoDAO;
import com.finca.models.Bovino;
import com.finca.models.HistorialClinico;
import com.finca.models.LoteProduccion;
import com.finca.models.Ordeno;
import com.finca.models.ProductoLacteo;
import com.finca.models.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Validar Seguridad
        HttpSession session = request.getSession();
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
        if (usuarioLogueado == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Instanciar todos los DAOs
            BovinoDAO bovinoDAO = new BovinoDAO();
            ProduccionDAO produccionDAO = new ProduccionDAO();
            ProductoLacteoDAO lacteosDAO = new ProductoLacteoDAO();
            LoteDAO loteDAO = new LoteDAO();

            // =======================================================
            // INVENTARIO BOVINO Y HATO
            // =======================================================
            List<Bovino> bovinos = bovinoDAO.obtenerTodos();
            int totalBovinos = bovinos.size();
            int prod = 0, crias = 0, toros = 0, atencionesMedicas = 0;
            
            for (Bovino b : bovinos) {
                String clasif = b.getClasificacion() != null ? b.getClasificacion().toLowerCase() : "";
                if (clasif.contains("producci")) prod++;
                else if (clasif.contains("cría") || clasif.contains("cria") || clasif.contains("terner")) crias++;
                else if (clasif.contains("toro") || clasif.contains("semental")) toros++;
                else prod++; 

                String estado = b.getEstadoSalud() != null ? b.getEstadoSalud().toLowerCase() : "";
                if (!estado.contains("sano") && !estado.contains("excelente") && !estado.contains("saludable")) {
                    atencionesMedicas++;
                }
            }
            
            int porcProduccion = totalBovinos > 0 ? (prod * 100) / totalBovinos : 0;
            int porcCrias = totalBovinos > 0 ? (crias * 100) / totalBovinos : 0;
            int porcToros = totalBovinos > 0 ? (toros * 100) / totalBovinos : 0;

            // =======================================================
            // LÁCTEOS Y QUESOS
            // =======================================================
            double stockLeche = produccionDAO.obtenerStockLeche();
            
            List<ProductoLacteo> lacteos = lacteosDAO.obtenerTodos();
            double lotesQueso = 0;
            for (ProductoLacteo p : lacteos) {
                if (!"LAC-001".equals(p.getCodigo())) { 
                    lotesQueso += p.getStock();
                }
            }

            // =======================================================
            // HISTORIAL DE ORDEÑO (Gráfico de Líneas)
            // =======================================================
            List<Ordeno> historial = produccionDAO.obtenerHistorial();
            request.setAttribute("historial", historial);
            
            StringBuilder labels = new StringBuilder();
            StringBuilder data = new StringBuilder();
            int limit = Math.min(historial.size(), 7);
            
            for (int i = limit - 1; i >= 0; i--) {
                Ordeno o = historial.get(i);
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM");
                labels.append("'").append(sdf.format(o.getFechaHora())).append("'");
                data.append(o.getTotalLitros());
                
                if (i > 0) {
                    labels.append(", ");
                    data.append(", ");
                }
            }
            
            if (labels.length() == 0) {
                labels.append("'Sin datos'");
                data.append("0");
            }

            // =======================================================
            // ACTIVIDADES RECIENTES Y LOTES (Timeline y Tabla)
            // =======================================================
            // Extraer las últimas actividades generales de los animales
            List<HistorialClinico> actividades = bovinoDAO.obtenerHistorialGeneral();
            request.setAttribute("actividadesRecientes", actividades);

            // Extraer los últimos lotes/movimientos
            List<LoteProduccion> ultimosLotes = loteDAO.obtenerTodos();
            request.setAttribute("ultimosLotes", ultimosLotes);

            // =======================================================
            // ENVIAR VARIABLES A LA VISTA
            // =======================================================
            request.setAttribute("totalBovinos", totalBovinos);
            request.setAttribute("stockLeche", stockLeche);
            request.setAttribute("atencionesMedicas", atencionesMedicas);
            request.setAttribute("lotesQueso", (int) lotesQueso);
            
            request.setAttribute("porcProduccion", porcProduccion);
            request.setAttribute("porcCrias", porcCrias);
            request.setAttribute("porcToros", porcToros);
            
            request.setAttribute("labelsGrafico", labels.toString());
            request.setAttribute("datosGrafico", data.toString());

        } catch (Exception e) {
            System.err.println("Error procesando los datos del Dashboard: " + e.getMessage());
        }

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}