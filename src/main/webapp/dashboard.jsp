<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.Ordeno" %>
<%@ page import="com.finca.models.HistorialClinico" %>
<%@ page import="com.finca.models.LoteProduccion" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Finca La Rosa</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            --brand-main: #1C7345;
            --brand-hover: #165c37;
            --brand-accent: #00A859;
            --brand-light: #eaf6ee;
        }

        body { font-family: 'Nunito', sans-serif; background-color: #f4f7f6; color: #2b3445; }
        
        .dash-card { background: #ffffff; border-radius: 12px; border: none; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03); padding: 24px; height: 100%; transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .dash-card:hover { box-shadow: 0 8px 25px rgba(0, 0, 0, 0.06); }
        .card-stock { background: linear-gradient(135deg, var(--brand-main), var(--brand-accent)); color: white; border-radius: 24px; box-shadow: 0 12px 30px rgba(28, 115, 69, 0.25); height: 100%; display: flex; flex-direction: column; justify-content: space-between; padding: 25px; position: relative; overflow: hidden; }
        .card-stock .watermark { position: absolute; right: -20px; bottom: -20px; font-size: 8rem; opacity: 0.1; transform: rotate(-15deg); pointer-events: none; }
        .card-title { font-size: 0.95rem; font-weight: 700; color: #555; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }

        .progress { background-color: #e9ecef; border-radius: 50px; overflow: hidden; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1); }
        .progress-bar { font-weight: 700; font-size: 10px; line-height: 12px; transition: width 1s ease-in-out; }

        .mini-stat-card { border-radius: 12px; padding: 20px; border: none; position: relative; overflow: hidden; }
        .mini-stat-card.green { background-color: #eaf6ee; border-left: 4px solid #1C7345; }
        .mini-stat-card.yellow { background-color: #fff3cd; border-left: 4px solid #ffc107; }
        .mini-stat-card.orange { background-color: #ffe5d0; border-left: 4px solid #fd7e14; }
        .mini-stat-card.purple { background-color: #f1ebff; border-left: 4px solid #6f42c1; }
        .mini-stat-card.red { background-color: #ffe3e3; border-left: 4px solid #dc3545; }

        .mini-stat-title { font-size: 0.8rem; font-weight: 700; text-transform: uppercase; color: #666; margin-bottom: 5px; }
        .mini-stat-value { font-size: 1.8rem; font-weight: 800; color: #2b3445; margin-bottom: 0; }
        .mini-stat-trend { font-size: 0.85rem; font-weight: 700; }

        .timeline { list-style: none; padding: 0; margin: 0; position: relative; }
        .timeline::before { content: ''; position: absolute; top: 0; bottom: 0; left: 15px; width: 2px; background: #e9ecef; }
        .timeline-item { position: relative; padding-left: 45px; margin-bottom: 25px; }
        .timeline-item:last-child { margin-bottom: 0; }
        .timeline-icon { position: absolute; left: 0; top: 0; width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 14px; z-index: 1; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        
        .bg-timeline-default { background-color: #6f42c1; } 
        .bg-timeline-vacuna { background-color: #0dcaf0; }   
        .bg-timeline-enfermedad { background-color: #fd7e14; } 
        .bg-timeline-parto { background-color: #198754; }    

        .timeline-time { font-size: 0.75rem; color: #999; font-weight: 600; margin-bottom: 4px; display: block; }
        .timeline-content { font-size: 0.9rem; color: #444; font-weight: 600; }

        .table-clean th { border-top: none; font-size: 0.75rem; text-transform: uppercase; color: #888; font-weight: 700; border-bottom: 2px solid #f1f1f1; padding-bottom: 15px; }
        .table-clean td { font-size: 0.9rem; font-weight: 600; color: #444; vertical-align: middle; border-bottom: 1px solid #f8f9fa; padding: 12px 5px; }
        .badge-status { padding: 6px 12px; border-radius: 6px; font-size: 0.75rem; font-weight: 700; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<input type="hidden" id="dashLabels" value="<%= request.getAttribute("labelsGrafico") != null ? request.getAttribute("labelsGrafico") : "L,M,M" %>">
<input type="hidden" id="dashDatos" value="<%= request.getAttribute("datosGrafico") != null ? request.getAttribute("datosGrafico") : "0,0,0" %>">
<input type="hidden" id="dashProd" value="<%= request.getAttribute("porcProduccion") != null ? request.getAttribute("porcProduccion") : "0" %>">
<input type="hidden" id="dashCrias" value="<%= request.getAttribute("porcCrias") != null ? request.getAttribute("porcCrias") : "0" %>">
<input type="hidden" id="dashToros" value="<%= request.getAttribute("porcToros") != null ? request.getAttribute("porcToros") : "0" %>">

<div class="container-fluid px-4 py-4">
    
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
        <div>
            <h3 class="fw-bolder text-dark mb-0">Dashboard General</h3>
            <span class="text-muted" style="font-size: 0.9rem;">Analíticas en tiempo real de Finca La Rosa</span>
        </div>
        <a href="produccion" class="btn btn-success fw-bold px-4 rounded-pill shadow-sm" style="background-color: #1C7345; border: none;">
            <i class="bi bi-droplet-half me-2"></i> Ir a Ordeño
        </a>
    </div>

    <div class="row g-4 mb-4">
        
        <div class="col-lg-3 col-md-6">
            <div class="mini-stat-card green">
                <div class="mini-stat-title">Producción de Hoy</div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="mini-stat-value"><%= request.getAttribute("produccionHoy") %> <span class="fs-6 fw-normal text-muted">L</span></div>
                    <div class="mini-stat-trend" style="color: #1C7345;"><i class="bi bi-check-circle-fill"></i> Leche Apta</div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6">
            <div class="mini-stat-card red">
                <div class="mini-stat-title">Descarte de Hoy</div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="mini-stat-value text-danger"><%= request.getAttribute("descarteHoy") %> <span class="fs-6 fw-normal text-danger opacity-50">L</span></div>
                    <div class="mini-stat-trend text-danger"><i class="bi bi-shield-x"></i> Aislada</div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6">
            <div class="mini-stat-card yellow">
                <div class="mini-stat-title">Tanques Disponibles</div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="mini-stat-value"><%= request.getAttribute("stockLeche") %> <span class="fs-6 fw-normal text-muted">L</span></div>
                    <div class="mini-stat-trend text-warning"><i class="bi bi-moisture"></i> Total Físico</div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6">
            <div class="mini-stat-card purple">
                <div class="mini-stat-title">Productos en Fábrica</div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="mini-stat-value"><%= request.getAttribute("lotesQueso") %> <span class="fs-6 fw-normal text-muted">Stock</span></div>
                    <div class="mini-stat-trend" style="color: #6f42c1;"><i class="bi bi-basket-fill"></i> Catálogo</div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-lg-8">
            <div class="dash-card">
                <div class="card-title">
                    <span style="color: #1C7345;"><i class="bi bi-graph-up me-2"></i> Tendencia de Producción (Últimos 7 días activos)</span>
                </div>
                <div style="height: 300px;">
                    <canvas id="lineChart"></canvas>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="dash-card">
                <div class="card-title">
                    <span><i class="bi bi-pie-chart-fill text-warning me-2"></i> Distribución del Hato (<%= request.getAttribute("totalBovinos") %> Cabezas)</span>
                </div>
                <div style="height: 250px; display: flex; justify-content: center; align-items: center;">
                    <canvas id="doughnutChart"></canvas>
                </div>
                <div class="mt-4 d-flex justify-content-around text-center border-top pt-3">
                    <div>
                        <h4 class="fw-bolder text-dark mb-0"><%= request.getAttribute("porcProduccion") %>%</h4>
                        <span class="text-muted" style="font-size: 0.75rem;">Producción</span>
                    </div>
                    <div>
                        <h4 class="fw-bolder text-dark mb-0"><%= request.getAttribute("porcCrias") %>%</h4>
                        <span class="text-muted" style="font-size: 0.75rem;">Crías</span>
                    </div>
                    <div>
                        <h4 class="fw-bolder text-dark mb-0"><%= request.getAttribute("porcToros") %>%</h4>
                        <span class="text-muted" style="font-size: 0.75rem;">Toros</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        
        <div class="col-lg-4">
            <div class="dash-card">
                <div class="card-title">
                    <span><i class="bi bi-activity text-danger me-2"></i> Actividades Clínicas Recientes</span>
                </div>
                
                <ul class="timeline mt-4">
                    <% 
                        List<HistorialClinico> actividades = (List<HistorialClinico>) request.getAttribute("actividadesRecientes");
                        if (actividades != null && !actividades.isEmpty()) {
                            int lim = Math.min(actividades.size(), 4); // Mostrar max 4
                            for(int j=0; j<lim; j++) {
                                HistorialClinico act = actividades.get(j);
                                String icon = "bi-clipboard2-pulse";
                                String bgClass = "bg-timeline-default"; 
                                
                                if("Vacuna".equalsIgnoreCase(act.getTipoEvento())) { 
                                    icon = "bi-shield-check"; 
                                    bgClass = "bg-timeline-vacuna"; 
                                } else if("Enfermedad".equalsIgnoreCase(act.getTipoEvento())) { 
                                    icon = "bi-heart-pulse"; 
                                    bgClass = "bg-timeline-enfermedad"; 
                                } else if("Parto".equalsIgnoreCase(act.getTipoEvento())) { 
                                    icon = "bi-stars"; 
                                    bgClass = "bg-timeline-parto"; 
                                }
                    %>
                    <li class="timeline-item">
                        <div class="timeline-icon <%= bgClass %>"><i class="<%= icon %>"></i></div>
                        <span class="timeline-time"><%= act.getFechaEvento() %> | Vet: <%= act.getNombreVeterinario() != null ? act.getNombreVeterinario() : "Sin asignar" %></span>
                        <div class="timeline-content"><strong class="text-dark">Bovino ID-<%= act.getIdBovino() %>:</strong> <%= act.getDescripcion() %></div>
                    </li>
                    <% 
                            }
                        } else { 
                    %>
                        <li class="text-muted small">No hay actividades recientes registradas en la base de datos.</li>
                    <% } %>
                </ul>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="dash-card">
                <div class="card-title mb-4">
                    <span><i class="bi bi-table text-success me-2"></i> Últimos Lotes de Fábrica</span>
                    <a href="lacteos" class="btn btn-sm btn-light border fw-bold"><i class="bi bi-eye"></i> Ver Todos</a>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-clean">
                        <thead>
                            <tr>
                                <th>Lote</th>
                                <th>Fecha Registro</th>
                                <th>Volumen Invertido</th>
                                <th>Cantidad Final</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                List<LoteProduccion> lotes = (List<LoteProduccion>) request.getAttribute("ultimosLotes");
                                if (lotes != null && !lotes.isEmpty()) {
                                    int limitLotes = Math.min(lotes.size(), 6); 
                                    for(int i = 0; i < limitLotes; i++) {
                                        LoteProduccion lote = lotes.get(i);
                                        String badgeClass = "text-warning bg-warning border-warning";
                                        if("Finalizado".equalsIgnoreCase(lote.getEstado())) badgeClass = "text-success bg-success border-success";
                                        else if("Cancelado".equalsIgnoreCase(lote.getEstado())) badgeClass = "text-danger bg-danger border-danger";
                            %>
                            <tr>
                                <td><strong class="text-dark">#LOT-<%= String.format("%03d", lote.getIdLote()) %></strong></td>
                                <td><%= lote.getFechaInicio() %></td>
                                <td><i class="bi bi-droplet-fill text-info me-1"></i> <%= lote.getLitrosLecheUsados() %> L</td>
                                <td><%= lote.getCantidad() %> Unidades</td>
                                <td><span class="badge badge-status <%= badgeClass %> bg-opacity-10 border"><%= lote.getEstado() %></span></td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                                <tr><td colspan="5" class="text-center text-muted py-4">No hay producción en fábrica actualmente.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {

    // =========================================================
    // LECTURA DE DATOS OCULTOS DEL SERVLET
    // =========================================================
    const rawLabels = document.getElementById('dashLabels').value;
    const labelsArr = rawLabels.split(',').map(s => s.replace(/'/g, '').trim());
    
    const rawDatos = document.getElementById('dashDatos').value;
    const datosArr = rawDatos.split(',').map(Number);
    
    const valProd = Number(document.getElementById('dashProd').value);
    const valCrias = Number(document.getElementById('dashCrias').value);
    const valToros = Number(document.getElementById('dashToros').value);

    // =========================================================
    // RENDERIZADO DE GRÁFICOS JAVASCRIPT
    // =========================================================
    const ctxLine = document.getElementById('lineChart').getContext('2d');
    let gradientGreen = ctxLine.createLinearGradient(0, 0, 0, 300);
    gradientGreen.addColorStop(0, 'rgba(28, 115, 69, 0.4)');
    gradientGreen.addColorStop(1, 'rgba(28, 115, 69, 0.0)');

    new Chart(ctxLine, {
        type: 'line',
        data: {
            labels: labelsArr, 
            datasets: [{
                label: 'Litros Diarios',
                data: datosArr, 
                borderColor: '#1C7345',
                backgroundColor: gradientGreen,
                borderWidth: 3,
                tension: 0.4, 
                fill: true,
                pointBackgroundColor: '#ffffff',
                pointBorderColor: '#1C7345',
                pointBorderWidth: 2,
                pointRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { borderDash: [5, 5], color: '#f1f1f1' }, border: { display: false } },
                x: { grid: { display: false }, border: { display: false } }
            }
        }
    });

    const ctxDoughnut = document.getElementById('doughnutChart').getContext('2d');
    new Chart(ctxDoughnut, {
        type: 'doughnut',
        data: {
            labels: ['Producción', 'Crías', 'Toros'],
            datasets: [{
                data: [valProd, valCrias, valToros], 
                backgroundColor: ['#1C7345', '#ffc107', '#fd7e14'],
                borderWidth: 0,
                hoverOffset: 5
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '75%', 
            plugins: { legend: { display: false } }
        }
    });

});
</script>

</body>
</html>