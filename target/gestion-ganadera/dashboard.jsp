<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.finca.models.Ordeno" %>
<%@ page import="com.finca.models.DetalleOrdeno" %>
<%@ page import="com.finca.models.Usuario" %>
<%@ page import="com.finca.models.Bovino" %>

<%
    SimpleDateFormat sdf = new SimpleDateFormat("dd 'de' MMMM 'de' yyyy, hh:mm a");
    String fechaActual = sdf.format(new Date());

    // =========================================================================
    // MOTOR DE ESTADÍSTICAS REALES PARA EL DASHBOARD
    // =========================================================================
    List<Ordeno> lista = (List<Ordeno>) request.getAttribute("historial");
    double stockLecheObj = request.getAttribute("stockLeche") != null ? ((Number) request.getAttribute("stockLeche")).doubleValue() : 0.0;
    
    int totalSesiones = lista != null ? lista.size() : 0;
    double sumaPromedios = 0;
    double maxProduccion = 0;
    double ultimaProduccion = 0;
    double ultimoPromedio = 0;
    int totalVacasHistorico = 0;
    
    if(lista != null && !lista.isEmpty()) {
        ultimaProduccion = lista.get(0).getTotalLitros();
        ultimoPromedio = lista.get(0).getPromedioLitros();
        
        for(Ordeno o : lista) {
            sumaPromedios += o.getPromedioLitros();
            totalVacasHistorico += o.getTotalVacas();
            if(o.getTotalLitros() > maxProduccion) {
                maxProduccion = o.getTotalLitros();
            }
        }
    }
    
    // Cálculos Finales Redondeados
    double promedioHistorico = totalSesiones > 0 ? (Math.round((sumaPromedios / totalSesiones) * 10.0) / 10.0) : 0.0;
    
    // BARRAS DE PROGRESO (Reglas de Negocio)
    double capacidadTanque = 1000.0; // Límite del tanque de la finca
    double porcentajeTanque = (stockLecheObj / capacidadTanque) * 100;
    if(porcentajeTanque > 100) porcentajeTanque = 100;
    
    double metaVaca = 15.0; // Meta ideal de la finca: 15 Litros por vaca
    double porcentajeRendimiento = (promedioHistorico / metaVaca) * 100;
    if(porcentajeRendimiento > 100) porcentajeRendimiento = 100;
    
    double porcentajeUltimo = maxProduccion > 0 ? (ultimaProduccion / maxProduccion) * 100 : 0;
%>
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
            /* Identidad Visual Finca La Rosa */
            --brand-main: #1C7345;
            --brand-hover: #165c37;
            --brand-accent: #00A859;
            --brand-light: #eaf6ee;
        }

        body { font-family: 'Nunito', sans-serif; background-color: #f4f7f6; color: #2b3445; }
        
        /* Dashboard Stats Cards */
        .card-stat { background: rgba(255, 255, 255, 0.95); border-radius: 24px; padding: 25px; border: 1px solid #e0e8e3; box-shadow: 0 15px 35px rgba(28,115,69,0.05); height: 100%; display: flex; flex-direction: column; justify-content: space-between; transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .card-stat:hover { transform: translateY(-5px); box-shadow: 0 20px 45px rgba(28,115,69,0.1); }
        
        .card-stock { background: linear-gradient(135deg, var(--brand-main), var(--brand-accent)); color: white; border-radius: 24px; box-shadow: 0 12px 30px rgba(28, 115, 69, 0.25); height: 100%; display: flex; flex-direction: column; justify-content: space-between; padding: 25px; position: relative; overflow: hidden; }
        .card-stock .watermark { position: absolute; right: -20px; bottom: -20px; font-size: 8rem; opacity: 0.1; transform: rotate(-15deg); pointer-events: none; }
        
        /* Modificación para progreso animado de Bootstrap */
        .progress { background-color: #e9ecef; border-radius: 50px; overflow: hidden; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1); }
        .progress-bar { font-weight: 700; font-size: 10px; line-height: 12px; }

        .table-container { background: rgba(255, 255, 255, 0.95); border: 1px solid rgba(255,255,255,0.6); border-radius: 24px; padding: 24px; box-shadow: 0 16px 40px rgba(0,0,0,0.04); }
        
        /* Clases Personalizadas */
        .text-brand { color: var(--brand-main) !important; }
        .bg-brand { background-color: var(--brand-main) !important; color: white !important; }
        .bg-brand-subtle { background-color: var(--brand-light) !important; border-color: #cde6d7 !important; color: var(--brand-main) !important; }
        
        /* Estilos Tarjetas Mini */
        .mini-stat-card { border-radius: 12px; padding: 20px; border: none; position: relative; overflow: hidden; }
        .mini-stat-card.green { background-color: #eaf6ee; border-left: 4px solid #1C7345; }
        .mini-stat-card.yellow { background-color: #fff3cd; border-left: 4px solid #ffc107; }
        .mini-stat-card.orange { background-color: #ffe5d0; border-left: 4px solid #fd7e14; }
        .mini-stat-card.purple { background-color: #f1ebff; border-left: 4px solid #6f42c1; }

        .mini-stat-title { font-size: 0.8rem; font-weight: 700; text-transform: uppercase; color: #666; margin-bottom: 5px; }
        .mini-stat-value { font-size: 1.8rem; font-weight: 800; color: #2b3445; margin-bottom: 0; }
        .mini-stat-trend { font-size: 0.85rem; font-weight: 700; }

        /* Timeline Actividades */
        .timeline { list-style: none; padding: 0; margin: 0; position: relative; }
        .timeline::before { content: ''; position: absolute; top: 0; bottom: 0; left: 15px; width: 2px; background: #e9ecef; }
        .timeline-item { position: relative; padding-left: 45px; margin-bottom: 25px; }
        .timeline-item:last-child { margin-bottom: 0; }
        .timeline-icon { position: absolute; left: 0; top: 0; width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 14px; z-index: 1; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .timeline-time { font-size: 0.75rem; color: #999; font-weight: 600; margin-bottom: 4px; display: block; }
        .timeline-content { font-size: 0.9rem; color: #444; font-weight: 600; }

        /* Tabla Limpia */
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
            <span class="text-muted" style="font-size: 0.9rem;">Resumen de producción del último mes</span>
        </div>
        <button class="btn btn-success fw-bold px-4 rounded-pill shadow-sm" style="background-color: #1C7345; border: none;">
            <i class="bi bi-file-earmark-arrow-down me-2"></i> Generar Reporte
        </button>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-lg-8">
            <div class="dash-card">
                <div class="card-title">
                    <span style="color: #1C7345;"><i class="bi bi-graph-up me-2"></i> Producción de Leche Mensual</span>
                    <select class="form-select form-select-sm w-auto border-0 bg-light fw-bold">
                        <option>Este Mes</option>
                        <option>Mes Pasado</option>
                    </select>
                </div>
                <div style="height: 300px;">
                    <canvas id="lineChart"></canvas>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="dash-card">
                <div class="card-title">
                    <span><i class="bi bi-pie-chart-fill text-warning me-2"></i> Distribución del Hato</span>
                </div>
                <div style="height: 250px; display: flex; justify-content: center; align-items: center;">
                    <canvas id="doughnutChart"></canvas>
                </div>
                <div class="mt-4 d-flex justify-content-around text-center border-top pt-3">
                    <div>
                        <h4 class="fw-bolder text-dark mb-0"><%= request.getAttribute("porcProduccion") != null ? request.getAttribute("porcProduccion") : "0" %>%</h4>
                        <span class="text-muted" style="font-size: 0.75rem;">Producción</span>
                    </div>
                    <div>
                        <h4 class="fw-bolder text-dark mb-0"><%= request.getAttribute("porcCrias") != null ? request.getAttribute("porcCrias") : "0" %>%</h4>
                        <span class="text-muted" style="font-size: 0.75rem;">Crías</span>
                    </div>
                    <div>
                        <h4 class="fw-bolder text-dark mb-0"><%= request.getAttribute("porcToros") != null ? request.getAttribute("porcToros") : "0" %>%</h4>
                        <span class="text-muted" style="font-size: 0.75rem;">Toros</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-lg-3 col-md-6">
            <div class="mini-stat-card green">
                <div class="mini-stat-title">Inventario Bovino</div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="mini-stat-value"><%= request.getAttribute("totalBovinos") != null ? request.getAttribute("totalBovinos") : "0" %> <span class="fs-6 fw-normal text-muted">cabezas</span></div>
                    <div class="mini-stat-trend" style="color: #1C7345;"><i class="bi bi-arrow-up"></i> Sistema Activo</div>
                </div>
            </div>
        </div>
        
        <div class="col-lg-3 col-md-6">
            <div class="mini-stat-card yellow">
                <div class="mini-stat-title">Tanque de Leche</div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="mini-stat-value"><%= request.getAttribute("stockLeche") != null ? request.getAttribute("stockLeche") : "0.0" %> <span class="fs-6 fw-normal text-muted">Litros</span></div>
                    <div class="mini-stat-trend text-warning"><i class="bi bi-droplet-fill"></i> Inventario</div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6">
            <div class="mini-stat-card orange">
                <div class="mini-stat-title">Atenciones Médicas</div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="mini-stat-value"><%= request.getAttribute("atencionesMedicas") != null ? request.getAttribute("atencionesMedicas") : "0" %> <span class="fs-6 fw-normal text-muted">casos</span></div>
                    <div class="mini-stat-trend text-danger"><i class="bi bi-exclamation-triangle"></i> En retiro</div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6">
            <div class="mini-stat-card purple">
                <div class="mini-stat-title">Lotes de Queso</div>
                <div class="d-flex justify-content-between align-items-end">
                    <div class="mini-stat-value"><%= request.getAttribute("lotesQueso") != null ? request.getAttribute("lotesQueso") : "0" %> <span class="fs-6 fw-normal text-muted">Unidades</span></div>
                    <div class="mini-stat-trend" style="color: #6f42c1;"><i class="bi bi-check2-circle"></i> Disponibles</div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-4">
            <div class="dash-card">
                <div class="card-title">
                    <span><i class="bi bi-activity text-danger me-2"></i> Actividades Recientes</span>
                </div>
                
                <ul class="timeline mt-4">
                    <li class="timeline-item">
                        <div class="timeline-icon" style="background-color: #1C7345;"><i class="bi bi-droplet"></i></div>
                        <span class="timeline-time">Hace 45 Minutos</span>
                        <div class="timeline-content">Sesión de ordeño matutino finalizada.</div>
                    </li>
                    <li class="timeline-item">
                        <div class="timeline-icon" style="background-color: #fd7e14;"><i class="bi bi-heart-pulse"></i></div>
                        <span class="timeline-time">Ayer, 08:30 AM</span>
                        <div class="timeline-content">Vaca entró en tratamiento por mastitis.</div>
                    </li>
                    <li class="timeline-item">
                        <div class="timeline-icon" style="background-color: #198754;"><i class="bi bi-stars"></i></div>
                        <span class="timeline-time">Ayer, 06:15 AM</span>
                        <div class="timeline-content">Nacimiento registrado. Cría sana.</div>
                    </li>
                    <li class="timeline-item">
                        <div class="timeline-icon" style="background-color: #6f42c1;"><i class="bi bi-box-seam"></i></div>
                        <span class="timeline-time">Hace 3 días</span>
                        <div class="timeline-content">Lote de Quesos Campesinos terminados.</div>
                    </li>
                </ul>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="dash-card">
                <div class="card-title mb-4">
                    <span><i class="bi bi-table text-success me-2"></i> Últimas Ventas y Movimientos</span>
                    <button class="btn btn-sm btn-light border fw-bold"><i class="bi bi-funnel"></i> Filtrar</button>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-clean">
                        <thead>
                            <tr>
                                <th>Factura</th>
                                <th>Cliente / Destino</th>
                                <th>Producto</th>
                                <th>Monto</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>#FV-1045</td>
                                <td>Lácteos del Valle S.A.</td>
                                <td>150L Leche Cruda</td>
                                <td>$ 375,000</td>
                                <td><span class="badge badge-status text-success bg-success bg-opacity-10 border border-success">Completado</span></td>
                            </tr>
                            <tr>
                                <td>#FV-1044</td>
                                <td>Consumidor Final</td>
                                <td>5x Queso Doble Crema</td>
                                <td>$ 80,000</td>
                                <td><span class="badge badge-status text-success bg-success bg-opacity-10 border border-success">Completado</span></td>
                            </tr>
                            <tr>
                                <td>#INT-089</td>
                                <td>Fábrica Finca La Rosa</td>
                                <td>50L a Quesería</td>
                                <td>Movimiento</td>
                                <td><span class="badge badge-status text-warning bg-warning bg-opacity-10 border border-warning">En Proceso</span></td>
                            </tr>
                            <tr>
                                <td>#FV-1043</td>
                                <td>Panadería Central</td>
                                <td>10x Queso Campesino</td>
                                <td>$ 120,000</td>
                                <td><span class="badge badge-status text-danger bg-danger bg-opacity-10 border border-danger">Pendiente</span></td>
                            </tr>
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
    // LECTURA DE DATOS OCULTOS (Limpia VS Code de errores rojos)
    // =========================================================
    
    // Extraemos el texto crudo y quitamos comillas para los Labels
    const rawLabels = document.getElementById('dashLabels').value;
    const labelsArr = rawLabels.split(',').map(s => s.replace(/'/g, '').trim());
    
    // Extraemos y convertimos a números los datos
    const rawDatos = document.getElementById('dashDatos').value;
    const datosArr = rawDatos.split(',').map(Number);
    
    // Extraemos los porcentajes del anillo circular
    const valProd = Number(document.getElementById('dashProd').value);
    const valCrias = Number(document.getElementById('dashCrias').value);
    const valToros = Number(document.getElementById('dashToros').value);

    // =========================================================
    // RENDERIZADO DE GRÁFICOS
    // =========================================================

    // 1. Gráfico de Líneas
    const ctxLine = document.getElementById('lineChart').getContext('2d');
    let gradientGreen = ctxLine.createLinearGradient(0, 0, 0, 300);
    gradientGreen.addColorStop(0, 'rgba(28, 115, 69, 0.4)');
    gradientGreen.addColorStop(1, 'rgba(28, 115, 69, 0.0)');

    new Chart(ctxLine, {
        type: 'line',
        data: {
            labels: labelsArr, // Usamos el Array de Javascript
            datasets: [{
                label: 'Litros Diarios',
                data: datosArr, // Usamos el Array de Javascript
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

    // 2. Gráfico Circular (Anillo)
    const ctxDoughnut = document.getElementById('doughnutChart').getContext('2d');
    new Chart(ctxDoughnut, {
        type: 'doughnut',
        data: {
            labels: ['Producción', 'Crías', 'Toros'],
            datasets: [{
                data: [valProd, valCrias, valToros], // Usamos las variables limpias
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