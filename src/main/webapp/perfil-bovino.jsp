<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.finca.models.Bovino" %>
<%@ page import="com.finca.models.HistorialClinico" %>
<%@ page import="com.finca.models.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
    Bovino vaca = (Bovino) request.getAttribute("bovino"); 
    List<HistorialClinico> historial = (List<HistorialClinico>) request.getAttribute("historial");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd 'de' MMMM 'de' yyyy");
    String fechaActual = sdf.format(new Date());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil Bovino | Finca</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        :root {
            --brand-main: #2F855A;
            --brand-hover: #246b48;
            --apple-bg: #f5f5f7;
            --glass-bg: rgba(255, 255, 255, 0.75);
            --glass-border: rgba(255, 255, 255, 0.6);
            --glass-shadow: 0 16px 40px rgba(0, 0, 0, 0.06);
        }

        body { 
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; 
            background-color: var(--apple-bg); 
            color: #1d1d1f; 
            background-image: 
                radial-gradient(circle at 10% 20%, rgba(47, 133, 90, 0.1), transparent 30%),
                radial-gradient(circle at 90% 80%, rgba(47, 133, 90, 0.08), transparent 30%);
            background-attachment: fixed;
            min-height: 100vh;
        }
        
        .text-success { color: var(--brand-main) !important; }
        .bg-success { background-color: var(--brand-main) !important; color: white !important; }
        .btn-success { background-color: var(--brand-main); border-color: var(--brand-main); }
        .btn-success:hover { background-color: var(--brand-hover); border-color: var(--brand-hover); transform: translateY(-2px); box-shadow: 0 6px 15px rgba(47, 133, 90, 0.25); }
        .btn-outline-success { color: var(--brand-main); border-color: var(--brand-main); }
        .btn-outline-success:hover { background-color: var(--brand-main); color: white; }
        .bg-success-subtle { background-color: rgba(47, 133, 90, 0.12) !important; }
        
        .glass-panel {
            background: var(--glass-bg);
            backdrop-filter: blur(24px) saturate(180%);
            -webkit-backdrop-filter: blur(24px) saturate(180%);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            box-shadow: var(--glass-shadow);
        }

        .profile-img {
            width: 200px;
            height: 200px;
            object-fit: cover;
            border-radius: 24px;
            border: 4px solid #ffffff;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .profile-img:hover { transform: scale(1.05) translateY(-5px); }
        .profile-placeholder {
            width: 200px;
            height: 200px;
            border-radius: 24px;
            background: rgba(0,0,0,0.04);
            border: 2px dashed rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 70px;
            color: rgba(0,0,0,0.3);
        }

        .table-custom-wrapper { border-radius: 18px; overflow: hidden; background: rgba(255,255,255,0.4); border: 1px solid var(--glass-border); }
        .table { margin-bottom: 0; background: transparent; }
        .table th { white-space: nowrap; font-weight: 700; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; padding: 18px 15px; border-bottom: 1px solid rgba(0,0,0,0.05); background-color: rgba(255,255,255,0.6); color: #6c757d;}
        .table td { vertical-align: middle; padding: 16px 15px; color: #495057; font-size: 0.95rem; border-bottom: 1px solid rgba(0,0,0,0.03); background: transparent; }
        .table-hover tbody tr { transition: all 0.2s ease; }
        .table-hover tbody tr:hover td { background-color: rgba(255,255,255,0.9); }
        
        .modal-content {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(40px) saturate(200%);
            -webkit-backdrop-filter: blur(40px) saturate(200%);
            border: 1px solid rgba(255, 255, 255, 0.8);
            border-radius: 28px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.15);
        }
        
        .form-control, .form-select {
            border-radius: 16px;
            padding: 14px 18px;
            background: rgba(255, 255, 255, 0.7);
            border: 1px solid rgba(0, 0, 0, 0.06);
            color: #1d1d1f;
            transition: all 0.3s ease;
        }
        .form-control:focus, .form-select:focus {
            background: #ffffff;
            border-color: var(--brand-main);
            box-shadow: 0 0 0 4px rgba(47, 133, 90, 0.15);
            outline: none;
        }

        @media print {
            body * { visibility: hidden; }
            #modalInforme .modal-content, #modalInforme .modal-content * { visibility: visible; }
            #modalInforme .modal-content { 
                position: absolute; 
                left: 0; 
                top: 0; 
                width: 100vw; 
                background: white !important; 
                border: none !important; 
                box-shadow: none !important; 
                backdrop-filter: none !important;
                border-radius: 0;
            }
            .btn-close, .modal-footer, .no-print { display: none !important; }
            .print-header { display: block !important; border-bottom: 2px solid #2F855A; margin-bottom: 20px; padding-bottom: 10px; }
            .badge { border: 1px solid #000; color: #000 !important; background: transparent !important; }
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container py-4">
    <div class="mb-4">
        <a href="inventario-ganado" class="btn btn-light fw-bold shadow-sm" style="border-radius: 14px; color: #555; background: rgba(255,255,255,0.8);">
            <i class="bi bi-arrow-left me-2"></i> Volver al Inventario
        </a>
    </div>

    <% if(request.getAttribute("successMessage") != null) { %>
        <div class="alert alert-success alert-dismissible fade show glass-panel border-0 border-start border-5 border-success mb-4">
            <i class="bi bi-check-circle-fill me-2 fs-5"></i> <strong>¡Éxito!</strong> <%= request.getAttribute("successMessage") %>
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>
    <% if(request.getParameter("error") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show glass-panel border-0 border-start border-5 border-danger mb-4">
            <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i> <strong>Error:</strong> Hubo un error al registrar el evento médico.
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <div class="row g-4">
        <!-- TARJETA DEL PERFIL DEL ANIMAL -->
        <div class="col-lg-4">
            <div class="glass-panel text-center p-4 h-100 d-flex flex-column align-items-center">
                <% if(vaca.getImageUrl() != null && !vaca.getImageUrl().trim().isEmpty() && !vaca.getImageUrl().equals("null")) { %>
                    <img src="<%= request.getContextPath() %>/<%= vaca.getImageUrl() %>" class="profile-img mx-auto mb-3" onerror="this.src='https://placehold.co/200x200/e9ecef/a3a3a3?text=Sin+Foto'">
                <% } else { %>
                    <div class="profile-placeholder mx-auto mb-3"><i class="bi bi-camera"></i></div>
                <% } %>
                
                <div class="d-flex align-items-center justify-content-center gap-2 mb-1">
                    <h2 class="fw-bold text-success mb-0"><%= vaca.getNumeroArete() %></h2>
                    <!-- Icono mejorado del Género -->
                    <i class="bi <%= vaca.getGenero().equals("Hembra") ? "bi-gender-female text-danger" : "bi-gender-male text-primary" %> fs-3"></i>
                </div>
                <h5 class="text-muted fw-semibold mb-3"><%= vaca.getRaza() %> • <%= vaca.getEdadAnios() %> años</h5>

                <button class="btn btn-outline-success fw-bold rounded-pill w-100 mb-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalInforme">
                    <i class="bi bi-file-earmark-text-fill me-1"></i> Ver Informe Completo
                </button>
                
                <div class="w-100 p-4 rounded-4 shadow-sm border border-light text-start mt-auto" style="background: rgba(255,255,255,0.6);">
                    <p class="mb-3 d-flex justify-content-between border-bottom border-light pb-2">
                        <span class="text-muted fw-bold small text-uppercase"><i class="bi bi-tag-fill me-2 text-success"></i> Grupo</span>
                        <span class="fw-bold text-dark"><%= vaca.getClasificacion() %></span>
                    </p>
                    <p class="mb-3 d-flex justify-content-between border-bottom border-light pb-2">
                        <span class="text-muted fw-bold small text-uppercase"><i class="bi bi-speedometer me-2 text-primary"></i> Peso</span>
                        <span class="fw-bold text-dark"><%= vaca.getPesoKg() %> Kg</span>
                    </p>
                    <p class="mb-3 d-flex justify-content-between border-bottom border-light pb-2 align-items-center">
                        <span class="text-muted fw-bold small text-uppercase"><i class="bi bi-heart-pulse-fill me-2 text-danger"></i> Salud</span>
                        <span class="badge <%= vaca.getEstadoSalud().equals("Sano") || vaca.getEstadoSalud().equals("Sana") ? "bg-success" : (vaca.getEstadoSalud().equals("En Tratamiento") ? "bg-warning text-dark" : "bg-danger") %> rounded-pill px-3 py-1">
                            <%= vaca.getEstadoSalud() %>
                        </span>
                    </p>
                    
                    <!-- LÓGICA BIOLÓGICA VISUAL: Si es Macho oculta los partos -->
                    <% if("Hembra".equals(vaca.getGenero())) { %>
                        <p class="mb-0 d-flex justify-content-between">
                            <span class="text-muted fw-bold small text-uppercase"><i class="bi bi-clipboard2-plus-fill me-2 text-info"></i> Partos</span>
                            <span class="fw-bold text-dark"><%= vaca.getNumeroPartos() %></span>
                        </p>
                    <% } else { %>
                        <p class="mb-0 d-flex justify-content-between">
                            <span class="text-muted fw-bold small text-uppercase"><i class="bi bi-bullseye me-2 text-secondary"></i> Propósito</span>
                            <span class="fw-bold text-dark"><%= vaca.getProposito() %></span>
                        </p>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- HISTORIAL CLÍNICO -->
        <div class="col-lg-8">
            <div class="glass-panel p-4 h-100">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mb-4 pb-3 border-bottom border-light">
                    <h4 class="fw-bold text-dark mb-3 mb-md-0"><i class="bi bi-journal-medical text-success me-2"></i> Historial Clínico</h4>
                    <button class="btn btn-success btn-lg fw-bold shadow-sm rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#modalEventoMedico">
                        <i class="bi bi-plus-circle-fill me-1"></i> Nuevo Evento
                    </button>
                </div>

                <div class="table-responsive table-custom-wrapper shadow-sm">
                    <table class="table table-hover align-middle">
                        <thead class="text-center">
                            <tr>
                                <th>Fecha</th>
                                <th>Tipo</th>
                                <th>Descripción Médica</th>
                                <th>Atendido Por</th>
                            </tr>
                        </thead>
                        <tbody class="text-center">
                            <% 
                                if(historial != null && !historial.isEmpty()) {
                                    for(HistorialClinico h : historial) {
                                        String badge = "bg-secondary";
                                        if(h.getTipoEvento().equals("Vacuna")) badge = "bg-success";
                                        if(h.getTipoEvento().equals("Enfermedad")) badge = "bg-danger";
                                        if(h.getTipoEvento().equals("Suplemento")) badge = "bg-info text-dark";
                                        if(h.getTipoEvento().equals("Parto")) badge = "bg-warning text-dark";
                            %>
                            <tr>
                                <td class="fw-bold text-dark"><%= h.getFechaEvento() %></td>
                                <td><span class="badge <%= badge %> rounded-pill px-3 py-2"><%= h.getTipoEvento() %></span></td>
                                <td class="text-muted text-start ps-4"><%= h.getDescripcion() %></td>
                                <td>
                                    <div class="d-inline-flex align-items-center border rounded-pill px-3 py-1 shadow-sm small" style="background: rgba(255,255,255,0.7);">
                                        <i class="bi bi-person-circle text-success me-2"></i> 
                                        <span class="fw-semibold text-dark"><%= h.getNombreVeterinario() != null ? h.getNombreVeterinario() : "Sin asignar" %></span>
                                    </div>
                                </td>
                            </tr>
                            <% }} else { %>
                            <tr><td colspan="4" class="text-center py-5 text-muted"><i class="bi bi-journal-x fs-1 d-block mb-3 opacity-50"></i>No hay registros médicos para este animal.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ================= MODAL ESTILO APPLE: REGISTRAR EVENTO MÉDICO Y PARTO ================= -->
<div class="modal fade" id="modalEventoMedico" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0">
            
            <div class="modal-header border-0 pb-0 justify-content-center position-relative mt-3">
                <h4 class="modal-title fw-bold text-dark"><i class="bi bi-heart-pulse-fill text-success me-2"></i> Nuevo Evento</h4>
                <button type="button" class="btn-close position-absolute end-0 me-4" data-bs-dismiss="modal" style="top: 50%; transform: translateY(-50%);"></button>
            </div>
            
            <form action="perfil-bovino" method="POST" id="formNuevoEvento">
                <input type="hidden" name="idBovino" value="<%= vaca.getIdBovino() %>">
                <input type="hidden" name="nuevoEstadoSalud" id="nuevoEstadoSalud" value="">
                
                <div class="modal-body px-4 py-4">
                    
                    <div class="mb-4">
                        <label class="form-label text-muted fw-bold small text-uppercase ms-1">Veterinario / Responsable</label>
                        <select name="veterinarioId" class="form-select shadow-sm" required>
                            <option value="" disabled selected>Seleccione el encargado del procedimiento...</option>
                            <% 
                               List<Usuario> listaEmpleados = (List<Usuario>) request.getAttribute("listaEmpleados");
                               boolean tieneVeterinarios = false;
                               
                               if(listaEmpleados != null && !listaEmpleados.isEmpty()) {
                                   for(Usuario emp : listaEmpleados) {
                                       if(emp.getRol() != null && emp.getRol().equals("Veterinario")) {
                                           tieneVeterinarios = true;
                            %>
                                           <option value="<%= emp.getId() %>">🧑‍⚕️ <%= emp.getFullName() %></option>
                            <%         }
                                   }
                               } 
                               if (!tieneVeterinarios) { 
                            %>
                                   <option value="" disabled>⚠️ No hay veterinarios registrados en el sistema</option>
                            <% } %>
                        </select>
                        <small class="text-muted ms-1" style="font-size: 11px;">Solo se mostrarán empleados registrados con el rol de Veterinario.</small>
                    </div>

                    <div class="mb-4">
                        <label class="form-label text-muted fw-bold small text-uppercase ms-1">Fecha del Evento</label>
                        <input type="date" name="fechaEvento" class="form-control shadow-sm" required>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label text-muted fw-bold small text-uppercase ms-1">Tipo de Evento</label>
                        <select name="tipoEvento" id="tipoEventoSelect" class="form-select shadow-sm" required>
                            <option value="Vacuna">Vacuna</option>
                            <option value="Enfermedad">Enfermedad / Tratamiento</option>
                            <option value="Suplemento">Suplemento / Vitamina</option>
                            <option value="Control">Control General</option>
                            <!-- Los machos no paren, así que la opción de Parto se ocultará vía JS si es macho -->
                            <option value="Parto" id="opcionParto">Registro de Parto</option>
                        </select>
                    </div>

                    <!-- DETALLES DE PARTO Y REGISTRO AUTOMÁTICO DE CRÍA -->
                    <div id="detallesParto" class="d-none bg-light p-3 rounded-4 mb-4 border border-secondary-subtle">
                        <h6 class="fw-bold text-dark mb-3"><i class="bi bi-gender-ambiguous text-primary me-1"></i> Detalles del Parto</h6>
                        
                        <div class="row g-3 mb-3">
                            <div class="col-12">
                                <label class="small text-muted fw-bold text-uppercase ms-1">Estado de la Cría</label>
                                <select name="partoEstado" id="partoEstado" class="form-select shadow-sm border-0">
                                    <option value="" disabled selected>Seleccione...</option>
                                    <option value="Nació Vivo">Nació Vivo (Registrar Cría)</option>
                                    <option value="Nació Muerto">Nació Muerto</option>
                                </select>
                            </div>
                        </div>
                        
                        <div id="formRegistroCria" class="row g-3 border-top pt-2 mt-1 d-none">
                            <div class="col-12"><small class="text-success fw-bold"><i class="bi bi-check-circle-fill"></i> Se insertará automáticamente en el Inventario</small></div>
                            <div class="col-6">
                                <label class="small text-muted fw-bold text-uppercase ms-1">Arete Cría</label>
                                <input type="text" name="criaArete" id="criaArete" class="form-control form-control-sm shadow-sm border-0" placeholder="Ej: V-008">
                            </div>
                            <div class="col-6">
                                <label class="small text-muted fw-bold text-uppercase ms-1">Sexo</label>
                                <select name="criaGenero" id="partoGenero" class="form-select form-select-sm shadow-sm border-0">
                                    <option value="Hembra" selected>Hembra</option>
                                    <option value="Macho">Macho</option>
                                </select>
                            </div>
                            <div class="col-4">
                                <label class="small text-muted fw-bold text-uppercase ms-1">Peso (Kg)</label>
                                <input type="number" step="0.01" name="criaPeso" id="criaPeso" class="form-control form-control-sm shadow-sm border-0" placeholder="Ej: 35">
                            </div>
                            <div class="col-4">
                                <label class="small text-muted fw-bold text-uppercase ms-1">Raza</label>
                                <input type="text" name="criaRaza" id="criaRaza" class="form-control form-control-sm shadow-sm border-0" value="<%= vaca.getRaza() %>">
                            </div>
                            <div class="col-4">
                                <label class="small text-muted fw-bold text-uppercase ms-1">Propósito</label>
                                <select name="criaProposito" id="criaProposito" class="form-select form-select-sm shadow-sm border-0">
                                    <option value="Leche">Leche</option>
                                    <option value="Doble Propósito">Doble Prop.</option>
                                    <option value="Carne">Carne</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div id="alertaEstado" class="alert alert-warning border-0 shadow-sm d-none align-items-center mb-4" style="border-radius: 16px; background: rgba(255, 193, 7, 0.15); color: #856404;">
                        <i class="bi bi-info-circle-fill fs-5 me-2"></i>
                        <small>El estado de salud cambiará automáticamente a <strong>En Tratamiento</strong>.</small>
                    </div>

                    <div class="mb-2">
                        <label class="form-label text-muted fw-bold small text-uppercase ms-1">Descripción Médica / Observaciones</label>
                        <textarea name="descripcion" id="descripcionEvento" class="form-control shadow-sm" rows="4" placeholder="Ej: Aplicación de medicina. El animal está en observación." required style="border-radius: 18px;"></textarea>
                    </div>
                </div>
                
                <div class="modal-footer border-0 pt-0 pb-4 px-4 d-flex justify-content-between">
                    <button type="button" class="btn btn-light fw-bold px-4 rounded-pill shadow-sm" data-bs-dismiss="modal" style="background: rgba(255,255,255,0.6); color: #555;">Cancelar</button>
                    <button type="submit" class="btn btn-success fw-bold px-5 rounded-pill shadow-sm"><i class="bi bi-save-fill me-2"></i> Guardar Registro</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ================= MODAL DE INFORME IMPRIMIBLE ================= -->
<div class="modal fade" id="modalInforme" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0">
            <div class="modal-header border-0 pb-0 justify-content-center position-relative mt-3 no-print">
                <h4 class="modal-title fw-bold text-dark"><i class="bi bi-file-earmark-text-fill text-success me-2"></i> Informe Bovino</h4>
                <button type="button" class="btn-close position-absolute end-0 me-4" data-bs-dismiss="modal"></button>
            </div>
            
            <div class="modal-body px-4 py-4" id="areaInforme">
                <!-- Encabezado visible solo al imprimir -->
                <div class="print-header d-none text-center mb-4">
                    <h2 class="fw-bold" style="color: #2F855A;">FINCA LA ROSA</h2>
                    <h4 class="text-dark">Informe Clínico y Productivo</h4>
                    <p class="text-muted mb-0">Generado en Sogamoso, Boyacá el <%= fechaActual %></p>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-md-4 text-center">
                        <% if(vaca.getImageUrl() != null && !vaca.getImageUrl().trim().isEmpty() && !vaca.getImageUrl().equals("null")) { %>
                            <img src="<%= request.getContextPath() %>/<%= vaca.getImageUrl() %>" class="rounded-4 border" style="width: 150px; height: 150px; object-fit: cover;" onerror="this.src='https://placehold.co/150x150/e9ecef/a3a3a3?text=🐮'">
                        <% } else { %>
                            <div class="rounded-4 bg-light border d-flex align-items-center justify-content-center mx-auto" style="width: 150px; height: 150px; font-size: 50px; color: #ccc;"><i class="bi bi-camera"></i></div>
                        <% } %>
                    </div>
                    <div class="col-md-8">
                        <h3 class="fw-bold text-success mb-3">Identificación: <%= vaca.getNumeroArete() %></h3>
                        <div class="row g-3">
                            <div class="col-6"><span class="text-muted fw-bold small text-uppercase">Raza:</span> <strong class="d-block text-dark"><%= vaca.getRaza() %></strong></div>
                            <div class="col-6"><span class="text-muted fw-bold small text-uppercase">Género:</span> <strong class="d-block text-dark"><%= vaca.getGenero() %></strong></div>
                            <div class="col-6"><span class="text-muted fw-bold small text-uppercase">Nacimiento:</span> <strong class="d-block text-dark"><%= vaca.getFechaNacimiento() %> (<%= vaca.getEdadAnios() %> años)</strong></div>
                            <div class="col-6"><span class="text-muted fw-bold small text-uppercase">Clasificación:</span> <strong class="d-block text-dark"><%= vaca.getClasificacion() %></strong></div>
                        </div>
                    </div>
                </div>

                <h5 class="fw-bold border-bottom pb-2 mb-3 mt-4 text-success">Datos Productivos y de Salud</h5>
                <div class="row g-3 mb-4">
                    <% String colSize = "Hembra".equals(vaca.getGenero()) ? "col-3" : "col-6"; %>
                    <div class="<%= colSize %>"><div class="p-3 bg-light rounded-4 text-center border"><small class="text-muted fw-bold d-block">PESO</small><strong class="fs-5 text-dark"><%= vaca.getPesoKg() %> Kg</strong></div></div>
                    <div class="<%= colSize %>"><div class="p-3 bg-light rounded-4 text-center border"><small class="text-muted fw-bold d-block">SALUD</small><strong class="fs-5 text-dark"><%= vaca.getEstadoSalud() %></strong></div></div>
                    <% if("Hembra".equals(vaca.getGenero())) { %>
                    <div class="col-3"><div class="p-3 bg-light rounded-4 text-center border"><small class="text-muted fw-bold d-block">PRODUCCIÓN</small><strong class="fs-5 text-dark"><%= vaca.getLitrosDiariosPromedio() %> L</strong></div></div>
                    <div class="col-3"><div class="p-3 bg-light rounded-4 text-center border"><small class="text-muted fw-bold d-block">PARTOS</small><strong class="fs-5 text-dark"><%= vaca.getNumeroPartos() %></strong></div></div>
                    <% } %>
                </div>

                <h5 class="fw-bold border-bottom pb-2 mb-3 mt-4 text-success">Historial de Eventos Médicos</h5>
                <table class="table table-bordered table-sm text-start" style="font-size: 0.9rem;">
                    <thead class="table-light text-secondary">
                        <tr>
                            <th>Fecha</th>
                            <th>Tipo</th>
                            <th>Descripción</th>
                            <th>Veterinario</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(historial != null && !historial.isEmpty()) {
                            for(HistorialClinico h : historial) { %>
                        <tr>
                            <td class="fw-bold text-dark"><%= h.getFechaEvento() %></td>
                            <td><%= h.getTipoEvento() %></td>
                            <td><%= h.getDescripcion() %></td>
                            <td><%= h.getNombreVeterinario() != null ? h.getNombreVeterinario() : "N/A" %></td>
                        </tr>
                        <% }} else { %>
                        <tr><td colspan="4" class="text-center text-muted">Sin registros médicos.</td></tr>
                        <% } %>
                    </tbody>
                </table>
                <div class="text-end mt-4 print-header d-none">
                    <br><br><br>
                    <p class="mb-0">___________________________________</p>
                    <p class="text-muted small fw-bold">Firma del Administrador / Veterinario</p>
                </div>
            </div>
            
            <div class="modal-footer border-0 pt-0 pb-4 px-4 d-flex justify-content-between no-print">
                <button type="button" class="btn btn-light fw-bold px-4 rounded-pill shadow-sm" data-bs-dismiss="modal" style="background: rgba(255,255,255,0.6); color: #555;">Cerrar</button>
                <button type="button" class="btn btn-success fw-bold px-5 rounded-pill shadow-sm" onclick="window.print()"><i class="bi bi-printer-fill me-2"></i> Imprimir Reporte</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const generoVaca = "<%= vaca.getGenero() %>";
    
    // Validar visualmente si es Macho, quitamos la opción de Parto
    if (generoVaca === "Macho") {
        let opParto = document.getElementById('opcionParto');
        if(opParto) opParto.remove();
    }

    // ==========================================
    // ¡NUEVA LÓGICA BIOLÓGICA PARA LA CRÍA!
    // ==========================================
    document.getElementById('partoGenero').addEventListener('change', function() {
        let selectProposito = document.getElementById('criaProposito');
        if (this.value === 'Macho') {
            // Si el ternero es macho, no puede dar leche
            Array.from(selectProposito.options).forEach(opt => {
                opt.disabled = (opt.value === 'Leche' || opt.value === 'Doble Propósito');
            });
            selectProposito.value = 'Carne'; // Se fuerza a carne
        } else {
            // Si es hembra, liberamos las opciones
            Array.from(selectProposito.options).forEach(opt => { opt.disabled = false; });
        }
    });
    // ==========================================


    // Lógica inteligente para desplegar campos
    document.getElementById('tipoEventoSelect').addEventListener('change', function() {
        let alerta = document.getElementById('alertaEstado');
        let inputEstado = document.getElementById('nuevoEstadoSalud');
        let detallesParto = document.getElementById('detallesParto');
        
        let criaArete = document.getElementById('criaArete');
        let criaPeso = document.getElementById('criaPeso');
        
        alerta.classList.add('d-none'); alerta.classList.remove('d-flex');
        inputEstado.value = '';
        detallesParto.classList.add('d-none');
        criaArete.required = false;
        criaPeso.required = false;
        
        if (this.value === 'Enfermedad') {
            alerta.classList.remove('d-none');
            alerta.classList.add('d-flex');
            inputEstado.value = 'En Tratamiento';
        } else if (this.value === 'Parto') {
            detallesParto.classList.remove('d-none');
            document.getElementById('partoEstado').required = true;
            // Forzamos el chequeo biológico al abrir el modal
            document.getElementById('partoGenero').dispatchEvent(new Event('change'));
        }
    });

    document.getElementById('partoEstado').addEventListener('change', function() {
        let formCria = document.getElementById('formRegistroCria');
        let criaArete = document.getElementById('criaArete');
        let criaPeso = document.getElementById('criaPeso');
        
        if(this.value === 'Nació Vivo') {
            formCria.classList.remove('d-none');
            criaArete.required = true;
            criaPeso.required = true;
        } else {
            formCria.classList.add('d-none');
            criaArete.required = false;
            criaPeso.required = false;
        }
    });

    document.getElementById('formNuevoEvento').addEventListener('submit', function(e) {
        let tipo = document.getElementById('tipoEventoSelect').value;
        if(tipo === 'Parto') {
            let estado = document.getElementById('partoEstado').value;
            let descArea = document.getElementById('descripcionEvento');
            
            let textoExtra = "PARTO: " + estado + ".";
            if(estado === 'Nació Vivo') {
                let genero = document.getElementById('partoGenero').value;
                let arete = document.getElementById('criaArete').value;
                textoExtra += " Cría: " + genero + " (Arete: " + arete + ").";
            }
            descArea.value = textoExtra + " Observaciones: " + descArea.value;
        }
    });
</script>
</body>
</html>