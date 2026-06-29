<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.Ordeno" %>
<%@ page import="com.finca.models.HistorialClinico" %>
<%@ page import="com.finca.models.LoteProduccion" %>

<jsp:include page="includes/header.jsp" />
<style>
    /* Estilos específicos del Dashboard (Timeline y Minicards) */
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
</style>
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
    
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4 pb-2 border-bottom" style="border-color: var(--border-subtle) !important;">
        <div>
            <h3 class="fw-bolder mb-0" style="color: var(--brand-dark);">Dashboard General</h3>
            <span style="font-size: 0.9rem; color: var(--text-subtle);">Analíticas en tiempo real de Finca La Rosa</span>
        </div>
        
        <% if (!esVeterinario) { %>
            <div class="d-flex gap-2">
                <a href="reporte-pdf" target="_blank" class="btn btn-outline-secondary px-3 shadow-sm d-flex align-items-center bg-white" style="border-color: var(--border-subtle);">
                    <i class="bi bi-file-earmark-pdf-fill text-danger me-2"></i> Reporte PDF
                </a>
                <a href="produccion" class="btn btn-brand btn-ripple px-4 shadow-sm">
                    <i class="bi bi-droplet-half me-2"></i> Ir a Ordeño
                </a>
            </div>
        <% } else { %>
            <div class="d-flex gap-2">
                <a href="reporte-pdf" target="_blank" class="btn btn-outline-secondary px-3 shadow-sm d-flex align-items-center bg-white" style="border-color: var(--border-subtle);">
                    <i class="bi bi-file-earmark-pdf-fill text-danger me-2"></i> Reporte PDF
                </a>
                <a href="inventario-ganado" class="btn btn-brand btn-ripple px-4 shadow-sm">
                    <i class="bi bi-clipboard2-pulse me-2"></i> Ir a Fichas Clínicas
                </a>
            </div>
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

    <!-- WIDGET CLIMÁTICO (SANTA ROSA DE VITERBO) -->
    <div class="row g-4 mb-4">
        <div class="col-12">
            <div class="dash-card animate-fade-in-up" style="background: linear-gradient(135deg, #1e3a4a, var(--moss)); color: white; display: flex; flex-direction: column; flex-md-row; align-items: center; justify-content: space-between; gap: 20px; text-align: center; padding: 25px 35px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.15);">
                <div class="d-flex flex-column flex-md-row align-items-center gap-3 gap-md-4">
                    <i id="weatherIcon" class="bi bi-cloud-sun" style="font-size: 3.5rem; filter: drop-shadow(0 4px 6px rgba(0,0,0,0.2));"></i>
                    <div class="text-md-start">
                        <h4 class="mb-1 fw-bold" style="color: white; letter-spacing: 0.5px;">Santa Rosa de Viterbo, Boyacá</h4>
                        <span id="weatherDesc" style="font-size: 1rem; opacity: 0.9;">Sincronizando satélite...</span>
                    </div>
                </div>
                <div class="text-center text-md-end mt-3 mt-md-0">
                    <h2 id="weatherTemp" class="mb-0 fw-bolder" style="font-size: 3rem; color: white; line-height: 1;">--°C</h2>
                    <span id="weatherHint" style="font-size: 0.85rem; opacity: 0.8; font-weight: 600;"><i class="bi bi-clock-history me-1"></i> Tiempo Real</span>
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
                <div style="min-height: 300px; width: 100%;">
                    <div id="lineChart"></div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="dash-card animate-fade-in-up delay-500">
                <div class="card-title">
                    <span><i class="bi bi-pie-chart-fill me-2" style="color: var(--brand-accent);"></i> Distribución del Hato (<%= request.getAttribute("totalBovinos") %> Cabezas)</span>
                </div>
                <div style="height: 250px; display: flex; justify-content: center; align-items: center; width: 100%;">
                    <div id="doughnutChart" style="width: 100%; height: 100%;"></div>
                </div>
                <div class="mt-4 d-flex flex-wrap justify-content-center justify-content-md-around text-center border-top pt-3 gap-3" style="border-color: var(--border-subtle) !important;">
                    <div class="px-2">
                        <h4 class="fw-bolder mb-0" style="color: var(--brand-primary);"><%= request.getAttribute("porcProduccion") %>%</h4>
                        <span style="font-size: 0.75rem; color: var(--text-subtle); font-weight: 700;">Producción</span>
                    </div>
                    <div class="px-2">
                        <h4 class="fw-bolder mb-0" style="color: var(--brand-accent);"><%= request.getAttribute("porcCrias") %>%</h4>
                        <span style="font-size: 0.75rem; color: var(--text-subtle); font-weight: 700;">Crías</span>
                    </div>
                    <div class="px-2">
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
                <div style="height: 300px; display: flex; justify-content: center; align-items: center; width: 100%;">
                    <div id="doughnutChartVet" style="width: 100%; height: 100%;"></div>
                </div>
                <div class="mt-4 d-flex flex-wrap justify-content-center justify-content-md-around text-center border-top pt-3 gap-3" style="border-color: var(--border-subtle) !important;">
                    <div class="px-2">
                        <h4 class="fw-bolder mb-0" style="color: var(--brand-primary);"><%= request.getAttribute("porcProduccion") %>%</h4>
                        <span style="font-size: 0.75rem; color: var(--text-subtle); font-weight: 700;">Producción (Sanas)</span>
                    </div>
                    <div class="px-2">
                        <h4 class="fw-bolder mb-0" style="color: var(--brand-accent);"><%= request.getAttribute("porcCrias") %>%</h4>
                        <span style="font-size: 0.75rem; color: var(--text-subtle); font-weight: 700;">Crías (Seguimiento)</span>
                    </div>
                    <div class="px-2">
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
                <div class="card-title mb-4 d-flex flex-wrap align-items-center justify-content-between gap-2">
                    <span><i class="bi bi-table me-2" style="color: var(--brand-info);"></i> Últimos Lotes de Fábrica</span>
                    <a href="lacteos" class="btn btn-sm btn-outline-brand mt-2 mt-sm-0"><i class="bi bi-eye"></i> Ver Todos</a>
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
    
    // 1. Gráfico de Líneas ApexCharts (Solo se renderiza si el HTML existe)
    if (document.getElementById('lineChart')) {
        var optionsLine = {
            series: [{
                name: 'Producción Diaria (L)',
                data: datosArr
            }],
            chart: {
                type: 'area',
                height: 300,
                toolbar: { show: false },
                fontFamily: 'Inter, sans-serif',
                animations: {
                    enabled: true,
                    easing: 'easeinout',
                    speed: 800,
                    animateGradually: { enabled: true, delay: 150 },
                    dynamicAnimation: { enabled: true, speed: 350 }
                }
            },
            colors: ['#464704'],
            fill: {
                type: 'gradient',
                gradient: {
                    shadeIntensity: 1,
                    opacityFrom: 0.45,
                    opacityTo: 0.05,
                    stops: [0, 100]
                }
            },
            dataLabels: { enabled: false },
            stroke: { curve: 'smooth', width: 3 },
            xaxis: {
                categories: labelsArr,
                axisBorder: { show: false },
                axisTicks: { show: false },
                labels: { style: { colors: '#7A7463', fontWeight: 600 } }
            },
            yaxis: {
                labels: { style: { colors: '#7A7463', fontWeight: 600 } }
            },
            grid: {
                borderColor: '#E2E4D5',
                strokeDashArray: 5,
                xaxis: { lines: { show: false } },
                yaxis: { lines: { show: true } }
            },
            tooltip: { theme: 'dark' }
        };
        var chartLine = new ApexCharts(document.querySelector("#lineChart"), optionsLine);
        chartLine.render();
    }

    // Opciones base para Gráficos Donut
    var donutBaseOptions = {
        chart: {
            type: 'donut',
            height: '100%',
            fontFamily: 'Inter, sans-serif',
            animations: {
                enabled: true,
                easing: 'easeinout',
                speed: 800,
                dynamicAnimation: { enabled: true, speed: 350 }
            }
        },
        colors: ['#464704', '#B7A78C', '#9CA889'],
        dataLabels: { enabled: false },
        plotOptions: {
            pie: {
                donut: {
                    size: '75%',
                    labels: {
                        show: true,
                        name: { show: false },
                        value: {
                            show: true,
                            fontSize: '28px',
                            fontWeight: 800,
                            color: '#464704',
                            formatter: function (val) { return val + "%" }
                        },
                        total: {
                            show: true,
                            showAlways: false,
                            label: 'Total',
                            fontSize: '14px',
                            fontWeight: 700,
                            color: '#7A7463'
                        }
                    }
                },
                expandOnClick: true
            }
        },
        stroke: { show: false },
        legend: { show: false },
        tooltip: { theme: 'dark' }
    };

    // 2. Gráfico Doughnut Original (Para Admin/Operario)
    if (document.getElementById('doughnutChart')) {
        var optionsDoughnut = Object.assign({}, donutBaseOptions, {
            series: [valProd, valCrias, valToros],
            labels: ['Producción', 'Crías', 'Toros']
        });
        var chartDoughnut = new ApexCharts(document.querySelector("#doughnutChart"), optionsDoughnut);
        chartDoughnut.render();
    }

    // 3. Gráfico Doughnut Especial (Para Veterinario)
    if (document.getElementById('doughnutChartVet')) {
        var optionsDoughnutVet = Object.assign({}, donutBaseOptions, {
            series: [valProd, valCrias, valToros],
            labels: ['Sanas', 'Crías (Seguimiento)', 'Toros']
        });
        var chartDoughnutVet = new ApexCharts(document.querySelector("#doughnutChartVet"), optionsDoughnutVet);
        chartDoughnutVet.render();
    }
});

    // LÓGICA DEL CLIMA (Open-Meteo API)
    document.addEventListener("DOMContentLoaded", function() {
        const lat = 5.875;
        const lon = -72.981;
        const url = `https://api.open-meteo.com/v1/forecast?latitude=\${lat}&longitude=\${lon}&current_weather=true&timezone=auto`;

        fetch(url)
            .then(response => response.json())
            .then(data => {
                if(data && data.current_weather) {
                    const temp = data.current_weather.temperature;
                    const code = data.current_weather.weathercode;
                    
                    document.getElementById('weatherTemp').innerText = temp + '°C';
                    
                    let desc = "Despejado";
                    let icon = "bi-sun-fill";
                    let hint = "Día ideal para labores en potreros.";
                    
                    if (code === 0) { desc = "Despejado"; icon = "bi-sun-fill text-warning"; }
                    else if (code >= 1 && code <= 3) { desc = "Nublado / Parcialmente Nublado"; icon = "bi-cloud-sun-fill text-light"; }
                    else if (code >= 45 && code <= 48) { desc = "Niebla / Neblina"; icon = "bi-cloud-haze-fill text-secondary"; hint = "Precaución: Visibilidad reducida."; }
                    else if (code >= 51 && code <= 67) { desc = "Llovizna / Lluvia Ligera"; icon = "bi-cloud-drizzle-fill text-info"; hint = "Humedad alta. Vigilar pastos."; }
                    else if (code >= 71 && code <= 77) { desc = "Nieve / Granizo"; icon = "bi-cloud-snow-fill text-white"; hint = "¡Alerta Frío! Proteger terneros."; }
                    else if (code >= 80 && code <= 82) { desc = "Lluvia Fuerte / Aguaceros"; icon = "bi-cloud-rain-heavy-fill text-primary"; hint = "No recomendado aplicar vacunas o abonos hoy."; }
                    else if (code >= 95 && code <= 99) { desc = "Tormenta Eléctrica"; icon = "bi-cloud-lightning-rain-fill text-warning"; hint = "¡Peligro Eléctrico! Resguardar al personal y ganado."; }
                    
                    document.getElementById('weatherDesc').innerText = desc;
                    document.getElementById('weatherIcon').className = "bi " + icon;
                    document.getElementById('weatherHint').innerHTML = `<i class="bi bi-info-circle-fill me-1"></i> \${hint}`;
                }
            })
            .catch(error => {
                console.error("Error obteniendo el clima:", error);
                document.getElementById('weatherDesc').innerText = "Error de conexión meteorológica";
                document.getElementById('weatherHint').innerText = "Vuelve a intentar más tarde";
            });
    });
</script>
<jsp:include page="includes/footer.jsp" />