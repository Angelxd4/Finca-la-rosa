package com.finca.services;

import com.finca.dao.BovinoDAO;
import com.finca.dao.LoteDAO;
import com.finca.dao.ProduccionDAO;
import com.finca.dao.ProductoLacteoDAO;
import com.finca.models.Bovino;
import com.finca.models.HistorialClinico;
import com.finca.models.LoteProduccion;
import com.finca.models.Ordeno;
import com.finca.models.ProductoLacteo;

import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class DashboardService {

    private final BovinoDAO bovinoDAO = new BovinoDAO();
    private final ProduccionDAO produccionDAO = new ProduccionDAO();
    private final ProductoLacteoDAO lacteosDAO = new ProductoLacteoDAO();
    private final LoteDAO loteDAO = new LoteDAO();

    public Map<String, Object> obtenerEstadisticasDashboard() {
        Map<String, Object> stats = new LinkedHashMap<>();

        // INVENTARIO BOVINO Y HATO
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

        // ESTADÍSTICAS DE PRODUCCIÓN Y TANQUES
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

        // HISTORIAL DE ORDEÑO (Agrupado por día para el Gráfico)
        List<Ordeno> historial = produccionDAO.obtenerHistorial("todo");
        Map<String, Double> produccionPorDia = new LinkedHashMap<>();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM");
        
        for (Ordeno o : historial) {
            String dia = sdf.format(o.getFechaHora());
            produccionPorDia.put(dia, produccionPorDia.getOrDefault(dia, 0.0) + o.getTotalLitros());
        }

        List<String> diasList = produccionPorDia.keySet().stream().collect(Collectors.toList());
        Collections.reverse(diasList);
        
        StringBuilder labels = new StringBuilder();
        StringBuilder data = new StringBuilder();
        int contador = 0;
        
        for (String dia : diasList) {
            if (contador >= 7) break; 
            
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

        // ACTIVIDADES RECIENTES Y LOTES
        List<HistorialClinico> actividades = bovinoDAO.obtenerHistorialGeneral();
        List<LoteProduccion> ultimosLotes = loteDAO.obtenerTodos();

        stats.put("totalBovinos", totalBovinos);
        stats.put("stockLeche", totalStockTanques); 
        stats.put("produccionHoy", totalProduccionHoy); 
        stats.put("descarteHoy", descarteHoy); 
        stats.put("atencionesMedicas", atencionesMedicas);
        stats.put("lotesQueso", (int) lotesQueso);
        
        stats.put("porcProduccion", porcProduccion);
        stats.put("porcCrias", porcCrias);
        stats.put("porcToros", porcToros);
        
        stats.put("labelsGrafico", labels.toString());
        stats.put("datosGrafico", data.toString());

        stats.put("actividadesRecientes", actividades);
        stats.put("ultimosLotes", ultimosLotes);

        return stats;
    }
}
