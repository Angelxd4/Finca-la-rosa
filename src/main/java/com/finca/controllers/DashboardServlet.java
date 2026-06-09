package com.finca.controllers;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
            // ESTADÍSTICAS DE PRODUCCIÓN Y TANQUES
            // =======================================================
            double stockFabrica = produccionDAO.obtenerStock("LAC-001");
            double stockVenta = produccionDAO.obtenerStock("LAC-002");
            double totalStockTanques = stockFabrica + stockVenta;
            
            double[] statsDiarias = produccionDAO.obtenerEstadisticas("dia");
            double totalProduccionHoy = statsDiarias[0] + statsDiarias[1];
            double descarteHoy = statsDiarias[2];

            List<ProductoLacteo> lacteos = lacteosDAO.obtenerTodos();
            double lotesQueso = 0;
            for (ProductoLacteo p : lacteos) {
                if (!"LAC-001".equals(p.getCodigo()) && !"LAC-002".equals(p.getCodigo())) { 
                    lotesQueso += p.getStock();
                }
            }

            // =======================================================
            // HISTORIAL DE ORDEÑO (Agrupado por día para el Gráfico)
            // =======================================================
            List<Ordeno> historial = produccionDAO.obtenerHistorial("todo");
            
            // Agrupar producción por día (Últimos 7 días de actividad)
            Map<String, Double> produccionPorDia = new LinkedHashMap<>();
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM");
            
            for (Ordeno o : historial) {
                String dia = sdf.format(o.getFechaHora());
                produccionPorDia.put(dia, produccionPorDia.getOrDefault(dia, 0.0) + o.getTotalLitros());
            }

            // Invertir para mostrar de más antiguo a más reciente
            List<String> diasList = produccionPorDia.keySet().stream().collect(Collectors.toList());
            Collections.reverse(diasList);
            
            StringBuilder labels = new StringBuilder();
            StringBuilder data = new StringBuilder();
            int contador = 0;
            
            for (String dia : diasList) {
                if (contador >= 7) break; // Solo los últimos 7 días
                
                if (contador > 0) {
                    labels.append(", ");
                    data.append(", ");
                }
                labels.append("'").append(dia).append("'");
                data.append(produccionPorDia.get(dia));
                contador++;
            }
            
            if (labels.length() == 0) {
                labels.append("'Sin datos'");
                data.append("0");
            }

            // =======================================================
            // ACTIVIDADES RECIENTES Y LOTES (Timeline y Tabla)
            // =======================================================
            List<HistorialClinico> actividades = bovinoDAO.obtenerHistorialGeneral();
            request.setAttribute("actividadesRecientes", actividades);

            List<LoteProduccion> ultimosLotes = loteDAO.obtenerTodos();
            request.setAttribute("ultimosLotes", ultimosLotes);

            // =======================================================
            // ENVIAR VARIABLES A LA VISTA
            // =======================================================
            request.setAttribute("totalBovinos", totalBovinos);
            request.setAttribute("stockLeche", totalStockTanques); // Suma de ambos tanques
            request.setAttribute("produccionHoy", totalProduccionHoy); // Nueva métrica
            request.setAttribute("descarteHoy", descarteHoy); // Nueva métrica
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