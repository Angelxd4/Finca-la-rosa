<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="com.finca.models.Ordeno" %>
<%@ page import="com.finca.models.DetalleOrdeno" %>
<%@ page import="com.finca.models.Usuario" %>
<%@ page import="com.finca.models.Bovino" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("dd 'de' MMMM 'de' yyyy, hh:mm a");
    String fechaActual = sdf.format(new Date());

    List<Ordeno> lista = (List<Ordeno>) request.getAttribute("historial");
    double stockFabrica = request.getAttribute("stockFabrica") != null ? ((Number) request.getAttribute("stockFabrica")).doubleValue() : 0.0;
    double stockVenta = request.getAttribute("stockVenta") != null ? ((Number) request.getAttribute("stockVenta")).doubleValue() : 0.0;
    
    double[] stats = (double[]) request.getAttribute("stats");
    if(stats == null) stats = new double[7];
    
    double totalManana = stats[0];
    double totalTarde = stats[1];
    double totalDescarte = stats[2]; // Descarte que sigue en el tanque
    double pendManana = stats[3];
    double pendTarde = stats[4];
    
    double totalDia = totalManana + totalTarde;
    String filtroActivo = (String) request.getAttribute("filtroActivo");

    Calendar cal = Calendar.getInstance();
    int currentHour = cal.get(Calendar.HOUR_OF_DAY);
    boolean isMorning = currentHour < 12;
    String turnoActualStr = isMorning ? "Mañana" : "Tarde";

    Set<Integer> vacasOrdenadasEsteTurno = new HashSet<>();
    if (lista != null) {
        for (Ordeno o : lista) {
            Calendar oCal = Calendar.getInstance();
            oCal.setTime(o.getFechaHora());
            boolean sameDay = oCal.get(Calendar.YEAR) == cal.get(Calendar.YEAR) && oCal.get(Calendar.DAY_OF_YEAR) == cal.get(Calendar.DAY_OF_YEAR);
            if (sameDay) {
                boolean oIsMorning = oCal.get(Calendar.HOUR_OF_DAY) < 12;
                if (isMorning == oIsMorning) {
                    for (DetalleOrdeno d : o.getDetalles()) {
                        vacasOrdenadasEsteTurno.add(d.getIdBovino());
                    }
                }
            }
        }
    }
    
    StringBuilder sbVacas = new StringBuilder();
    for(Integer vid : vacasOrdenadasEsteTurno) { sbVacas.append(vid).append(","); }
    String jsArrayVacas = sbVacas.length() > 0 ? sbVacas.substring(0, sbVacas.length() - 1) : "";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Producción | Finca</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            --brand-main: #1C7345;
            --brand-hover: #165c37;
            --brand-accent: #00A859;
            --brand-light: #eaf6ee;
        }

        body { font-family: 'Inter', sans-serif; background-color: #f3f7f4; }
        
        .card-stat { background: rgba(255, 255, 255, 0.95); border-radius: 24px; padding: 25px; border: 1px solid #e0e8e3; box-shadow: 0 15px 35px rgba(28,115,69,0.05); height: 100%; display: flex; flex-direction: column; justify-content: space-between; transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .card-stat:hover { transform: translateY(-5px); box-shadow: 0 20px 45px rgba(28,115,69,0.1); }
        
        .card-stock { background: linear-gradient(135deg, var(--brand-main), var(--brand-accent)); color: white; border-radius: 24px; box-shadow: 0 12px 30px rgba(28, 115, 69, 0.25); height: 100%; display: flex; flex-direction: column; justify-content: space-between; padding: 25px; position: relative; overflow: hidden; }
        .card-stock .watermark { position: absolute; right: -20px; bottom: -20px; font-size: 8rem; opacity: 0.1; transform: rotate(-15deg); pointer-events: none; }
        
        .progress { background-color: #e9ecef; border-radius: 50px; overflow: hidden; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1); }
        .progress-bar { font-weight: 700; font-size: 10px; line-height: 12px; transition: width 1s ease-in-out; }

        .table-container { background: rgba(255, 255, 255, 0.95); border: 1px solid rgba(255,255,255,0.6); border-radius: 24px; padding: 24px; box-shadow: 0 16px 40px rgba(0,0,0,0.04); }
        .cow-mini-pic { width: 45px; height: 45px; object-fit: cover; border-radius: 12px; }
        
        .text-brand { color: var(--brand-main) !important; }
        .bg-brand { background-color: var(--brand-main) !important; color: white !important; }
        .bg-brand-subtle { background-color: var(--brand-light) !important; border-color: #cde6d7 !important; color: var(--brand-main) !important; }
        
        .btn-brand { background-color: var(--brand-main); color: white; border: none; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; transition: all 0.3s ease; }
        .btn-brand:hover { background-color: var(--brand-hover); color: white; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(28, 115, 69, 0.25); }
        
        .btn-outline-brand { color: var(--brand-main); border: 2px solid var(--brand-main); font-weight: 600; background: transparent; transition: all 0.3s ease; }
        .btn-outline-brand:hover, .btn-outline-brand.active { background-color: var(--brand-main); color: white; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(28, 115, 69, 0.2); }

        .form-control, .form-select { border-radius: 14px; background: rgba(255,255,255,0.7); border: 1px solid #dce3df; color: #1d1d1f; transition: all 0.3s ease;}
        .form-control:focus, .form-select:focus { background: #ffffff; border-color: var(--brand-main); box-shadow: 0 0 0 4px rgba(28, 115, 69, 0.15); outline: none; }
        
        .modal-content { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(40px) saturate(200%); border-radius: 28px; border: 1px solid rgba(255,255,255,0.8); box-shadow: 0 25px 50px rgba(0,0,0,0.15); }
        .summary-bar { position: sticky; bottom: 0; background: rgba(255,255,255,0.9); backdrop-filter: blur(10px); border-top: 1px solid #eee; z-index: 10; padding: 20px;}
        
        tr.vaca-row { animation: fadeIn 0.4s ease forwards; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

        div:where(.swal2-container) div:where(.swal2-popup) { border-radius: 24px; font-family: 'Inter', sans-serif; box-shadow: 0 25px 50px rgba(0,0,0,0.15); }
        div:where(.swal2-container) button:where(.swal2-styled) { border-radius: 14px; font-weight: 600; padding: 10px 24px; }
        
        /* CORRECCIÓN LINTER CSS: Se agregó "appearance: none;" */
        .slider-dist { -webkit-appearance: none; appearance: none; width: 100%; height: 12px; border-radius: 6px; background: #dce3df; outline: none; transition: 0.2s; }
        .slider-dist::-webkit-slider-thumb { -webkit-appearance: none; appearance: none; width: 30px; height: 30px; border-radius: 50%; background: var(--brand-main); cursor: pointer; border: 4px solid white; box-shadow: 0 3px 6px rgba(0,0,0,0.3); }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />
<input type="hidden" id="appContextPath" value="<%= request.getContextPath() %>">

<input type="hidden" id="jsPendManana" value="<%= pendManana %>">
<input type="hidden" id="jsPendTarde" value="<%= pendTarde %>">

<% if(request.getAttribute("successMessage") != null) { %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            Swal.fire({ icon: 'success', title: '¡Operación Exitosa!', text: '<%= request.getAttribute("successMessage") %>', confirmButtonColor: '#1C7345', timer: 4000 });
        });
    </script>
<% } %>

<% if(request.getAttribute("errorMessage") != null) { %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            Swal.fire({ icon: 'error', title: 'Error', text: '<%= request.getAttribute("errorMessage") %>', confirmButtonColor: '#dc3545' });
        });
    </script>
<% } %>

<div class="container py-4">
    
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom flex-wrap gap-3">
        <div>
            <h3 class="fw-bolder text-dark mb-0">Módulo de Ordeño</h3>
            <span class="text-muted" style="font-size: 0.9rem;">Registro y distribución de leche comercial</span>
        </div>
        
        <form action="produccion" method="GET" class="d-flex align-items-center gap-2 m-0">
            <div class="input-group shadow-sm" style="border-radius: 14px; overflow: hidden;">
                <span class="input-group-text bg-white border-0"><i class="bi bi-calendar3 text-brand"></i></span>
                <select name="f" class="form-select border-0 fw-bold" onchange="this.form.submit()" style="min-width: 160px;">
                    <option value="dia" <%= "dia".equals(filtroActivo) ? "selected" : "" %>>Hoy</option>
                    <option value="ayer" <%= "ayer".equals(filtroActivo) ? "selected" : "" %>>Ayer</option>
                    <option value="semana" <%= "semana".equals(filtroActivo) ? "selected" : "" %>>Esta Semana</option>
                    <option value="mes" <%= "mes".equals(filtroActivo) ? "selected" : "" %>>Este Mes</option>
                    <option value="todo" <%= "todo".equals(filtroActivo) ? "selected" : "" %>>Todo el Historial</option>
                </select>
            </div>
            <button type="button" class="btn btn-brand rounded-pill px-4 ms-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalSesion">
                <i class="bi bi-plus-lg me-1"></i> Ordeñar
            </button>
        </form>
    </div>

    <div class="row g-4 mb-4 align-items-stretch">
        
        <div class="col-lg-4 col-md-6">
            <div class="card-stat">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="fw-bold text-muted mb-0 text-uppercase" style="letter-spacing: 1px;">
                        <i class="bi bi-droplet-half text-brand me-2"></i> Producción Apta
                    </h6>
                </div>
                <h2 class="fw-bolder text-dark mb-3"><%= totalDia %> <span class="fs-6 fw-normal text-muted">L Comerciales</span></h2>
                <div class="d-flex justify-content-between pt-2 border-top">
                    <small class="fw-bold text-muted"><i class="bi bi-sunrise-fill text-warning me-1"></i> Mañana: <%= totalManana %> L</small>
                    <small class="fw-bold text-muted"><i class="bi bi-sunset-fill text-info me-1"></i> Tarde: <%= totalTarde %> L</small>
                </div>
            </div>
        </div>

        <div class="col-lg-4 col-md-6">
            <div class="card-stat position-relative" style="background: #fff5f5; border-color: #ffe3e3;">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="fw-bold text-danger mb-0 text-uppercase" style="letter-spacing: 1px;">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> Tanque de Descarte
                    </h6>
                </div>
                <h2 class="fw-bolder text-danger mb-2"><%= totalDescarte %> <span class="fs-6 fw-normal text-danger opacity-75">L Contaminados</span></h2>
                
                <form action="produccion" method="POST" class="mt-auto">
                    <input type="hidden" name="action" value="vaciar_descarte">
                    <input type="hidden" name="filtroActual" value="<%= filtroActivo %>">
                    <button type="button" class="btn btn-outline-danger btn-sm rounded-pill w-100 fw-bold shadow-sm" onclick="confirmarVaciado(this.form)" <%= totalDescarte <= 0 ? "disabled" : "" %>>
                        <i class="bi bi-trash3-fill me-1"></i> Vaciar y Lavar Tanque
                    </button>
                </form>
            </div>
        </div>

        <div class="col-lg-4 col-md-12">
            <div class="card-stock">
                <i class="bi bi-moisture watermark"></i>
                <div>
                    <h6 class="fw-bold mb-3 opacity-75 text-uppercase" style="letter-spacing: 1px;">Disponibilidad Física Comercial</h6>
                    <div class="d-flex justify-content-between align-items-end mb-2 position-relative z-1">
                        <div>
                            <small class="d-block fw-bold opacity-75">Tanque Fábrica</small>
                            <h3 class="fw-bolder mb-0"><%= stockFabrica %> <small class="fs-6 fw-medium">L</small></h3>
                        </div>
                        <div class="text-end">
                            <small class="d-block fw-bold opacity-75">Tanque Venta</small>
                            <h3 class="fw-bolder mb-0"><%= stockVenta %> <small class="fs-6 fw-medium">L</small></h3>
                        </div>
                    </div>
                    <div class="progress bg-white bg-opacity-25 mt-3 position-relative z-1" style="height: 6px;">
                        <div class="progress-bar bg-white w-100"></div>
                    </div>
                    <small class="d-block text-center mt-2 fw-bold opacity-75">Los tanques aptos se vacían cada 24H</small>
                </div>
            </div>
        </div>
    </div>

    <div class="table-container mb-5 border-start border-5 border-brand">
        <h5 class="fw-bolder text-dark mb-4"><i class="bi bi-sliders text-brand me-2"></i> Asignar Leche a los Tanques</h5>
        
        <form action="produccion" method="POST">
            <input type="hidden" name="action" value="asignar">
            <input type="hidden" name="filtroActual" value="<%= filtroActivo %>">
            <input type="hidden" name="porcFabrica" id="inputHiddenPorcFabrica" value="50">
            
            <div class="row g-4 align-items-center">
                <div class="col-md-3">
                    <label class="form-label fw-bold text-muted small text-uppercase">1. Seleccionar Turno</label>
                    <select name="turno" id="selectTurno" class="form-select fw-bold border-brand" onchange="updateDistribucionUI()">
                        <option value="total">Día Completo (<%= (pendManana + pendTarde) %> L)</option>
                        <option value="manana">Solo Mañana (<%= pendManana %> L)</option>
                        <option value="tarde">Solo Tarde (<%= pendTarde %> L)</option>
                    </select>
                </div>

                <div class="col-md-6 px-md-4">
                    <label class="form-label fw-bold text-muted small text-uppercase w-100 text-center">2. Ajustar Porcentajes (<span id="lblPendientesTotal" class="text-danger"><%= (pendManana + pendTarde) %></span> L por asignar)</label>
                    
                    <div class="d-flex align-items-center gap-3 mt-2">
                        <div class="text-center p-2 rounded bg-brand-subtle text-brand fw-bold shadow-sm border border-success border-opacity-25" style="width: 130px;">
                            <i class="bi bi-funnel-fill d-block fs-4 mb-1"></i>
                            <span style="font-size: 10px; letter-spacing: 1px;">PARA FÁBRICA</span><br>
                            <span id="lblPorcFabrica" class="fs-5"><%= (pendManana + pendTarde) > 0 ? "50" : "0" %>%</span>
                        </div>
                        
                        <input type="range" class="slider-dist flex-grow-1" id="sliderDistribucion" min="0" max="100" value="50" oninput="updateDistribucionUI()" <%= (pendManana + pendTarde) <= 0 ? "disabled" : "" %>>
                        
                        <div class="text-center p-2 rounded bg-info bg-opacity-10 text-info fw-bold shadow-sm border border-info border-opacity-25" style="width: 130px;">
                            <i class="bi bi-shop d-block fs-4 mb-1"></i>
                            <span style="font-size: 10px; letter-spacing: 1px;">PARA VENTA</span><br>
                            <span id="lblPorcVenta" class="fs-5"><%= (pendManana + pendTarde) > 0 ? "50" : "0" %>%</span>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between mt-2 px-4 fw-bolder fs-5 text-dark">
                        <span id="lblLitrosFabrica">0.0 L</span>
                        <span id="lblLitrosVenta">0.0 L</span>
                    </div>
                </div>

                <div class="col-md-3 text-center">
                    <label class="form-label fw-bold text-muted small text-uppercase d-block mb-3">3. Confirmar</label>
                    <button type="submit" id="btnDistribuir" class="btn btn-brand w-100 rounded-pill py-2 shadow-sm" <%= (pendManana + pendTarde) <= 0 ? "disabled" : "" %>>
                        <i class="bi bi-check2-all me-1"></i> Guardar Destino
                    </button>
                </div>
            </div>
        </form>
    </div>

    <h4 class="fw-bold text-dark mb-3"><i class="bi bi-card-checklist text-brand me-2"></i> Detalle de Sesiones (<%= filtroActivo.replace("_", " ").toUpperCase() %>)</h4>
    <div class="table-container table-responsive">
        <table class="table table-hover align-middle">
            <thead class="text-secondary text-uppercase" style="font-size: 0.75rem;">
                <tr>
                    <th>Fecha y Lugar</th>
                    <th>Volumen Recolectado</th>
                    <th>Estado / Destino</th>
                    <th>Responsable</th>
                    <th>Reporte Clínico</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    if(lista != null && !lista.isEmpty()) {
                        for(Ordeno o : lista) {
                            boolean descarteFueVaciado = o.getObservaciones().contains("[VACIADO]");
                            String obsLimpia = o.getObservaciones().replace("[VACIADO]", "");
                %>
                <tr>
                    <td>
                        <strong class="d-block text-dark mb-1"><i class="bi bi-calendar3 text-brand me-2"></i><%= o.getFechaHora() %></strong>
                        <small class="text-muted fw-medium"><i class="bi bi-geo-alt-fill text-danger me-1"></i> <%= o.getLugar() %></small>
                    </td>
                    <td>
                        <div class="d-flex flex-wrap gap-2">
                            <span class="badge bg-brand-subtle px-3 py-2 rounded-pill fs-6 shadow-sm border" title="Leche Apta">
                                <i class="bi bi-droplet-fill me-1"></i> <%= o.getTotalLitros() %> L Apta
                            </span>
                            <% if(o.getTotalDescarte() > 0) { %>
                                <span class="badge <%= descarteFueVaciado ? "bg-secondary" : "bg-danger" %> px-3 py-2 rounded-pill shadow-sm" title="Leche de Descarte">
                                    <i class="bi bi-exclamation-triangle-fill"></i> <%= o.getTotalDescarte() %> L <%= descarteFueVaciado ? "(Botada)" : "Mala" %>
                                </span>
                            <% } %>
                        </div>
                        <div class="mt-2 text-muted small fw-bold">
                            <i class="bi bi-bucket-fill"></i> <%= o.getTotalVacas() %> Vacas | Promedio: <%= o.getPromedioLitros() %> L
                        </div>
                    </td>
                    <td>
                        <% if(!o.isAsignado()) { %>
                            <span class="badge bg-warning text-dark px-3 py-2 rounded-pill"><i class="bi bi-hourglass-split"></i> Sin asignar</span>
                        <% } else { %>
                            <span class="badge bg-success px-3 py-2 rounded-pill shadow-sm"><i class="bi bi-check2-circle"></i> Distribuido</span>
                            <div class="mt-1 small text-muted fw-bold">
                                Fábrica: <%= o.getLitrosFabrica() %>L | Venta: <%= o.getLitrosVenta() %>L
                            </div>
                        <% } %>
                    </td>
                    <td>
                        <div class="d-flex align-items-center gap-2">
                            <div class="bg-light rounded-circle d-flex justify-content-center align-items-center text-secondary border" style="width: 35px; height: 35px;">
                                <i class="bi bi-person-fill"></i>
                            </div>
                            <span class="fw-semibold text-dark"><%= o.getNombreSupervisor() %></span>
                        </div>
                    </td>
                    <td>
                        <button class="btn btn-outline-brand btn-sm rounded-pill px-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalSesionDetalle_<%= o.getIdOrdeno() %>">
                            <i class="bi bi-file-earmark-text-fill me-1"></i> Ver Informe
                        </button>
                    </td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr><td colspan="5" class="text-center py-5 text-muted"><i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>No hay registros para el periodo seleccionado.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<% 
    if(lista != null && !lista.isEmpty()) {
        for(Ordeno o : lista) { 
            String obsLimpia = o.getObservaciones().replace("[VACIADO]", "");
%>
<div class="modal fade" id="modalSesionDetalle_<%= o.getIdOrdeno() %>" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content border-0">
            <div class="modal-header border-0 pb-0 justify-content-center position-relative mt-3 no-print">
                <h4 class="modal-title fw-bold text-dark"><i class="bi bi-droplet-half text-brand me-2"></i> Reporte de Sesión</h4>
                <button type="button" class="btn-close position-absolute end-0 me-4" data-bs-dismiss="modal"></button>
            </div>
            
            <div class="modal-body px-4 py-4">
                <div class="print-header d-none text-center mb-4">
                    <h2 class="fw-bold" style="color: #1C7345;">FINCA LA ROSA</h2>
                    <h4 class="text-dark">Reporte de Ordeño</h4>
                    <p class="text-muted mb-0">Impreso el <%= fechaActual %></p>
                </div>

                <div class="row g-3 mb-4 text-center">
                    <div class="col-4 border-end"><h5 class="fw-bolder text-brand"><%= o.getTotalLitros() %> L</h5><span class="text-muted small fw-bold">APTO COMERCIAL</span></div>
                    <div class="col-4 border-end"><h5 class="fw-bolder text-danger"><%= o.getTotalDescarte() %> L</h5><span class="text-muted small fw-bold">DESCARTE</span></div>
                    <div class="col-4"><h5 class="fw-bolder text-dark"><%= o.getTotalVacas() %></h5><span class="text-muted small fw-bold">VACAS ORDEÑADAS</span></div>
                </div>

                <% if(obsLimpia != null && !obsLimpia.isEmpty()) { %>
                <div class="alert alert-warning border-0 rounded-4 shadow-sm mb-4 bg-warning-subtle">
                    <i class="bi bi-exclamation-triangle-fill text-warning me-2"></i>
                    <strong class="text-dark">Anotaciones Médicas / Descarte:</strong><br>
                    <span class="text-dark small mt-1 d-block"><%= obsLimpia.replace("\n", "<br>") %></span>
                </div>
                <% } %>

                <h5 class="fw-bold border-bottom pb-2 mb-3 text-dark">Detalle Individual por Vaca</h5>
                <div class="table-responsive table-custom-wrapper shadow-sm">
                    <table class="table align-middle m-0">
                        <thead class="text-center bg-light">
                            <tr>
                                <th>Foto</th>
                                <th>Arete</th>
                                <th>Litros Aportados</th>
                            </tr>
                        </thead>
                        <tbody class="text-center">
                            <% 
                               for(DetalleOrdeno d : o.getDetalles()) { 
                                   String imgStr = d.getImageUrl();
                                   boolean hasImg = (imgStr != null && !imgStr.trim().isEmpty() && !imgStr.equals("null"));
                            %>
                            <tr>
                                <td>
                                    <% if(hasImg) { %>
                                        <img src="<%= request.getContextPath() %>/<%= imgStr %>" class="rounded-circle object-fit-cover shadow-sm border border-2 border-white" width="50" height="50">
                                    <% } else { %>
                                        <div class="rounded-circle bg-light border d-flex align-items-center justify-content-center mx-auto shadow-sm" style="width: 50px; height: 50px;">
                                            <i class="bi bi-image text-secondary fs-5"></i>
                                        </div>
                                    <% } %>
                                </td>
                                <td class="fw-bold text-dark fs-5"><%= d.getNumeroArete() %></td>
                                <td><span class="badge bg-brand rounded-pill fs-6 px-4 py-2 shadow-sm"><%= d.getLitrosObtenidos() %> L</span></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer border-0 pt-0 pb-4 px-4 d-flex justify-content-between no-print">
                <button type="button" class="btn btn-light fw-bold px-4 rounded-pill shadow-sm" data-bs-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-brand px-5 rounded-pill shadow-sm" onclick="window.print()"><i class="bi bi-printer-fill me-2"></i> Imprimir Reporte</button>
            </div>
        </div>
    </div>
</div>
<%      }
    } 
%>

<div class="modal fade" id="modalSesion" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0">
            <div class="modal-header border-0 pb-0 justify-content-center position-relative mt-3">
                <h4 class="modal-title fw-bold text-dark"><i class="bi bi-clipboard-check text-brand me-2"></i> Registro de Ordeño</h4>
                <button type="button" class="btn-close position-absolute end-0 me-4" data-bs-dismiss="modal"></button>
            </div>
            
            <form action="produccion" method="POST" id="formSesion">
                <input type="hidden" name="action" value="registrar">
                <input type="hidden" name="filtroActual" value="<%= filtroActivo %>">
                <div class="modal-body px-4 py-4">
                    <div class="row g-3 mb-4 bg-light p-3 rounded-4 border shadow-sm">
                        <div class="col-md-4">
                            <label class="form-label small fw-bold text-muted text-uppercase ms-1">Fecha y Hora</label>
                            <input type="datetime-local" name="fechaHora" id="inputFecha" class="form-control shadow-sm border-0" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-bold text-muted text-uppercase ms-1">Lugar / Establo</label>
                            <input type="text" name="lugar" class="form-control shadow-sm border-0" placeholder="Ej: Sala 1, Establo Central" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-bold text-muted text-uppercase ms-1">Supervisor</label>
                            <select name="supervisorId" class="form-select shadow-sm border-0" required>
                                <option value="" disabled selected>Seleccione operario...</option>
                                <% 
                                    List<Usuario> listaEmpleados = (List<Usuario>) request.getAttribute("listaEmpleados");
                                    if(listaEmpleados != null) {
                                        for(Usuario emp : listaEmpleados) {
                                %>
                                        <option value="<%= emp.getId() %>"><%= emp.getFullName() %> (<%= emp.getRol() %>)</option>
                                <%      } } %>
                            </select>
                        </div>
                    </div>

                    <h5 class="fw-bold text-dark border-bottom pb-2 mb-3 mt-4">Lista de Animales Ordeñados</h5>
                    
                    <div class="row g-2 mb-4 align-items-center bg-white p-3 rounded-4 border shadow-sm">
                        <div class="col-md-7">
                            <select id="selectorVaca" class="form-select shadow-sm border-0 bg-light fw-bold text-dark">
                                <option value="" selected disabled>-- Busque y seleccione una vaca --</option>
                                <% 
                                    List<Bovino> vacas = (List<Bovino>) request.getAttribute("listaVacas");
                                    if(vacas != null && !vacas.isEmpty()) {
                                        for(Bovino v : vacas) {
                                %>
                                <option value="<%= v.getIdBovino() %>" 
                                        data-arete="<%= v.getNumeroArete() %>" 
                                        data-raza="<%= v.getRaza() %>" 
                                        data-promedio="<%= v.getLitrosDiariosPromedio() %>" 
                                        data-salud="<%= v.getEstadoSalud() %>"
                                        data-img="<%= v.getImageUrl() %>">
                                    🐄 <%= v.getNumeroArete() %> - <%= v.getRaza() %> [Salud: <%= v.getEstadoSalud() %>]
                                </option>
                                <%      }
                                    } else { %>
                                <option value="" disabled>No hay vacas asignadas a Producción</option>
                                <% } %>
                            </select>
                        </div>
                        
                        <div class="col-md-5 d-flex gap-2">
                            <button type="button" class="btn btn-brand w-100 rounded-pill shadow-sm py-2" id="btnAgregarVaca">
                                <i class="bi bi-plus-lg me-1"></i> Apta
                            </button>
                            <button type="button" class="btn btn-outline-danger w-100 rounded-pill shadow-sm py-2" id="btnAgregarDescarte">
                                <i class="bi bi-shield-x me-1"></i> Descarte
                            </button>
                        </div>
                    </div>

                    <div class="table-responsive table-custom-wrapper shadow-sm mb-3">
                        <table class="table align-middle m-0">
                            <thead class="text-secondary text-uppercase" style="font-size: 0.75rem;">
                                <tr>
                                    <th width="35%">Vaca</th>
                                    <th width="25%">Promedio / Estado</th>
                                    <th width="35%">Litros Extraídos Hoy</th>
                                    <th width="5%" class="text-center">Quitar</th>
                                </tr>
                            </thead>
                            <tbody id="tbodyVacas">
                                <tr id="emptyRow"><td colspan="4" class="text-center text-muted py-5"><i class="bi bi-basket fs-2 d-block mb-2 opacity-50"></i>Aún no has añadido ninguna vaca a este ordeño.</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="mb-2 mt-4">
                        <label class="form-label text-muted fw-bold small text-uppercase ms-1">Observaciones Generales de la Sesión</label>
                        <textarea name="observaciones" class="form-control shadow-sm" rows="2" placeholder="Ej: Clima lluvioso, todo transcurrió con normalidad." style="border-radius: 18px;"></textarea>
                    </div>
                </div>
                
                <div class="summary-bar">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex gap-3 gap-md-4 ms-3 flex-wrap">
                            <div><small class="text-muted fw-bold d-block text-uppercase" style="font-size: 11px;">Total Vacas</small><strong class="fs-4 text-dark" id="resVacas">0</strong></div>
                            <div><small class="text-brand fw-bold d-block text-uppercase" style="font-size: 11px;">Comercial</small><strong class="fs-4 text-brand"><span id="resLitros">0.0</span> L</strong></div>
                            <div class="d-none d-md-block"><small class="text-muted fw-bold d-block text-uppercase" style="font-size: 11px;">Promedio General</small><strong class="fs-4 text-dark"><span id="resPromedio">0.0</span> L</strong></div>
                            <div><small class="text-danger fw-bold d-block text-uppercase" style="font-size: 11px;">Descarte</small><strong class="fs-4 text-danger"><span id="resDescarte">0.0</span> L</strong></div>
                        </div>
                        <div>
                            <button type="button" class="btn btn-light fw-bold px-4 rounded-pill me-2 shadow-sm border" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-brand px-5 rounded-pill shadow-sm" id="btnGuardar" disabled><i class="bi bi-save me-2"></i> Guardar Registro</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // =========================================================
    // CORRECCIÓN LINTER JS: Variables seguras
    // =========================================================
    const rawVacas = '<%= jsArrayVacas %>';
    const vacasOrdenadasTurno = rawVacas ? rawVacas.split(',').map(Number) : [];

    const penManana = parseFloat(document.getElementById('jsPendManana').value) || 0;
    const penTarde = parseFloat(document.getElementById('jsPendTarde').value) || 0;
    const penTotal = penManana + penTarde;

    function updateDistribucionUI() {
        let turno = document.getElementById('selectTurno').value;
        let disponibles = (turno === 'manana') ? penManana : (turno === 'tarde') ? penTarde : penTotal;
        let slider = document.getElementById('sliderDistribucion');
        
        let porcVenta = parseInt(slider.value);
        let porcFabrica = 100 - porcVenta;

        document.getElementById('lblPorcFabrica').innerText = porcFabrica + '%';
        document.getElementById('lblPorcVenta').innerText = porcVenta + '%';
        
        document.getElementById('lblLitrosFabrica').innerText = ((disponibles * porcFabrica) / 100).toFixed(1) + ' L';
        document.getElementById('lblLitrosVenta').innerText = ((disponibles * porcVenta) / 100).toFixed(1) + ' L';
        
        document.getElementById('inputHiddenPorcFabrica').value = porcFabrica;
        
        let btn = document.getElementById('btnDistribuir');
        if(disponibles <= 0) {
            btn.disabled = true;
            btn.innerHTML = '<i class="bi bi-x-circle me-1"></i> Sin leche pendiente';
        } else {
            btn.disabled = false;
            btn.innerHTML = '<i class="bi bi-check2-all me-1"></i> Guardar Destino';
        }
    }
    
    document.addEventListener("DOMContentLoaded", function() { updateDistribucionUI(); });

    function confirmarVaciado(form) {
        Swal.fire({
            title: '¿Vaciar Fosa de Descarte?',
            text: "Esta acción reiniciará a 0L el tanque contaminado. Se guardará el registro histórico.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Sí, Vaciar Tanque',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) { form.submit(); }
        });
    }

    let now = new Date();
    document.getElementById('inputFecha').value = new Date(now.getTime() - now.getTimezoneOffset() * 60000).toISOString().slice(0,16);

    const turnoActual = '<%= turnoActualStr %>';

    function validarVacaOrdenada(id) {
        if(vacasOrdenadasTurno.includes(parseInt(id))) {
            Swal.fire({
                icon: 'warning',
                title: 'Vaca en Reposo',
                text: `Esta vaca ya fue ordeñada en el turno de la ${turnoActual}. Déjela descansar hasta el próximo turno.`,
                confirmButtonColor: '#1C7345'
            });
            return false;
        }
        if(document.getElementById('row_vaca_' + id)) {
            Swal.fire({ icon: 'warning', title: 'Vaca duplicada', text: 'Esta vaca ya está en la mesa de ordeño actual.', confirmButtonColor: '#1C7345' });
            return false;
        }
        return true;
    }

    document.getElementById('btnAgregarVaca').addEventListener('click', function() {
        let select = document.getElementById('selectorVaca');
        let selectedOption = select.options[select.selectedIndex];
        if(!selectedOption.value) {
            Swal.fire({ icon: 'info', title: 'Selecciona una vaca', text: 'Debes elegir un animal de la lista primero.', confirmButtonColor: '#1C7345' });
            return;
        }

        let id = selectedOption.value;
        if(!validarVacaOrdenada(id)) return;

        let salud = selectedOption.dataset.salud;
        if(salud === 'En Tratamiento' || salud.includes('Enferm')) {
            Swal.fire({
                title: '⚠️ ¡ALTO BIOLÓGICO!',
                html: `Esta vaca se encuentra en estado: <b>${salud}</b>.<br><br>Su leche contaminará el tanque principal.<br><br>Use el botón "Descarte" para registrar esta leche de forma aislada.`,
                icon: 'error', confirmButtonColor: '#dc3545', confirmButtonText: 'Entendido'
            });
        } else {
            inyectarFilaVaca(selectedOption, false);
        }
    });

    document.getElementById('btnAgregarDescarte').addEventListener('click', function() {
        let select = document.getElementById('selectorVaca');
        let selectedOption = select.options[select.selectedIndex];
        if(!selectedOption.value) {
            Swal.fire({ icon: 'info', title: 'Selecciona una vaca', text: 'Debes elegir un animal de la lista primero.', confirmButtonColor: '#1C7345' });
            return;
        }

        let id = selectedOption.value;
        if(!validarVacaOrdenada(id)) return;

        inyectarFilaVaca(selectedOption, true);
    });

    function inyectarFilaVaca(selectedOption, isDescarte) {
        let id = selectedOption.value;
        let arete = selectedOption.dataset.arete;
        let raza = selectedOption.dataset.raza;
        let promedio = parseFloat(selectedOption.dataset.promedio).toFixed(1);
        let img = selectedOption.dataset.img;
        let contextPath = document.getElementById('appContextPath').value;

        let imgHtml = (img && img !== "null" && img.trim() !== "") 
            ? `<img src="${contextPath}/${img}" class="cow-mini-pic me-3 border shadow-sm">`
            : `<div class="cow-mini-pic me-3 border shadow-sm bg-light d-flex align-items-center justify-content-center text-secondary"><i class="bi bi-image fs-5"></i></div>`;

        let rowClass = isDescarte ? "vaca-row bg-danger-subtle border-danger" : "vaca-row bg-white";
        let badgePromedio = isDescarte 
            ? `<span class="badge bg-danger text-white border px-3 py-2 shadow-sm"><i class="bi bi-exclamation-triangle-fill"></i> DESCARTE</span>` 
            : `<span class="badge bg-light text-secondary border px-3 py-2 shadow-sm"><i class="bi bi-clock-history"></i> ${promedio} L</span>`;
        let inputName = isDescarte ? `litros_descarte_vaca_${id}` : `litros_vaca_${id}`;
        let inputClass = isDescarte ? "form-control text-danger fw-bold input-litros-descarte shadow-sm border-danger" : "form-control text-brand fw-bold input-litros shadow-sm";

        let tr = document.createElement('tr');
        tr.id = 'row_vaca_' + id;
        tr.className = rowClass;
        tr.innerHTML = `
            <td>
                <div class="d-flex align-items-center ps-2">
                    ${imgHtml}
                    <div>
                        <strong class="d-block ${isDescarte ? 'text-danger' : 'text-dark'} fs-6" style="line-height: 1;">${arete}</strong>
                        <small class="text-muted" style="font-size: 12px;">${raza}</small>
                    </div>
                </div>
            </td>
            <td>${badgePromedio}</td>
            <td>
                <div class="d-flex align-items-center">
                    <input type="number" step="0.1" name="${inputName}" class="${inputClass}" style="width: 110px;" data-id="${id}" data-promedio="${promedio}" oninput="calcularEstadisticas()" required placeholder="0.0">
                    <span class="ms-3 fw-bold stat-badge" id="stat_${id}" style="font-size: 13px;"></span>
                </div>
            </td>
            <td class="text-center">
                <button type="button" class="btn btn-sm btn-outline-danger border-0 rounded-circle shadow-sm bg-white" onclick="removerVaca('${id}')"><i class="bi bi-x-lg fs-5"></i></button>
            </td>
        `;

        document.getElementById('tbodyVacas').appendChild(tr);
        document.getElementById('emptyRow').style.display = 'none';
        document.getElementById('selectorVaca').value = "";
        calcularEstadisticas();
    }

    function removerVaca(id) {
        document.getElementById('row_vaca_' + id).remove();
        if(document.querySelectorAll('#tbodyVacas tr').length === 1) document.getElementById('emptyRow').style.display = 'table-row';
        calcularEstadisticas();
    }

    function calcularEstadisticas() {
        let btn = document.getElementById('btnGuardar');
        let inputsSanos = document.querySelectorAll('.input-litros');
        let inputsDescarte = document.querySelectorAll('.input-litros-descarte');
        
        let totalLitros = 0, totalVacas = 0, totalDescarte = 0;

        inputsSanos.forEach(input => {
            let val = parseFloat(input.value);
            let promedioObj = parseFloat(input.dataset.promedio);
            let badge = document.getElementById('stat_' + input.dataset.id);
            if (!isNaN(val) && val > 0) {
                totalLitros += val; totalVacas++;
                if (promedioObj > 0) {
                    let diff = val - promedioObj;
                    if (diff > 0) { badge.innerHTML = '<i class="bi bi-graph-up-arrow"></i> +' + diff.toFixed(1) + 'L'; badge.className = 'badge bg-brand-subtle text-brand border ms-3 px-2 py-1 stat-badge'; } 
                    else if (diff < 0) { badge.innerHTML = '<i class="bi bi-graph-down-arrow"></i> ' + diff.toFixed(1) + 'L'; badge.className = 'badge bg-danger-subtle text-danger border border-danger-subtle ms-3 px-2 py-1 stat-badge'; } 
                    else { badge.innerHTML = '<i class="bi bi-dash-lg"></i> ='; badge.className = 'badge bg-light text-secondary border ms-3 px-2 py-1 stat-badge'; }
                }
            } else { badge.innerHTML = ''; }
        });

        inputsDescarte.forEach(input => { let val = parseFloat(input.value); if (!isNaN(val) && val > 0) totalDescarte += val; });

        document.getElementById('resLitros').innerText = totalLitros.toFixed(1);
        document.getElementById('resVacas').innerText = totalVacas;
        document.getElementById('resPromedio').innerText = totalVacas > 0 ? (totalLitros / totalVacas).toFixed(1) : '0.0';
        document.getElementById('resDescarte').innerText = totalDescarte.toFixed(1);
        
        btn.disabled = (totalVacas === 0 && totalDescarte === 0);
    }
</script>
</body>
</html>