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
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Producción | Finca</title>
    
    <!-- Fuentes y Estilos -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- SweetAlert2 (Para alertas tipo Apple) -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f5f5f7; }
        
        /* Paleta de colores mejorada */
        .card-stock { background: linear-gradient(135deg, #0A58CA, #0dcaf0); color: white; border-radius: 24px; box-shadow: 0 10px 25px rgba(13, 110, 253, 0.2); }
        .table-container { background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(24px); border: 1px solid rgba(255,255,255,0.6); border-radius: 24px; padding: 24px; box-shadow: 0 16px 40px rgba(0,0,0,0.06); }
        .cow-mini-pic { width: 45px; height: 45px; object-fit: cover; border-radius: 12px; }
        
        .form-control, .form-select { border-radius: 14px; background: rgba(255,255,255,0.7); border: 1px solid rgba(0,0,0,0.06); color: #1d1d1f; transition: all 0.3s ease;}
        .form-control:focus, .form-select:focus { background: #ffffff; border-color: #0d6efd; box-shadow: 0 0 0 4px rgba(13,110,253,0.15); outline: none; }
        
        .modal-content { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(40px) saturate(200%); border-radius: 28px; border: 1px solid rgba(255,255,255,0.8); box-shadow: 0 25px 50px rgba(0,0,0,0.15); }
        .summary-bar { position: sticky; bottom: 0; background: rgba(255,255,255,0.9); backdrop-filter: blur(10px); border-top: 1px solid #eee; z-index: 10; }
        
        tr.vaca-row { animation: fadeIn 0.4s ease forwards; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

        /* Adaptación de SweetAlert para que parezca iOS */
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
            .print-header { display: block !important; border-bottom: 2px solid #0d6efd; margin-bottom: 20px; padding-bottom: 10px; }
            .badge { border: 1px solid #000; color: #000 !important; background: transparent !important; }
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />
<input type="hidden" id="appContextPath" value="<%= request.getContextPath() %>">

<!-- CONTROLADOR DE ALERTAS BACKEND A SWEETALERT -->
<% if(request.getAttribute("successMessage") != null) { %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            Swal.fire({
                icon: 'success',
                title: '¡Operación Exitosa!',
                text: '<%= request.getAttribute("successMessage") %>',
                confirmButtonColor: '#2F855A',
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
    <div class="row mb-4 align-items-center">
        <!-- ESTADÍSTICA PRINCIPAL TOP -->
        <div class="col-md-5">
            <div class="card card-stock border-0 p-4">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="fw-bold mb-1 opacity-75 text-uppercase" style="letter-spacing: 1px;"><i class="bi bi-droplet-half"></i> Tanque Principal</h6>
                        <h2 class="display-5 fw-bold mb-0">
                            <%= request.getAttribute("stockLeche") != null ? request.getAttribute("stockLeche") : "0.0" %> <small class="fs-5 fw-medium">L</small>
                        </h2>
                    </div>
                    <i class="bi bi-inbox-fill text-white opacity-50" style="font-size: 3.5rem;"></i>
                </div>
            </div>
        </div>
        <div class="col-md-7 text-md-end mt-3 mt-md-0">
            <button class="btn btn-primary btn-lg fw-bold px-4 rounded-pill shadow-sm" data-bs-toggle="modal" data-bs-target="#modalSesion">
                <i class="bi bi-plus-circle-fill me-2"></i> Iniciar Ordeño
            </button>
        </div>
    </div>

    <h4 class="fw-bold text-dark mb-3"><i class="bi bi-journals text-primary me-2"></i> Historial de Sesiones</h4>
    <div class="table-container table-responsive">
        <table class="table table-hover align-middle">
            <thead class="text-secondary text-uppercase" style="font-size: 0.8rem;">
                <tr>
                    <th>Fecha y Lugar</th>
                    <th>Rendimiento Global</th>
                    <th>Supervisor</th>
                    <th>Acción</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Ordeno> lista = (List<Ordeno>) request.getAttribute("historial");
                    if(lista != null && !lista.isEmpty()) {
                        for(Ordeno o : lista) {
                %>
                <tr>
                    <td>
                        <strong class="d-block text-dark"><i class="bi bi-calendar3"></i> <%= o.getFechaHora() %></strong>
                        <small class="text-muted"><i class="bi bi-geo-alt-fill text-danger"></i> <%= o.getLugar() %></small>
                    </td>
                    <td>
                        <div class="d-flex gap-2">
                            <div class="text-center bg-light rounded-3 px-3 py-1 border"><small class="text-muted d-block" style="font-size: 10px; font-weight:700;">TOTAL</small><strong class="text-primary"><%= o.getTotalLitros() %> L</strong></div>
                            <div class="text-center bg-light rounded-3 px-3 py-1 border"><small class="text-muted d-block" style="font-size: 10px; font-weight:700;">PROMEDIO</small><strong class="text-success"><%= o.getPromedioLitros() %> L</strong></div>
                            <div class="text-center bg-light rounded-3 px-3 py-1 border"><small class="text-muted d-block" style="font-size: 10px; font-weight:700;">VACAS</small><strong class="text-dark"><%= o.getTotalVacas() %></strong></div>
                        </div>
                    </td>
                    <td><span class="badge bg-secondary rounded-pill px-3 py-2"><i class="bi bi-person-fill"></i> <%= o.getNombreSupervisor() %></span></td>
                    <td>
                        <button class="btn btn-outline-primary btn-sm fw-bold rounded-pill shadow-sm px-3" data-bs-toggle="modal" data-bs-target="#modalSesionDetalle_<%= o.getIdOrdeno() %>">
                            <i class="bi bi-file-earmark-text-fill me-1"></i> Informe
                        </button>
                    </td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr><td colspan="4" class="text-center py-5 text-muted"><i class="bi bi-inbox fs-1 d-block mb-2"></i> No hay sesiones registradas.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- MODALES DE INFORMES GENERADOS DINÁMICAMENTE -->
<% 
    if(lista != null && !lista.isEmpty()) {
        for(Ordeno o : lista) { 
%>
<div class="modal fade" id="modalSesionDetalle_<%= o.getIdOrdeno() %>" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content border-0">
            <div class="modal-header border-0 pb-0 justify-content-center position-relative mt-3 no-print">
                <h4 class="modal-title fw-bold text-dark"><i class="bi bi-droplet-half text-primary me-2"></i> Reporte de Sesión</h4>
                <button type="button" class="btn-close position-absolute end-0 me-4" data-bs-dismiss="modal"></button>
            </div>
            
            <div class="modal-body px-4 py-4">
                <div class="print-header d-none text-center mb-4">
                    <h2 class="fw-bold" style="color: #0d6efd;">FINCA LA ROSA</h2>
                    <h4 class="text-dark">Reporte de Ordeño</h4>
                    <p class="text-muted mb-0">Impreso el <%= fechaActual %></p>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded-4 border">
                            <small class="text-muted fw-bold d-block text-uppercase"><i class="bi bi-calendar-event text-primary"></i> Fecha y Hora</small>
                            <strong class="fs-6 text-dark"><%= o.getFechaHora() %></strong>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded-4 border">
                            <small class="text-muted fw-bold d-block text-uppercase"><i class="bi bi-geo-alt-fill text-danger"></i> Lugar</small>
                            <strong class="fs-6 text-dark"><%= o.getLugar() %></strong>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded-4 border">
                            <small class="text-muted fw-bold d-block text-uppercase"><i class="bi bi-person-badge text-success"></i> Supervisor</small>
                            <strong class="fs-6 text-dark"><%= o.getNombreSupervisor() %></strong>
                        </div>
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-4"><div class="p-3 bg-primary-subtle rounded-4 text-center border border-primary-subtle"><small class="text-primary fw-bold d-block">TOTAL LITROS</small><strong class="fs-4 text-primary"><%= o.getTotalLitros() %> L</strong></div></div>
                    <div class="col-4"><div class="p-3 bg-success-subtle rounded-4 text-center border border-success-subtle"><small class="text-success fw-bold d-block">PROMEDIO</small><strong class="fs-4 text-success"><%= o.getPromedioLitros() %> L</strong></div></div>
                    <div class="col-4"><div class="p-3 bg-secondary-subtle rounded-4 text-center border border-secondary-subtle"><small class="text-secondary fw-bold d-block">VACAS</small><strong class="fs-4 text-dark"><%= o.getTotalVacas() %></strong></div></div>
                </div>

                <% if(o.getObservaciones() != null && !o.getObservaciones().isEmpty()) { %>
                <div class="alert alert-warning border-0 rounded-4 shadow-sm mb-4">
                    <i class="bi bi-exclamation-triangle-fill text-warning me-2"></i>
                    <strong>Observaciones del Ordeño:</strong><br>
                    <span class="text-dark small"><%= o.getObservaciones().replace("\n", "<br>") %></span>
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
                                <td><span class="badge bg-primary rounded-pill fs-6 px-4 py-2 shadow-sm"><%= d.getLitrosObtenidos() %> L</span></td>
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
                <button type="button" class="btn btn-primary fw-bold px-5 rounded-pill shadow-sm" onclick="window.print()"><i class="bi bi-printer-fill me-2"></i> Imprimir Reporte</button>
            </div>
        </div>
    </div>
</div>
<%      }
    } 
%>

<!-- MODAL INTERACTIVO DE NUEVA SESIÓN -->
<div class="modal fade" id="modalSesion" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0">
            <div class="modal-header border-0 pb-0 justify-content-center position-relative mt-3">
                <h4 class="modal-title fw-bold text-dark"><i class="bi bi-droplet-half text-primary me-2"></i> Nueva Sesión de Ordeño</h4>
                <button type="button" class="btn-close position-absolute end-0 me-4" data-bs-dismiss="modal"></button>
            </div>
            
            <form action="produccion" method="POST" id="formSesion">
                <div class="modal-body px-4 py-4">
                    <div class="row g-3 mb-4 bg-light p-3 rounded-4 border">
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
                            <button type="button" class="btn btn-primary fw-bold w-100 rounded-pill shadow-sm" id="btnAgregarVaca">
                                <i class="bi bi-plus-lg"></i> Añadir a Sesión
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
                
                <div class="summary-bar p-3 d-flex justify-content-between align-items-center rounded-bottom-4 shadow-lg">
                    <div class="d-flex gap-3 gap-md-4 ms-3 flex-wrap">
                        <div><small class="text-muted fw-bold d-block text-uppercase" style="font-size: 11px;">Total Vacas</small><strong class="fs-4 text-dark" id="resVacas">0</strong></div>
                        <div><small class="text-muted fw-bold d-block text-uppercase" style="font-size: 11px;">Comercial</small><strong class="fs-4 text-primary"><span id="resLitros">0.0</span> L</strong></div>
                        <div class="d-none d-md-block"><small class="text-muted fw-bold d-block text-uppercase" style="font-size: 11px;">Promedio General</small><strong class="fs-4 text-success"><span id="resPromedio">0.0</span> L</strong></div>
                        <div><small class="text-danger fw-bold d-block text-uppercase" style="font-size: 11px;">Descarte</small><strong class="fs-4 text-danger"><span id="resDescarte">0.0</span> L</strong></div>
                    </div>
                    <div>
                        <button type="button" class="btn btn-light fw-bold px-4 rounded-pill me-2 shadow-sm" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success fw-bold px-5 rounded-pill shadow-sm" id="btnGuardar" disabled><i class="bi bi-cloud-arrow-up-fill me-2"></i> Guardar Sesión</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let now = new Date();
    document.getElementById('inputFecha').value = new Date(now.getTime() - now.getTimezoneOffset() * 60000).toISOString().slice(0,16);

    // ==============================================================
    // LÓGICA DE BIOSEGURIDAD CON SWEET ALERT 2
    // ==============================================================
    document.getElementById('btnAgregarVaca').addEventListener('click', function() {
        let select = document.getElementById('selectorVaca');
        let selectedOption = select.options[select.selectedIndex];

        if(!selectedOption.value) {
            Swal.fire({ icon: 'info', title: 'Selecciona una vaca', text: 'Debes elegir un animal de la lista primero.', confirmButtonColor: '#0d6efd' });
            return;
        }

        let id = selectedOption.value;
        let salud = selectedOption.dataset.salud;
        
        if(document.getElementById('row_vaca_' + id)) {
            Swal.fire({ icon: 'warning', title: 'Vaca duplicada', text: 'Esta vaca ya está en la mesa de ordeño.', confirmButtonColor: '#0d6efd' });
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

    // Función extraída para inyectar la fila después de la decisión
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
            ? `<span class="badge bg-danger text-white border px-3 py-2"><i class="bi bi-exclamation-triangle-fill"></i> DESCARTE</span>` 
            : `<span class="badge bg-secondary-subtle text-secondary border px-3 py-2"><i class="bi bi-clock-history"></i> ${promedio} L</span>`;
        let inputName = isDescarte ? `litros_descarte_vaca_${id}` : `litros_vaca_${id}`;
        let inputClass = isDescarte ? "form-control text-danger fw-bold input-litros-descarte shadow-sm border-danger" : "form-control text-primary fw-bold input-litros shadow-sm";

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
                <button type="button" class="btn btn-sm btn-outline-danger border-0 rounded-circle" onclick="removerVaca('${id}')" title="Quitar vaca">
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
                        badge.className = 'badge bg-success-subtle text-success border border-success-subtle ms-3 px-2 py-1 stat-badge';
                    } else if (diff < 0) {
                        badge.innerHTML = '<i class="bi bi-graph-down-arrow"></i> ' + diff.toFixed(1) + 'L';
                        badge.className = 'badge bg-danger-subtle text-danger border border-danger-subtle ms-3 px-2 py-1 stat-badge';
                    } else {
                        badge.innerHTML = '<i class="bi bi-dash-lg"></i> =';
                        badge.className = 'badge bg-secondary-subtle text-secondary border border-secondary-subtle ms-3 px-2 py-1 stat-badge';
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