<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.finca.models.Ordeno" %>
<%@ page import="com.finca.models.DetalleOrdeno" %>
<%@ page import="com.finca.models.Usuario" %>
<%@ page import="com.finca.models.Bovino" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Gestión de Producción | Finca</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            /* Identidad Visual Finca La Rosa */
            --brand-main: #1C7345;
            --brand-hover: #165c37;
            --brand-accent: #00A859;
            --brand-light: #eaf6ee;
        }

        body { font-family: 'Inter', sans-serif; background-color: #f3f7f4; }
        
        /* Dashboard Stats Cards Mejora UI */
        .card-stat { background: rgba(255, 255, 255, 0.95); border-radius: 24px; padding: 25px; border: 1px solid #e0e8e3; box-shadow: 0 15px 35px rgba(28,115,69,0.05); height: 100%; display: flex; flex-direction: column; justify-content: space-between; transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .card-stat:hover { transform: translateY(-5px); box-shadow: 0 20px 45px rgba(28,115,69,0.1); }
        
        .card-stock { background: linear-gradient(135deg, var(--brand-main), var(--brand-accent)); color: white; border-radius: 24px; box-shadow: 0 12px 30px rgba(28, 115, 69, 0.25); height: 100%; display: flex; flex-direction: column; justify-content: space-between; padding: 25px; position: relative; overflow: hidden; }
        .card-stock .watermark { position: absolute; right: -20px; bottom: -20px; font-size: 8rem; opacity: 0.1; transform: rotate(-15deg); pointer-events: none; }
        
        /* Modificación para progreso animado de Bootstrap */
        .progress { background-color: #e9ecef; border-radius: 50px; overflow: hidden; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1); }
        .progress-bar { font-weight: 700; font-size: 10px; line-height: 12px; transition: width 1s ease-in-out; }

        .table-container { background: rgba(255, 255, 255, 0.95); border: 1px solid rgba(255,255,255,0.6); border-radius: 24px; padding: 24px; box-shadow: 0 16px 40px rgba(0,0,0,0.04); }
        .cow-mini-pic { width: 45px; height: 45px; object-fit: cover; border-radius: 12px; }
        
        /* Clases Personalizadas para erradicar el azul de Bootstrap */
        .text-brand { color: var(--brand-main) !important; }
        .bg-brand { background-color: var(--brand-main) !important; color: white !important; }
        .bg-brand-subtle { background-color: var(--brand-light) !important; border-color: #cde6d7 !important; color: var(--brand-main) !important; }
        
        .btn-brand { background-color: var(--brand-main); color: white; border: none; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; transition: all 0.3s ease; }
        .btn-brand:hover { background-color: var(--brand-hover); color: white; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(28, 115, 69, 0.25); }
        
        .btn-outline-brand { color: var(--brand-main); border: 2px solid var(--brand-main); font-weight: 600; background: transparent; transition: all 0.3s ease; }
        .btn-outline-brand:hover { background-color: var(--brand-main); color: white; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(28, 115, 69, 0.2); }

        /* Controles de Formulario */
        .form-control, .form-select { border-radius: 14px; background: rgba(255,255,255,0.7); border: 1px solid #dce3df; color: #1d1d1f; transition: all 0.3s ease;}
        .form-control:focus, .form-select:focus { background: #ffffff; border-color: var(--brand-main); box-shadow: 0 0 0 4px rgba(28, 115, 69, 0.15); outline: none; }
        
        .modal-content { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(40px) saturate(200%); border-radius: 28px; border: 1px solid rgba(255,255,255,0.8); box-shadow: 0 25px 50px rgba(0,0,0,0.15); }
        .summary-bar { position: sticky; bottom: 0; background: rgba(255,255,255,0.9); backdrop-filter: blur(10px); border-top: 1px solid #eee; z-index: 10; }
        
        tr.vaca-row { animation: fadeIn 0.4s ease forwards; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

        /* Adaptación de SweetAlert */
        div:where(.swal2-container) div:where(.swal2-popup) { border-radius: 24px; font-family: 'Inter', sans-serif; box-shadow: 0 25px 50px rgba(0,0,0,0.15); }
        div:where(.swal2-container) button:where(.swal2-styled) { border-radius: 14px; font-weight: 600; padding: 10px 24px; }

        @media print {
            body * { visibility: hidden; }
            .modal.show .modal-content, .modal.show .modal-content * { visibility: visible; }
            .modal.show .modal-content { 
                position: absolute; left: 0; top: 0; width: 100vw; background: white !important; 
                border: none !important; box-shadow: none !important; backdrop-filter: none !important; border-radius: 0;
            }
            .btn-close, .modal-footer, .no-print { display: none !important; }
            .print-header { display: block !important; border-bottom: 2px solid var(--brand-main); margin-bottom: 20px; padding-bottom: 10px; }
            .badge { border: 1px solid #000; color: #000 !important; background: transparent !important; }
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />
<input type="hidden" id="appContextPath" value="<%= request.getContextPath() %>">

<% if(request.getAttribute("successMessage") != null) { %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            Swal.fire({
                icon: 'success',
                title: '¡Operación Exitosa!',
                text: '<%= request.getAttribute("successMessage") %>',
                confirmButtonColor: '#1C7345',
                timer: 4000
            });
        });
    </script>
<% } %>

<% if(request.getAttribute("errorMessage") != null) { %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            Swal.fire({
                icon: 'error',
                title: 'Error de Validación',
                text: '<%= request.getAttribute("errorMessage") %>',
                confirmButtonColor: '#dc3545'
            });
        });
    </script>
<% } %>

<div class="container py-4">
    
    <div class="row g-4 mb-5 align-items-stretch">
        
        <div class="col-lg-4 col-md-6">
            <div class="card-stat">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="fw-bold text-muted mb-0 text-uppercase" style="letter-spacing: 1px;">
                        <i class="bi bi-inbox-fill text-brand me-2"></i> Inventario Leche
                    </h6>
                    <span class="badge bg-brand-subtle rounded-pill"><%= stockLecheObj %> L</span>
                </div>
                
                <h2 class="fw-bolder text-dark mb-3"><%= Math.round(porcentajeTanque) %>% <span class="fs-6 fw-normal text-muted">de capacidad</span></h2>
                
                <div class="progress mb-2" style="height: 14px;">
                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-brand" role="progressbar" id="barTanque" aria-valuenow="<%= porcentajeTanque %>" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
                <small class="text-muted fw-semibold"><i class="bi bi-info-circle me-1"></i> Límite del tanque: <%= capacidadTanque %> L</small>
            </div>
        </div>

        <div class="col-lg-4 col-md-6">
            <div class="card-stat">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="fw-bold text-muted mb-0 text-uppercase" style="letter-spacing: 1px;">
                        <i class="bi bi-graph-up-arrow text-success me-2"></i> Eficiencia Hato
                    </h6>
                    <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill"><%= promedioHistorico %> L / Vaca</span>
                </div>
                
                <h2 class="fw-bolder text-dark mb-3"><%= Math.round(porcentajeRendimiento) %>% <span class="fs-6 fw-normal text-muted">vs Meta Ideal</span></h2>
                
                <div class="progress mb-2" style="height: 14px;">
                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-success" role="progressbar" id="barRendimiento" aria-valuenow="<%= porcentajeRendimiento %>" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
                <small class="text-muted fw-semibold"><i class="bi bi-bullseye me-1"></i> Meta Finca: <%= metaVaca %> L diarios por vaca</small>
            </div>
        </div>

        <div class="col-lg-4 col-md-12">
            <div class="card-stock">
                <i class="bi bi-activity watermark"></i>
                <div>
                    <h6 class="fw-bold mb-3 opacity-75 text-uppercase" style="letter-spacing: 1px;">Desempeño Último Turno</h6>
                    <div class="d-flex align-items-end gap-3 mb-2">
                        <h2 class="fw-bolder mb-0 position-relative z-1"><%= ultimaProduccion %> <small class="fs-5 fw-medium">L</small></h2>
                        <span class="badge bg-white text-dark rounded-pill mb-2 shadow-sm">Récord: <%= maxProduccion %> L</span>
                    </div>
                    
                    <div class="progress bg-white bg-opacity-25 mb-4 position-relative z-1" style="height: 6px;">
                        <div class="progress-bar bg-white" role="progressbar" id="barUltimo" aria-valuenow="<%= porcentajeUltimo %>" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                </div>
                
                <button class="btn bg-white text-brand fw-bolder rounded-pill shadow-sm py-2 position-relative z-1 w-100" data-bs-toggle="modal" data-bs-target="#modalSesion">
                    <i class="bi bi-plus-circle-fill me-2"></i> INICIAR NUEVO ORDEÑO
                </button>
            </div>
        </div>
    </div>
    <h4 class="fw-bold text-dark mb-3"><i class="bi bi-card-checklist text-brand me-2"></i> Bitácora de Sesiones</h4>
    <div class="table-container table-responsive">
        <table class="table table-hover align-middle">
            <thead class="text-secondary text-uppercase" style="font-size: 0.75rem;">
                <tr>
                    <th>Fecha y Lugar</th>
                    <th>Rendimiento del Turno</th>
                    <th>Responsable</th>
                    <th>Reporte Clínico</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    if(lista != null && !lista.isEmpty()) {
                        for(Ordeno o : lista) {
                %>
                <tr>
                    <td>
                        <strong class="d-block text-dark mb-1"><i class="bi bi-calendar3 text-brand me-2"></i><%= o.getFechaHora() %></strong>
                        <small class="text-muted fw-medium"><i class="bi bi-geo-alt-fill text-danger me-1"></i> <%= o.getLugar() %></small>
                    </td>
                    <td>
                        <div class="d-flex flex-wrap gap-2">
                            <span class="badge bg-brand-subtle px-3 py-2 rounded-pill fs-6 shadow-sm border" title="Total de Leche en este turno">
                                <i class="bi bi-droplet-fill me-1"></i> <%= o.getTotalLitros() %> L
                            </span>
                            <span class="badge bg-light text-dark px-3 py-2 rounded-pill shadow-sm border" title="Promedio por vaca en este turno">
                                <i class="bi bi-bar-chart-fill text-success me-1"></i> <%= o.getPromedioLitros() %> L
                            </span>
                            <span class="badge bg-light text-muted px-3 py-2 rounded-pill shadow-sm border" title="Total vacas ordeñadas">
                                <i class="bi bi-bucket-fill me-1"></i> <%= o.getTotalVacas() %> Vacas
                            </span>
                        </div>
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
                <tr><td colspan="4" class="text-center py-5 text-muted"><i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>Aún no hay registros de ordeño en la base de datos.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<% 
    if(lista != null && !lista.isEmpty()) {
        for(Ordeno o : lista) { 
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

                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded-4 border shadow-sm">
                            <small class="text-muted fw-bold d-block text-uppercase"><i class="bi bi-calendar-event text-brand me-1"></i> Fecha y Hora</small>
                            <strong class="fs-6 text-dark"><%= o.getFechaHora() %></strong>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded-4 border shadow-sm">
                            <small class="text-muted fw-bold d-block text-uppercase"><i class="bi bi-geo-alt-fill text-danger me-1"></i> Lugar</small>
                            <strong class="fs-6 text-dark"><%= o.getLugar() %></strong>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded-4 border shadow-sm">
                            <small class="text-muted fw-bold d-block text-uppercase"><i class="bi bi-person-badge text-brand me-1"></i> Supervisor</small>
                            <strong class="fs-6 text-dark"><%= o.getNombreSupervisor() %></strong>
                        </div>
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-4"><div class="p-3 bg-brand-subtle rounded-4 text-center border shadow-sm"><small class="text-brand fw-bold d-block">TOTAL LITROS</small><strong class="fs-4 text-brand"><%= o.getTotalLitros() %> L</strong></div></div>
                    <div class="col-4"><div class="p-3 bg-light rounded-4 text-center border shadow-sm"><small class="text-muted fw-bold d-block">PROMEDIO</small><strong class="fs-4 text-dark"><%= o.getPromedioLitros() %> L</strong></div></div>
                    <div class="col-4"><div class="p-3 bg-light rounded-4 text-center border shadow-sm"><small class="text-muted fw-bold d-block">VACAS</small><strong class="fs-4 text-dark"><%= o.getTotalVacas() %></strong></div></div>
                </div>

                <% if(o.getObservaciones() != null && !o.getObservaciones().isEmpty()) { %>
                <div class="alert alert-warning border-0 rounded-4 shadow-sm mb-4 bg-warning-subtle">
                    <i class="bi bi-exclamation-triangle-fill text-warning me-2"></i>
                    <strong class="text-dark">Observaciones Médicas / Descarte:</strong><br>
                    <span class="text-dark small mt-1 d-block"><%= o.getObservaciones().replace("\n", "<br>") %></span>
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

                <div class="text-end mt-4 print-header d-none">
                    <br><br><br>
                    <p class="mb-0">___________________________________</p>
                    <p class="text-muted small fw-bold">Firma del Supervisor</p>
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
                <h4 class="modal-title fw-bold text-dark"><i class="bi bi-droplet-half text-brand me-2"></i> Nueva Sesión de Ordeño</h4>
                <button type="button" class="btn-close position-absolute end-0 me-4" data-bs-dismiss="modal"></button>
            </div>
            
            <form action="produccion" method="POST" id="formSesion">
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
                        <div class="col-md-9">
                            <select id="selectorVaca" class="form-select shadow-sm border-0 bg-light fw-bold text-dark">
                                <option value="" selected disabled>-- Busque y seleccione una vaca para añadir a la lista --</option>
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
                        <div class="col-md-3 text-end">
                            <button type="button" class="btn btn-brand w-100 rounded-pill shadow-sm py-2" id="btnAgregarVaca">
                                <i class="bi bi-plus-lg me-1"></i> Añadir a Sesión
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
                
                <div class="summary-bar p-3 d-flex justify-content-between align-items-center rounded-bottom-4 shadow-lg border-top border-light">
                    <div class="d-flex gap-3 gap-md-4 ms-3 flex-wrap">
                        <div><small class="text-muted fw-bold d-block text-uppercase" style="font-size: 11px;">Total Vacas</small><strong class="fs-4 text-dark" id="resVacas">0</strong></div>
                        <div><small class="text-brand fw-bold d-block text-uppercase" style="font-size: 11px;">Comercial</small><strong class="fs-4 text-brand"><span id="resLitros">0.0</span> L</strong></div>
                        <div class="d-none d-md-block"><small class="text-muted fw-bold d-block text-uppercase" style="font-size: 11px;">Promedio General</small><strong class="fs-4 text-dark"><span id="resPromedio">0.0</span> L</strong></div>
                        <div><small class="text-danger fw-bold d-block text-uppercase" style="font-size: 11px;">Descarte</small><strong class="fs-4 text-danger"><span id="resDescarte">0.0</span> L</strong></div>
                    </div>
                    <div>
                        <button type="button" class="btn btn-light fw-bold px-4 rounded-pill me-2 shadow-sm border" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-brand px-5 rounded-pill shadow-sm" id="btnGuardar" disabled><i class="bi bi-cloud-arrow-up-fill me-2"></i> Guardar Sesión</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Asignación de anchos a las barras de progreso usando JS puro (Evita errores del Linter de VS Code)
    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById('barTanque').style.width = '<%= porcentajeTanque %>%';
        document.getElementById('barRendimiento').style.width = '<%= porcentajeRendimiento %>%';
        document.getElementById('barUltimo').style.width = '<%= porcentajeUltimo %>%';
    });

    let now = new Date();
    document.getElementById('inputFecha').value = new Date(now.getTime() - now.getTimezoneOffset() * 60000).toISOString().slice(0,16);

    // ==============================================================
    // LÓGICA DE BIOSEGURIDAD CON SWEET ALERT 2
    // ==============================================================
    document.getElementById('btnAgregarVaca').addEventListener('click', function() {
        let select = document.getElementById('selectorVaca');
        let selectedOption = select.options[select.selectedIndex];

        if(!selectedOption.value) {
            Swal.fire({ icon: 'info', title: 'Selecciona una vaca', text: 'Debes elegir un animal de la lista primero.', confirmButtonColor: '#1C7345' });
            return;
        }

        let id = selectedOption.value;
        let salud = selectedOption.dataset.salud;
        
        if(document.getElementById('row_vaca_' + id)) {
            Swal.fire({ icon: 'warning', title: 'Vaca duplicada', text: 'Esta vaca ya está en la mesa de ordeño.', confirmButtonColor: '#1C7345' });
            return;
        }

        // CANDADO DE 4 DÍAS (SweetAlert Asíncrono)
        if(salud === 'En Tratamiento' || salud.includes('Enferm')) {
            Swal.fire({
                title: '⚠️ ¡ALTO BIOLÓGICO!',
                html: `Esta vaca se encuentra en estado: <b>${salud}</b>.<br><br>Durante los 4 días de tiempo de retiro tras un medicamento o purga, su leche contaminará el tanque principal y arruinará la producción comercial.<br><br>¿Deseas registrarla estrictamente como <b>ORDEÑO DE DESCARTE</b>?`,
                icon: 'error',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, Registrar como Descarte',
                cancelButtonText: 'Cancelar Ordeño',
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    inyectarFilaVaca(selectedOption, true);
                } else {
                    select.value = "";
                }
            });
        } else {
            inyectarFilaVaca(selectedOption, false);
        }
    });

    // Función inyectora de DOM
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
                <button type="button" class="btn btn-sm btn-outline-danger border-0 rounded-circle shadow-sm bg-white" onclick="removerVaca('${id}')" title="Quitar vaca">
                    <i class="bi bi-x-lg fs-5"></i>
                </button>
            </td>
        `;

        document.getElementById('tbodyVacas').appendChild(tr);
        
        let emptyRow = document.getElementById('emptyRow');
        if(emptyRow) emptyRow.style.display = 'none';

        document.getElementById('selectorVaca').value = "";
        calcularEstadisticas();
    }

    function removerVaca(id) {
        document.getElementById('row_vaca_' + id).remove();
        calcularEstadisticas();
        let tbody = document.getElementById('tbodyVacas');
        let rows = tbody.querySelectorAll('tr.vaca-row');
        if(rows.length === 0) {
            let emptyRow = document.getElementById('emptyRow');
            if(emptyRow) emptyRow.style.display = 'table-row';
        }
    }

    function calcularEstadisticas() {
        let inputsSanos = document.querySelectorAll('.input-litros');
        let inputsDescarte = document.querySelectorAll('.input-litros-descarte');
        
        let totalLitros = 0;
        let totalVacas = 0;
        let totalDescarte = 0;

        inputsSanos.forEach(input => {
            let val = parseFloat(input.value);
            let promedioObj = parseFloat(input.dataset.promedio);
            let badge = document.getElementById('stat_' + input.dataset.id);

            if (!isNaN(val) && val > 0) {
                totalLitros += val;
                totalVacas++;

                if (promedioObj > 0) {
                    let diff = val - promedioObj;
                    if (diff > 0) {
                        badge.innerHTML = '<i class="bi bi-graph-up-arrow"></i> +' + diff.toFixed(1) + 'L';
                        badge.className = 'badge bg-brand-subtle text-brand border ms-3 px-2 py-1 stat-badge';
                    } else if (diff < 0) {
                        badge.innerHTML = '<i class="bi bi-graph-down-arrow"></i> ' + diff.toFixed(1) + 'L';
                        badge.className = 'badge bg-danger-subtle text-danger border border-danger-subtle ms-3 px-2 py-1 stat-badge';
                    } else {
                        badge.innerHTML = '<i class="bi bi-dash-lg"></i> =';
                        badge.className = 'badge bg-light text-secondary border ms-3 px-2 py-1 stat-badge';
                    }
                }
            } else {
                badge.innerHTML = '';
            }
        });

        inputsDescarte.forEach(input => {
            let val = parseFloat(input.value);
            if (!isNaN(val) && val > 0) {
                totalDescarte += val;
            }
        });

        document.getElementById('resLitros').innerText = totalLitros.toFixed(1);
        document.getElementById('resVacas').innerText = totalVacas;
        document.getElementById('resPromedio').innerText = totalVacas > 0 ? (totalLitros / totalVacas).toFixed(1) : '0.0';
        document.getElementById('resDescarte').innerText = totalDescarte.toFixed(1);
        
        document.getElementById('btnGuardar').disabled = (totalVacas === 0 && totalDescarte === 0);
    }
</script>
</body>
</html>