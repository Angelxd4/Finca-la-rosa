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
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            /* PALETA FINCA LA ROSA (DARK MOSS GREEN & EARTH TONES) */
            --bg-page: #F3F5E7 !important; /* IVORY */
            --bg-card: #FFFFFF !important;
            
            --brand-primary: #464704 !important; /* DARK MOSS GREEN */
            --brand-accent: #B7A78C !important; /* KHAKI */
            --brand-info: #9CA889 !important; /* SAGE */
            --brand-dark: #423926 !important; /* DRAB DARK BROWN */
            
            --text-main: #423926 !important;
            --text-subtle: #7A7463 !important;
            --border-subtle: #E2E4D5 !important;
        }

        body { font-family: 'Inter', sans-serif; background-color: var(--bg-page) !important; color: var(--text-main); }
        
        .dash-card { background: var(--bg-card); border-radius: 20px; border: 1px solid var(--border-subtle); box-shadow: 0 10px 15px -3px rgba(66, 57, 38, 0.05); padding: 24px; height: 100%; transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .dash-card:hover { transform: translateY(-3px); box-shadow: 0 15px 25px rgba(66, 57, 38, 0.1); border-color: var(--brand-accent); }
        
        .card-title { font-size: 0.95rem; font-weight: 800; color: var(--brand-dark); margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; text-transform: uppercase; letter-spacing: 0.5px;}

        /* MINICARDS SUPERIORES BLINDADAS A LA PALETA */
        .mini-stat-card { border-radius: 16px; padding: 20px; border: 1px solid var(--border-subtle); position: relative; overflow: hidden; background-color: var(--bg-card); }
        .mini-stat-card.green { border-left: 5px solid var(--brand-primary); }
        .mini-stat-card.yellow { border-left: 5px solid var(--brand-accent); }
        .mini-stat-card.purple { border-left: 5px solid var(--brand-info); }
        .mini-stat-card.red { border-left: 5px solid #dc3545; }

        .mini-stat-title { font-size: 0.8rem; font-weight: 800; text-transform: uppercase; color: var(--text-subtle); margin-bottom: 5px; }
        .mini-stat-value { font-size: 1.8rem; font-weight: 800; color: var(--brand-primary); margin-bottom: 0; }
        .mini-stat-trend { font-size: 0.85rem; font-weight: 700; color: var(--brand-info); }

        .timeline { list-style: none; padding: 0; margin: 0; position: relative; }
        .timeline::before { content: ''; position: absolute; top: 0; bottom: 0; left: 15px; width: 2px; background: var(--border-subtle); }
        .timeline-item { position: relative; padding-left: 45px; margin-bottom: 25px; }
        .timeline-item:last-child { margin-bottom: 0; }
        .timeline-icon { position: absolute; left: 0; top: 0; width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 14px; z-index: 1; box-shadow: 0 4px 10px rgba(66,57,38,0.1); }
        
        .bg-timeline-default { background-color: var(--brand-dark); } 
        .bg-timeline-vacuna { background-color: var(--brand-info); }   
        .bg-timeline-enfermedad { background-color: #dc3545; } 
        .bg-timeline-parto { background-color: var(--brand-primary); }    

        .timeline-time { font-size: 0.75rem; color: var(--text-subtle); font-weight: 700; margin-bottom: 4px; display: block; }
        .timeline-content { font-size: 0.9rem; color: var(--text-main); font-weight: 600; }

        .table-clean th { border-top: none; font-size: 0.75rem; text-transform: uppercase; color: var(--text-subtle); font-weight: 800; border-bottom: 2px solid var(--border-subtle); padding-bottom: 15px; }
        .table-clean td { font-size: 0.9rem; font-weight: 600; color: var(--text-main); vertical-align: middle; border-bottom: 1px solid var(--border-subtle); padding: 12px 5px; }
        
        /* BOTONES */
        .btn-brand { background-color: var(--brand-primary) !important; color: white !important; font-weight: 700; border-radius: 12px; border: 2px solid var(--brand-primary) !important; }
        .btn-brand:hover { background-color: var(--brand-dark) !important; border-color: var(--brand-dark) !important; transform: translateY(-1px); }
        .btn-outline-brand { color: var(--brand-primary) !important; border: 2px solid var(--brand-primary) !important; font-weight: 700; border-radius: 12px; background: transparent; }
        .btn-outline-brand:hover { background-color: var(--brand-primary) !important; color: white !important; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<% 
    // 🔒 LÓGICA DE DETECCIÓN DE ROL
    String rolUsuarioDash = (String) request.getAttribute("rolTexto"); 
    if (rolUsuarioDash == null) rolUsuarioDash = "";
    boolean esVeterinario = rolUsuarioDash.equalsIgnoreCase("Veterinario") || "2".equals(rolUsuarioDash);
    boolean esOperario = rolUsuarioDash.contains("Operario") || "3".equals(rolUsuarioDash);
%>

<input type="hidden" id="dashLabels" value="<%= request.getAttribute("labelsGrafico") != null ? request.getAttribute("labelsGrafico") : "L,M,M" %>">
<input type="hidden" id="dashDatos" value="<%= request.getAttribute("datosGrafico") != null ? request.getAttribute("datosGrafico") : "0,0,0" %>">
<input type="hidden" id="dashProd" value="<%= request.getAttribute("porcProduccion") != null ? request.getAttribute("porcProduccion") : "0" %>">
<input type="hidden" id="dashCrias" value="<%= request.getAttribute("porcCrias") != null ? request.getAttribute("porcCrias") : "0" %>">
<input type="hidden" id="dashToros" value="<%= request.getAttribute("porcToros") != null ? request.getAttribute("porcToros") : "0" %>">

<div class="container-fluid px-4 py-4">
    
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom" style="border-color: var(--border-subtle) !important;">
        <div>
            <h3 class="fw-bolder mb-0" style="color: var(--brand-dark);">Dashboard General</h3>
            <span style="font-size: 0.9rem; color: var(--text-subtle);">Analíticas en tiempo real de Finca La Rosa</span>
        </div>
        
        <% if (!esVeterinario) { %>
            <a href="produccion" class="btn btn-brand btn-ripple px-4 shadow-sm">
                <i class="bi bi-droplet-half me-2"></i> Ir a Ordeño
            </a>
        <% } else { %>
            <a href="inventario-ganado" class="btn btn-brand btn-ripple px-4 shadow-sm">
                <i class="bi bi-clipboard2-pulse me-2"></i> Ir a Fichas Clínicas
            </a>
        <% } %>
    </div>

    <% if (!esVeterinario) { %>
    <div class="row g-4 mb-4">
        <div class="col-lg-3 col-md-6">
            <div class="mini-stat-card green animate-fade-in-up delay-100">
                <div class="mini-stat-title">Producción de Hoy</div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="mini-stat-value"><%= request.getAttribute("produccionHoy") %> <span class="fs-6 fw-normal" style="color: var(--text-subtle);">L</span></div>
                    <div class="mini-stat-trend" style="color: var(--brand-primary);"><i class="bi bi-check-circle-fill"></i> Leche Apta</div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6">
            <div class="mini-stat-card red animate-fade-in-up delay-200">
                <div class="mini-stat-title">Descarte de Hoy</div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="mini-stat-value text-danger"><%= request.getAttribute("descarteHoy") %> <span class="fs-6 fw-normal text-danger opacity-50">L</span></div>
                    <div class="mini-stat-trend text-danger"><i class="bi bi-shield-x"></i> Aislada</div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6">
            <div class="mini-stat-card yellow animate-fade-in-up delay-300">
                <div class="mini-stat-title">Tanques Disponibles</div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="mini-stat-value"><%= request.getAttribute("stockLeche") %> <span class="fs-6 fw-normal" style="color: var(--text-subtle);">L</span></div>
                    <div class="mini-stat-trend" style="color: var(--brand-accent);"><i class="bi bi-moisture"></i> Total Físico</div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6">
            <div class="mini-stat-card purple animate-fade-in-up delay-400">
                <div class="mini-stat-title">Productos en Fábrica</div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="mini-stat-value"><%= request.getAttribute("lotesQueso") %> <span class="fs-6 fw-normal" style="color: var(--text-subtle);">Stock</span></div>
                    <div class="mini-stat-trend" style="color: var(--brand-info);"><i class="bi bi-basket-fill"></i> Catálogo</div>
                </div>
            </div>
        </div>
    </div>

    <% if (!esOperario) { %>
    <div class="row g-4 mb-4">
        <div class="col-lg-8">
            <div class="dash-card animate-fade-in-up delay-500">
                <div class="card-title">
                    <span><i class="bi bi-graph-up me-2" style="color: var(--brand-primary);"></i> Tendencia de Producción (Últimos 7 días activos)</span>
                </div>
                <div style="height: 300px;">
                    <canvas id="lineChart"></canvas>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="dash-card animate-fade-in-up delay-500">
                <div class="card-title">
                    <span><i class="bi bi-pie-chart-fill me-2" style="color: var(--brand-accent);"></i> Distribución del Hato (<%= request.getAttribute("totalBovinos") %> Cabezas)</span>
                </div>
                <div style="height: 250px; display: flex; justify-content: center; align-items: center;">
                    <canvas id="doughnutChart"></canvas>
                </div>
                <div class="mt-4 d-flex justify-content-around text-center border-top pt-3" style="border-color: var(--border-subtle) !important;">
                    <div>
                        <h4 class="fw-bolder mb-0" style="color: var(--brand-primary);"><%= request.getAttribute("porcProduccion") %>%</h4>
                        <span style="font-size: 0.75rem; color: var(--text-subtle); font-weight: 700;">Producción</span>
                    </div>
                    <div>
                        <h4 class="fw-bolder mb-0" style="color: var(--brand-accent);"><%= request.getAttribute("porcCrias") %>%</h4>
                        <span style="font-size: 0.75rem; color: var(--text-subtle); font-weight: 700;">Crías</span>
                    </div>
                    <div>
                        <h4 class="fw-bolder mb-0" style="color: var(--brand-info);"><%= request.getAttribute("porcToros") %>%</h4>
                        <span style="font-size: 0.75rem; color: var(--text-subtle); font-weight: 700;">Toros</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <% } else { %>
    <div class="row g-4 mb-4">
        <div class="col-lg-4 col-md-6">
            <div class="mini-stat-card green">
                <div class="mini-stat-title">Total del Hato</div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="mini-stat-value"><%= request.getAttribute("totalBovinos") %> <span class="fs-6 fw-normal" style="color: var(--text-subtle);">Cabezas</span></div>
                    <div class="mini-stat-trend" style="color: var(--brand-primary);"><i class="bi bi-check-circle-fill"></i> Activas</div>
                </div>
            </div>
        </div>

        <div class="col-lg-4 col-md-6">
            <div class="mini-stat-card yellow">
                <div class="mini-stat-title">Atenciones Médicas</div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="mini-stat-value text-warning"><%= request.getAttribute("atencionesMedicas") %> <span class="fs-6 fw-normal text-warning opacity-50">Bovinos</span></div>
                    <div class="mini-stat-trend text-warning"><i class="bi bi-heart-pulse"></i> Requieren Revisión</div>
                </div>
            </div>
        </div>

        <div class="col-lg-4 col-md-6">
            <div class="mini-stat-card purple">
                <div class="mini-stat-title">Eventos Clínicos Recientes</div>
                <div class="d-flex justify-content-between align-items-end">
                    <% 
                        List<HistorialClinico> statsEventos = (List<HistorialClinico>) request.getAttribute("actividadesRecientes");
                        int cantEventos = (statsEventos != null) ? statsEventos.size() : 0;
                    %>
                    <div class="mini-stat-value"><%= cantEventos %> <span class="fs-6 fw-normal" style="color: var(--text-subtle);">Registros</span></div>
                    <div class="mini-stat-trend" style="color: var(--brand-info);"><i class="bi bi-clipboard2-data"></i> Historial</div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-lg-12">
            <div class="dash-card">
                <div class="card-title">
                    <span><i class="bi bi-pie-chart-fill me-2" style="color: var(--brand-accent);"></i> Distribución Clínica del Hato (<%= request.getAttribute("totalBovinos") %> Cabezas)</span>
                </div>
                <div style="height: 300px; display: flex; justify-content: center; align-items: center;">
                    <canvas id="doughnutChartVet"></canvas>
                </div>
                <div class="mt-4 d-flex justify-content-around text-center border-top pt-3" style="border-color: var(--border-subtle) !important;">
                    <div>
                        <h4 class="fw-bolder mb-0" style="color: var(--brand-primary);"><%= request.getAttribute("porcProduccion") %>%</h4>
                        <span style="font-size: 0.75rem; color: var(--text-subtle); font-weight: 700;">Producción (Sanas)</span>
                    </div>
                    <div>
                        <h4 class="fw-bolder mb-0" style="color: var(--brand-accent);"><%= request.getAttribute("porcCrias") %>%</h4>
                        <span style="font-size: 0.75rem; color: var(--text-subtle); font-weight: 700;">Crías (Seguimiento)</span>
                    </div>
                    <div>
                        <h4 class="fw-bolder mb-0" style="color: var(--brand-info);"><%= request.getAttribute("porcToros") %>%</h4>
                        <span style="font-size: 0.75rem; color: var(--text-subtle); font-weight: 700;">Toros Sementales</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <div class="row g-4">
        
        <div class="<%= esVeterinario ? "col-lg-12" : "col-lg-4" %>">
            <div class="dash-card">
                <div class="card-title">
                    <span><i class="bi bi-activity text-danger me-2"></i> Actividades Clínicas Recientes</span>
                </div>
                
                <ul class="timeline mt-4">
                    <% 
                        List<HistorialClinico> actividades = (List<HistorialClinico>) request.getAttribute("actividadesRecientes");
                        if (actividades != null && !actividades.isEmpty()) {
                            // Al veterinario le mostramos más registros (8) porque tiene la pantalla completa para él
                            int lim = Math.min(actividades.size(), esVeterinario ? 8 : 4); 
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
                        <div class="timeline-content"><strong style="color: var(--brand-dark);">Arete <%= act.getNumeroAreteBovino() != null ? act.getNumeroAreteBovino() : act.getIdBovino() %>:</strong> <%= act.getDescripcion() %></div>
                    </li>
                    <% 
                            }
                        } else { 
                    %>
                        <li class="text-muted small fw-bold">No hay actividades recientes registradas en la base de datos.</li>
                    <% } %>
                </ul>
            </div>
        </div>

        <% if (!esVeterinario) { %>
        <div class="col-lg-8">
            <div class="dash-card">
                <div class="card-title mb-4">
                    <span><i class="bi bi-table me-2" style="color: var(--brand-info);"></i> Últimos Lotes de Fábrica</span>
                    <a href="lacteos" class="btn btn-sm btn-outline-brand"><i class="bi bi-eye"></i> Ver Todos</a>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-clean table-premium-hover">
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
                                        String badgeColor = "#B7A78C"; // KHAKI
                                        if("Finalizado".equalsIgnoreCase(lote.getEstado())) badgeColor = "#464704"; // MOSS GREEN
                                        else if("Cancelado".equalsIgnoreCase(lote.getEstado())) badgeColor = "#dc3545"; // RED
                            %>
                            <tr>
                                <td><strong style="color: var(--brand-dark);">#LOT-<%= String.format("%03d", lote.getIdLote()) %></strong></td>
                                <td><%= lote.getFechaInicio() %></td>
                                <td><i class="bi bi-droplet-fill me-1" style="color: var(--brand-info);"></i> <%= lote.getLitrosLecheUsados() %> L</td>
                                <td><%= lote.getCantidad() %> Unidades</td>
                                <td><span class="badge text-white" style="background-color: <%= badgeColor %>; padding: 6px 12px; border-radius: 6px;"><%= lote.getEstado() %></span></td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                                <tr><td colspan="5" class="text-center py-4" style="color: var(--text-subtle); font-weight: 700;">No hay producción en fábrica actualmente.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {

    const rawLabels = document.getElementById('dashLabels').value;
    const labelsArr = rawLabels.split(',').map(s => s.replace(/'/g, '').trim());
    
    const rawDatos = document.getElementById('dashDatos').value;
    const datosArr = rawDatos.split(',').map(Number);
    
    const valProd = Number(document.getElementById('dashProd').value);
    const valCrias = Number(document.getElementById('dashCrias').value);
    const valToros = Number(document.getElementById('dashToros').value);

    // =========================================================
    // LÓGICA JAVASCRIPT PROTEGIDA PARA EVITAR ERRORES EN CONSOLA
    // =========================================================
    
    // 1. Gráfico de Líneas (Solo se renderiza si el HTML existe)
    const canvasLine = document.getElementById('lineChart');
    if (canvasLine) {
        const ctxLine = canvasLine.getContext('2d');
        let gradientGreen = ctxLine.createLinearGradient(0, 0, 0, 300);
        gradientGreen.addColorStop(0, 'rgba(70, 71, 4, 0.4)');
        gradientGreen.addColorStop(1, 'rgba(70, 71, 4, 0.0)');
        
        new Chart(ctxLine, {
            type: 'line',
            data: {
                labels: labelsArr, 
                datasets: [{
                    label: 'Litros Diarios',
                    data: datosArr, 
                    borderColor: '#464704',
                    backgroundColor: gradientGreen,
                    borderWidth: 3,
                    tension: 0.4, 
                    fill: true,
                    pointBackgroundColor: '#ffffff',
                    pointBorderColor: '#464704',
                    pointBorderWidth: 2,
                    pointRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { borderDash: [5, 5], color: '#E2E4D5' }, border: { display: false } },
                    x: { grid: { display: false }, border: { display: false } }
                }
            }
        });
    }

    // 2. Gráfico Doughnut Original (Para Admin/Operario)
    const canvasDoughnut = document.getElementById('doughnutChart');
    if (canvasDoughnut) {
        const ctxDoughnut = canvasDoughnut.getContext('2d');
        new Chart(ctxDoughnut, {
            type: 'doughnut',
            data: {
                labels: ['Producción', 'Crías', 'Toros'],
                datasets: [{
                    data: [valProd, valCrias, valToros], 
                    backgroundColor: ['#464704', '#B7A78C', '#9CA889'],
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
    }

    // 3. Gráfico Doughnut Especial (Para Veterinario)
    const canvasDoughnutVet = document.getElementById('doughnutChartVet');
    if (canvasDoughnutVet) {
        const ctxDoughnutVet = canvasDoughnutVet.getContext('2d');
        new Chart(ctxDoughnutVet, {
            type: 'doughnut',
            data: {
                labels: ['Sanas', 'Crías (Seguimiento)', 'Toros'],
                datasets: [{
                    data: [valProd, valCrias, valToros], 
                    backgroundColor: ['#464704', '#B7A78C', '#9CA889'],
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
    }
});
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>