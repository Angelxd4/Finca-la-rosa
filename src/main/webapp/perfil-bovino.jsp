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
    <jsp:include page="includes/header.jsp" />
    <title>Perfil Bovino | Finca La Rosa</title>
    
    <style>
        /* AESTHETICS - PREMIUM DESIGN */
        :root {
            --glass-bg: rgba(255, 255, 255, 0.6);
            --glass-border: rgba(255, 255, 255, 0.4);
            --glass-shadow: 0 8px 32px 0 rgba(66, 57, 38, 0.1);
        }
        
        body {
            background: linear-gradient(135deg, #F3F5E7 0%, #e0e5d1 100%) !important;
        }

        .panel-finca {
            background: var(--glass-bg) !important;
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid var(--glass-border) !important;
            border-radius: 28px;
            box-shadow: var(--glass-shadow);
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .panel-finca:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px 0 rgba(66, 57, 38, 0.15);
        }

        .profile-img-container {
            position: relative;
            width: 220px;
            height: 220px;
            margin: 0 auto;
            border-radius: 50%;
            padding: 8px;
            background: linear-gradient(135deg, var(--brand-primary), var(--brand-accent));
            box-shadow: 0 10px 25px rgba(66, 57, 38, 0.2);
            transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        
        .profile-img-container:hover {
            transform: scale(1.05) rotate(2deg);
        }

        .profile-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid #fff;
            background-color: #fff;
        }
        
        .profile-placeholder {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background: var(--bg-page);
            border: 4px solid #fff;
            display: flex; align-items: center; justify-content: center;
            font-size: 70px; color: var(--brand-info);
        }

        .info-card {
            background: rgba(255, 255, 255, 0.8);
            border-radius: 16px;
            padding: 16px;
            margin-bottom: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid rgba(255, 255, 255, 0.5);
            box-shadow: 0 4px 10px rgba(0,0,0,0.02);
            transition: all 0.2s;
        }
        .info-card:hover {
            background: #fff;
            transform: scale(1.02);
        }

        /* TABLA DE HISTORIAL */
        .table-custom-wrapper { 
            border-radius: 20px; 
            overflow: hidden; 
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
        }
        .table { margin-bottom: 0; }
        .table th { font-weight: 800; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 1px; padding: 20px 15px; border-bottom: none !important; background-color: var(--brand-dark) !important; color: #fff !important;}
        .table td { vertical-align: middle; padding: 18px 15px; color: var(--text-main); font-size: 0.95rem; border-bottom: 1px solid rgba(0,0,0,0.05); }
        .table tbody tr { transition: all 0.2s; }
        .table tbody tr:hover { background-color: rgba(255,255,255, 0.9) !important; transform: scale(1.01); box-shadow: 0 4px 10px rgba(0,0,0,0.05); z-index: 10; position: relative; }
        
        /* BOTONES */
        .btn-brand, .btn-accent {
            border-radius: 16px !important;
            padding: 12px 24px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.9rem;
        }
        
        .badge-status {
            padding: 8px 16px;
            border-radius: 12px;
            font-weight: 700;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
        }

        @media print {
            body * { visibility: hidden; }
            #modalInforme .modal-content, #modalInforme .modal-content * { visibility: visible; }
            #modalInforme .modal-content { 
                position: absolute; left: 0; top: 0; width: 100vw; background: white !important; 
                border: none !important; box-shadow: none !important; border-radius: 0;
            }
            .btn-close, .modal-footer, .no-print { display: none !important; }
            .print-header { display: block !important; border-bottom: 3px solid var(--brand-primary); margin-bottom: 20px; padding-bottom: 10px; }
            .badge { border: 1px solid #000; color: #000 !important; background: transparent !important; }
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container py-5">
    
    <div class="mb-4">
        <a href="inventario-ganado" class="btn btn-outline-brand fw-bold px-4">
            <i class="bi bi-arrow-left me-2"></i> Volver al Inventario
        </a>
    </div>

    <% if(request.getAttribute("successMessage") != null) { %>
        <div class="alert alert-success alert-dismissible fade show border-0 border-start border-5 shadow-sm rounded-3 mb-4 bg-white" style="border-color: var(--brand-info) !important;">
            <i class="bi bi-check-circle-fill me-2 fs-5" style="color: var(--brand-info);"></i> <strong class="text-dark">¡Éxito!</strong> <%= request.getAttribute("successMessage") %>
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>
    <% if(request.getParameter("error") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show border-0 border-start border-5 border-danger shadow-sm rounded-3 mb-4 bg-white">
            <i class="bi bi-exclamation-triangle-fill text-danger me-2 fs-5"></i> <strong class="text-dark">Error:</strong> Hubo un error al registrar el evento médico.
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <div class="row g-4 align-items-stretch">
        
        <div class="col-lg-4">
            <div class="panel-finca text-center p-4 h-100 d-flex flex-column align-items-center">
                
                <div class="profile-img-container mb-4 mt-3">
                    <% if(vaca.getImageUrl() != null && !vaca.getImageUrl().trim().isEmpty() && !vaca.getImageUrl().equals("null")) { %>
                        <img src="<%= request.getContextPath() %>/<%= vaca.getImageUrl() %>" class="profile-img" onerror="this.src='https://placehold.co/200x200/F3F5E7/9CA889?text=Sin+Foto'">
                    <% } else { %>
                        <div class="profile-placeholder"><i class="bi bi-camera"></i></div>
                    <% } %>
                </div>
                
                <div class="d-flex align-items-center justify-content-center gap-2 mb-1">
                    <h2 class="fw-bolder text-brand mb-0" style="font-size: 2.2rem;"><%= vaca.getNumeroArete() %></h2>
                    <i class="bi <%= vaca.getGenero().equals("Hembra") ? "bi-gender-female text-danger" : "bi-gender-male" %> fs-3" style="<%= vaca.getGenero().equals("Macho") ? "color: var(--brand-info);" : "" %>"></i>
                </div>
                <h5 class="text-subtle fw-bold mb-4 px-3 py-1 bg-light rounded-pill border"><%= vaca.getRaza() %> • <%= vaca.getEdadAnios() %> años</h5>

                <button class="btn btn-accent w-100 mb-4 py-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalInforme">
                    <i class="bi bi-printer-fill me-2 fs-5 align-middle"></i> Generar Ficha Clínica
                </button>
                
                <div class="w-100 mt-auto">
                    <div class="info-card">
                        <span class="text-subtle fw-bold small text-uppercase"><i class="bi bi-tag-fill me-2 fs-5 align-middle text-brand"></i> Grupo</span>
                        <span class="fw-bolder text-dark fs-5"><%= vaca.getClasificacion() %></span>
                    </div>
                    
                    <div class="info-card">
                        <span class="text-subtle fw-bold small text-uppercase"><i class="bi bi-speedometer me-2 fs-5 align-middle text-brand"></i> Peso</span>
                        <span class="fw-bolder text-dark fs-5"><%= vaca.getPesoKg() %> Kg</span>
                    </div>
                    
                    <div class="info-card">
                        <span class="text-subtle fw-bold small text-uppercase"><i class="bi bi-heart-pulse-fill me-2 fs-5 align-middle text-danger"></i> Salud</span>
                        <span class="badge-status <%= vaca.getEstadoSalud().equals("Sano") || vaca.getEstadoSalud().equals("Sana") ? "bg-success text-white" : (vaca.getEstadoSalud().equals("En Tratamiento") ? "bg-warning text-dark" : "bg-danger text-white") %>">
                            <%= vaca.getEstadoSalud() %>
                        </span>
                    </div>
                    
                    <% if("Hembra".equals(vaca.getGenero())) { %>
                        <div class="info-card">
                            <span class="text-subtle fw-bold small text-uppercase"><i class="bi bi-clipboard2-plus-fill me-2 fs-5 align-middle text-brand"></i> Partos</span>
                            <span class="fw-bolder text-dark fs-5"><%= vaca.getNumeroPartos() %></span>
                        </div>
                    <% } else { %>
                        <div class="info-card">
                            <span class="text-subtle fw-bold small text-uppercase"><i class="bi bi-bullseye me-2 fs-5 align-middle text-brand"></i> Propósito</span>
                            <span class="fw-bolder text-dark fs-5"><%= vaca.getProposito() %></span>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="panel-finca p-4 h-100">
                
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mb-4 pb-3 border-bottom" style="border-color: var(--border-subtle) !important;">
                    <h4 class="fw-bolder text-brand mb-3 mb-md-0"><i class="bi bi-journal-medical me-2"></i> Historial Clínico</h4>
                    <button class="btn btn-brand px-4 py-2" data-bs-toggle="modal" data-bs-target="#modalEventoMedico">
                        <i class="bi bi-plus-lg me-1"></i> Registrar Evento
                    </button>
                </div>

                <div class="table-responsive table-custom-wrapper">
                    <table class="table table-hover align-middle" id="tableHistorial">
                        <thead class="text-center">
                            <tr>
                                <th width="15%">Fecha</th>
                                <th width="20%">Tipo</th>
                                <th width="40%">Descripción Médica</th>
                                <th width="25%">Atendido Por</th>
                            </tr>
                        </thead>
                        <tbody class="text-center">
                            <% 
                                if(historial != null && !historial.isEmpty()) {
                                    for(HistorialClinico h : historial) {
                                        // Estilos para los badges mapeados a la nueva paleta
                                        String badgeStyle = "background-color: var(--border-subtle); color: var(--text-main);";
                                        if(h.getTipoEvento().equals("Vacuna")) badgeStyle = "background-color: var(--brand-info); color: white;"; 
                                        if(h.getTipoEvento().equals("Enfermedad")) badgeStyle = "background-color: #dc3545; color: white;"; 
                                        if(h.getTipoEvento().equals("Suplemento")) badgeStyle = "background-color: var(--brand-accent); color: var(--brand-dark);"; 
                                        if(h.getTipoEvento().equals("Parto")) badgeStyle = "background-color: var(--brand-primary); color: white;"; 
                                        if(h.getTipoEvento().equals("Control")) badgeStyle = "background-color: var(--brand-dark); color: white;"; 
                            %>
                            <tr>
                                <td class="fw-bold text-dark"><%= h.getFechaEvento() %></td>
                                <td><span class="badge rounded-pill px-3 py-2 fw-bold w-100" style="<%= badgeStyle %>"><%= h.getTipoEvento() %></span></td>
                                <td class="text-subtle text-start ps-3" style="font-size: 0.9rem;"><%= h.getDescripcion() %></td>
                                <td>
                                    <div class="d-inline-flex align-items-center border rounded-pill px-3 py-1 bg-light small fw-bold text-dark" style="background-color: var(--bg-page) !important; border-color: var(--border-subtle) !important;">
                                        <i class="bi bi-person-circle text-brand me-2"></i> 
                                        <%= h.getNombreVeterinario() != null ? h.getNombreVeterinario() : "N/A" %>
                                    </div>
                                </td>
                            </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <% if("Producción".equals(vaca.getClasificacion())) { %>
            <div class="panel-finca p-4 mt-4 mb-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-3 pb-2 border-bottom" style="border-color: var(--border-subtle) !important;">
                    <h5 class="fw-bolder text-brand mb-0"><i class="bi bi-graph-up-arrow me-2 text-info"></i> Analítica: Curva de Lactancia Ideal vs Real</h5>
                    <span class="badge bg-light text-dark border"><i class="bi bi-info-circle me-1"></i> Basado en modelo de 305 días</span>
                </div>
                <div id="lactanciaChart" style="height: 320px;"></div>
            </div>
            <% } %>
            
        </div>
    </div>
</div>

<div class="modal fade" id="modalEventoMedico" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0">
            
            <div class="modal-header border-bottom pb-3 px-4 mt-2" style="border-color: var(--border-subtle) !important;">
                <h4 class="modal-title fw-bolder text-brand"><i class="bi bi-heart-pulse-fill me-2" style="color: var(--brand-info);"></i> Nuevo Evento</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            
            <form action="perfil-bovino" method="POST" id="formNuevoEvento">
                <input type="hidden" name="idBovino" value="<%= vaca.getIdBovino() %>">
                <input type="hidden" name="nuevoEstadoSalud" id="nuevoEstadoSalud" value="">
                
                <div class="modal-body px-4 py-4" style="background-color: var(--bg-card);">
                    
                    <div class="mb-4">
                        <label class="form-label text-brand fw-bold small text-uppercase ms-1">Veterinario Encargado</label>
                        <select name="veterinarioId" class="form-select shadow-sm" required>
                            <option value="" disabled selected>Seleccione al profesional...</option>
                            <% 
                               List<Usuario> listaEmpleados = (List<Usuario>) request.getAttribute("listaEmpleados");
                               boolean tieneVeterinarios = false;
                               
                               if(listaEmpleados != null && !listaEmpleados.isEmpty()) {
                                   for(Usuario emp : listaEmpleados) {
                                       // LÓGICA CORREGIDA: Detectar si el rol es "2" o "Veterinario"
                                       if(emp.getRol() != null && (emp.getRol().equals("2") || emp.getRol().equalsIgnoreCase("Veterinario"))) {
                                           tieneVeterinarios = true;
                            %>
                                           <option value="<%= emp.getId() %>">Vet: <%= emp.getFullName() %></option>
                            <%         }
                                   }
                               } 
                               if (!tieneVeterinarios) { 
                            %>
                                   <option value="" disabled>No hay veterinarios registrados</option>
                            <% } %>
                        </select>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-6">
                            <label class="form-label text-brand fw-bold small text-uppercase ms-1">Fecha</label>
                            <input type="date" name="fechaEvento" class="form-control shadow-sm" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label text-brand fw-bold small text-uppercase ms-1">Tipo de Evento</label>
                            <select name="tipoEvento" id="tipoEventoSelect" class="form-select shadow-sm" required>
                                <option value="Vacuna">Vacuna</option>
                                <option value="Enfermedad">Enfermedad / Curación</option>
                                <option value="Suplemento">Suplemento Vitamínico</option>
                                <option value="Control">Chequeo de Control</option>
                                <option value="Parto" id="opcionParto">Registro de Parto</option>
                            </select>
                        </div>
                    </div>

                    <div id="detallesParto" class="d-none p-4 rounded-4 mb-4 shadow-sm border" style="background-color: var(--bg-page); border-color: var(--border-subtle) !important;">
                        <h6 class="fw-bolder text-brand mb-3"><i class="bi bi-bezier2 me-1" style="color: var(--brand-info);"></i> Formulario de Parto</h6>
                        
                        <div class="mb-3">
                            <label class="small text-subtle fw-bold text-uppercase ms-1">Nacimiento</label>
                            <select name="partoEstado" id="partoEstado" class="form-select form-select-sm shadow-sm" style="background-color: var(--bg-card);">
                                <option value="" disabled selected>Seleccione estado de la cría...</option>
                                <option value="Nació Vivo">Nació Vivo (Autoregistrar en Hato)</option>
                                <option value="Nació Muerto">Nació Muerto</option>
                            </select>
                        </div>
                        
                        <div id="formRegistroCria" class="row g-3 border-top pt-3 mt-1 d-none" style="border-color: var(--border-subtle) !important;">
                            <div class="col-12"><small class="fw-bold" style="color: var(--brand-info);"><i class="bi bi-check-circle-fill"></i> La cría ingresará al inventario automáticamente.</small></div>
                            <div class="col-6">
                                <label class="small text-subtle fw-bold text-uppercase ms-1">Arete Cría</label>
                                <input type="text" name="criaArete" id="criaArete" class="form-control form-control-sm shadow-sm" style="background-color: var(--bg-card);" placeholder="Ej: V-008">
                            </div>
                            <div class="col-6">
                                <label class="small text-subtle fw-bold text-uppercase ms-1">Sexo</label>
                                <select name="criaGenero" id="partoGenero" class="form-select form-select-sm shadow-sm" style="background-color: var(--bg-card);">
                                    <option value="Hembra" selected>Hembra</option>
                                    <option value="Macho">Macho</option>
                                </select>
                            </div>
                            <div class="col-4">
                                <label class="small text-subtle fw-bold text-uppercase ms-1">Peso (Kg)</label>
                                <input type="number" step="0.01" name="criaPeso" id="criaPeso" class="form-control form-control-sm shadow-sm" style="background-color: var(--bg-card);" placeholder="Ej: 35">
                            </div>
                            <div class="col-4">
                                <label class="small text-subtle fw-bold text-uppercase ms-1">Raza</label>
                                <input type="text" name="criaRaza" id="criaRaza" class="form-control form-control-sm shadow-sm" style="background-color: var(--bg-card);" value="<%= vaca.getRaza() %>">
                            </div>
                            <div class="col-4">
                                <label class="small text-subtle fw-bold text-uppercase ms-1">Propósito</label>
                                <select name="criaProposito" id="criaProposito" class="form-select form-select-sm shadow-sm" style="background-color: var(--bg-card);">
                                    <option value="Leche">Leche</option>
                                    <option value="Doble Propósito">Doble Prop.</option>
                                    <option value="Carne">Carne</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div id="alertaEstado" class="alert border-0 shadow-sm d-none align-items-center mb-4 rounded-3" style="background-color: var(--brand-accent); color: var(--brand-dark);">
                        <i class="bi bi-exclamation-circle-fill fs-4 me-3"></i>
                        <div>
                            <strong class="d-block">Modificación Automática</strong>
                            <small>El estado de salud de este animal cambiará a <strong>En Tratamiento</strong>.</small>
                        </div>
                    </div>

                    <div>
                        <label class="form-label text-brand fw-bold small text-uppercase ms-1">Descripción / Notas</label>
                        <textarea name="descripcion" id="descripcionEvento" class="form-control shadow-sm" rows="3" placeholder="Detalle los medicamentos aplicados o diagnóstico..." required></textarea>
                    </div>
                </div>
                
                <div class="modal-footer border-top px-4 py-3 d-flex justify-content-between" style="border-color: var(--border-subtle) !important;">
                    <button type="button" class="btn btn-outline-brand fw-bold px-4" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-brand px-5 shadow-sm"><i class="bi bi-check2-circle me-2"></i> Guardar Historial</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="modalInforme" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0">
            <div class="modal-header border-bottom px-4 pb-3 mt-2 no-print" style="border-color: var(--border-subtle) !important;">
                <h4 class="modal-title fw-bolder text-brand"><i class="bi bi-file-earmark-medical-fill me-2" style="color: var(--brand-info);"></i> Ficha Clínica Oficial</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            
            <div class="modal-body px-4 py-4" id="areaInforme">
                <div class="print-header d-none text-center mb-4">
                    <h2 class="fw-bolder" style="color: var(--brand-primary);">FINCA LA ROSA</h2>
                    <h4 class="text-dark">Reporte Clínico y Productivo Individual</h4>
                    <p class="text-muted mb-0">Impreso en Sogamoso, Boyacá el <%= fechaActual %></p>
                </div>

                <div class="row g-4 mb-4 align-items-center">
                    <div class="col-md-3 text-center">
                        <% if(vaca.getImageUrl() != null && !vaca.getImageUrl().trim().isEmpty() && !vaca.getImageUrl().equals("null")) { %>
                            <img src="<%= request.getContextPath() %>/<%= vaca.getImageUrl() %>" class="rounded-4 border shadow-sm" style="width: 140px; height: 140px; object-fit: cover;" onerror="this.src='https://placehold.co/150x150/F3F5E7/9CA889?text=IMG'">
                        <% } else { %>
                            <div class="rounded-4 border d-flex align-items-center justify-content-center mx-auto" style="background-color: var(--bg-page); width: 140px; height: 140px; font-size: 50px; color: var(--brand-accent);"><i class="bi bi-camera"></i></div>
                        <% } %>
                    </div>
                    <div class="col-md-9">
                        <h3 class="fw-bolder text-brand mb-3">Identificación: <%= vaca.getNumeroArete() %></h3>
                        <div class="row g-3 p-3 rounded-4 border" style="background-color: var(--bg-page); border-color: var(--border-subtle) !important;">
                            <div class="col-6"><span class="text-subtle fw-bold small text-uppercase">Raza:</span> <strong class="d-block text-dark"><%= vaca.getRaza() %></strong></div>
                            <div class="col-6"><span class="text-subtle fw-bold small text-uppercase">Género:</span> <strong class="d-block text-dark"><%= vaca.getGenero() %></strong></div>
                            <div class="col-6"><span class="text-subtle fw-bold small text-uppercase">Nacimiento:</span> <strong class="d-block text-dark"><%= vaca.getFechaNacimiento() %> (<%= vaca.getEdadAnios() %> años)</strong></div>
                            <div class="col-6"><span class="text-subtle fw-bold small text-uppercase">Clasificación:</span> <strong class="d-block text-dark"><%= vaca.getClasificacion() %></strong></div>
                        </div>
                    </div>
                </div>

                <h5 class="fw-bolder border-bottom pb-2 mb-3 mt-4 text-brand" style="border-color: var(--brand-accent) !important;">Datos Vitales</h5>
                <div class="row g-3 mb-4">
                    <% String colSize = "Hembra".equals(vaca.getGenero()) ? "col-3" : "col-6"; %>
                    <div class="<%= colSize %>"><div class="p-3 bg-white rounded-4 text-center border shadow-sm"><small class="text-subtle fw-bold d-block">PESO</small><strong class="fs-5 text-dark"><%= vaca.getPesoKg() %> Kg</strong></div></div>
                    <div class="<%= colSize %>"><div class="p-3 bg-white rounded-4 text-center border shadow-sm"><small class="text-subtle fw-bold d-block">SALUD</small><strong class="fs-5 text-dark"><%= vaca.getEstadoSalud() %></strong></div></div>
                    <% if("Hembra".equals(vaca.getGenero())) { %>
                    <div class="col-3"><div class="p-3 bg-white rounded-4 text-center border shadow-sm"><small class="text-subtle fw-bold d-block">PRODUCCIÓN</small><strong class="fs-5 text-dark"><%= vaca.getLitrosDiariosPromedio() %> L</strong></div></div>
                    <div class="col-3"><div class="p-3 bg-white rounded-4 text-center border shadow-sm"><small class="text-subtle fw-bold d-block">PARTOS</small><strong class="fs-5 text-dark"><%= vaca.getNumeroPartos() %></strong></div></div>
                    <% } %>
                </div>

                <h5 class="fw-bolder border-bottom pb-2 mb-3 mt-4 text-brand" style="border-color: var(--brand-accent) !important;">Registro de Tratamientos</h5>
                <table class="table table-bordered table-sm text-start align-middle" style="font-size: 0.9rem;">
                    <thead class="text-subtle" style="background-color: var(--bg-page);">
                        <tr>
                            <th>Fecha</th>
                            <th>Tipo</th>
                            <th>Descripción del Procedimiento</th>
                            <th>Firma Vet.</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(historial != null && !historial.isEmpty()) {
                            for(HistorialClinico h : historial) { %>
                        <tr>
                            <td class="fw-bold text-dark" style="white-space: nowrap;"><%= h.getFechaEvento() %></td>
                            <td class="fw-bold"><%= h.getTipoEvento() %></td>
                            <td><%= h.getDescripcion() %></td>
                            <td><%= h.getNombreVeterinario() != null ? h.getNombreVeterinario() : "N/A" %></td>
                        </tr>
                        <% }} else { %>
                        <tr><td colspan="4" class="text-center text-subtle py-3">Sin registros médicos de intervenciones.</td></tr>
                        <% } %>
                    </tbody>
                </table>
                <div class="text-end mt-5 print-header d-none">
                    <br><br>
                    <p class="mb-0">_________________________________________</p>
                    <p class="text-muted small fw-bold">Firma Profesional Encargado</p>
                </div>
            </div>
            
            <div class="modal-footer border-top bg-white px-4 py-3 d-flex justify-content-between no-print" style="border-color: var(--border-subtle) !important;">
                <button type="button" class="btn btn-outline-brand fw-bold px-4" data-bs-dismiss="modal">Cerrar Ficha</button>
                <button type="button" class="btn btn-accent fw-bold px-5 shadow-sm" onclick="window.print()"><i class="bi bi-printer-fill me-2"></i> Imprimir Historial</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const generoVaca = "<%= vaca.getGenero() %>";
    
    if (generoVaca === "Macho") {
        let opParto = document.getElementById('opcionParto');
        if(opParto) opParto.remove();
    }

    document.getElementById('partoGenero').addEventListener('change', function() {
        let selectProposito = document.getElementById('criaProposito');
        if (this.value === 'Macho') {
            Array.from(selectProposito.options).forEach(opt => {
                opt.disabled = (opt.value === 'Leche' || opt.value === 'Doble Propósito');
            });
            selectProposito.value = 'Carne'; 
        } else {
            Array.from(selectProposito.options).forEach(opt => { opt.disabled = false; });
        }
    });

    document.getElementById('tipoEventoSelect').addEventListener('change', function() {
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
<!-- jQuery and DataTables JS -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.bootstrap5.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.print.min.js"></script>

<script>
    // =========================================
    // INICIALIZACIÓN DE DATATABLES
    // =========================================
    $(document).ready(function() {
        $('#tableHistorial').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
            },
            dom: '<"row mb-3"<"col-md-6"B><"col-md-6"f>>rt<"row"<"col-md-6"i><"col-md-6"p>>',
            buttons: [
                {
                    extend: 'pdfHtml5',
                    text: '<i class="bi bi-file-earmark-pdf-fill"></i> PDF Clínica',
                    className: 'btn btn-danger btn-sm',
                    orientation: 'portrait',
                    pageSize: 'A4',
                    title: 'FINCA LA ROSA - HISTORIAL CLÍNICO',
                    customize: function(doc) {
                        // Color corporativo y alineación
                        doc.styles.title = {
                            color: '#464704',
                            fontSize: '18',
                            alignment: 'center',
                            bold: true,
                            margin: [0, 0, 0, 15]
                        };
                        doc.styles.tableHeader = {
                            fillColor: '#464704',
                            color: 'white',
                            alignment: 'center',
                            bold: true,
                            margin: [0, 5, 0, 5]
                        };
                        doc.defaultStyle.alignment = 'center';
                        
                        // Ajuste ancho de tabla
                        var objLayout = {};
                        objLayout.hLineWidth = function(i) { return 0.5; };
                        objLayout.vLineWidth = function(i) { return 0.5; };
                        objLayout.hLineColor = function(i) { return '#E2E4D5'; };
                        objLayout.vLineColor = function(i) { return '#E2E4D5'; };
                        doc.content[1].layout = objLayout;
                        
                        // Centrado automático de tabla
                        var colCount = doc.content[1].table.body[0].length;
                        doc.content[1].table.widths = Array(colCount).fill('*');
                    }
                },
                {
                    extend: 'print',
                    text: '<i class="bi bi-printer-fill"></i> Imprimir',
                    className: 'btn btn-secondary btn-sm'
                }
            ],
            pageLength: 10,
            order: [[0, 'desc']] // Ordenar por fecha descendente
        });
    });
    
    // Gráfico de Curva de Lactancia (ApexCharts)
    <% if("Producción".equals(vaca.getClasificacion())) { %>
    document.addEventListener("DOMContentLoaded", function() {
        if(typeof ApexCharts !== 'undefined') {
            // Generar datos simulados matemáticos para la Curva Ideal (Campana que sube hasta el día 60 y baja)
            var dias = [];
            var curvaIdeal = [];
            var curvaReal = [];
            
            var litrosMaximos = <%= vaca.getLitrosDiariosPromedio() > 0 ? vaca.getLitrosDiariosPromedio() * 1.2 : 25 %>; 
            var declive = litrosMaximos / 305;
            
            for(let i=0; i<=305; i+=15) {
                dias.push("Día " + i);
                // Modelo simple de lactancia de Wood
                let ideal = (i < 60) ? (litrosMaximos * (i/60)) : (litrosMaximos - ((i-60) * declive * 1.5));
                if(ideal < 0) ideal = 0;
                curvaIdeal.push(ideal.toFixed(1));
                
                // Simular curva real con ligeras variaciones (algunas bajan si hay problemas)
                if(i <= 150) { // Supongamos que va en el día 150 de lactancia
                    let variacion = (Math.random() * 4) - 2; 
                    let real = ideal + variacion;
                    if(real < 0) real = 0;
                    curvaReal.push(real.toFixed(1));
                } else {
                    curvaReal.push(null); // Aún no llega a estos días
                }
            }

            var options = {
                series: [{
                    name: 'Lactancia Ideal Teórica',
                    type: 'area',
                    data: curvaIdeal
                }, {
                    name: 'Producción Real',
                    type: 'line',
                    data: curvaReal
                }],
                chart: {
                    height: 320,
                    type: 'line',
                    fontFamily: 'Inter, sans-serif',
                    toolbar: { show: false }
                },
                stroke: {
                    curve: 'smooth',
                    width: [2, 4],
                    dashArray: [0, 0]
                },
                fill: {
                    type: ['gradient', 'solid'],
                    gradient: {
                        shadeIntensity: 1,
                        opacityFrom: 0.4,
                        opacityTo: 0.05,
                        stops: [0, 90, 100]
                    }
                },
                colors: ['#9CA889', '#dc3545'], // Sage Green para ideal, Rojo/Brand para real
                labels: dias,
                markers: {
                    size: [0, 4]
                },
                xaxis: {
                    tooltip: { enabled: false },
                    labels: { style: { colors: 'var(--text-subtle)', fontSize: '10px' } }
                },
                yaxis: {
                    title: { text: 'Litros / Día', style: { color: 'var(--text-subtle)' } },
                    labels: { style: { colors: 'var(--text-subtle)' } }
                },
                grid: {
                    borderColor: 'var(--border-subtle)',
                    strokeDashArray: 4,
                    yaxis: { lines: { show: true } }
                },
                tooltip: {
                    shared: true,
                    intersect: false,
                    y: {
                        formatter: function (y) {
                            if (typeof y !== "undefined" && y !== null) {
                                return y + " Litros";
                            }
                            return y;
                        }
                    }
                },
                legend: {
                    position: 'top',
                    horizontalAlign: 'right'
                }
            };

            var chart = new ApexCharts(document.querySelector("#lactanciaChart"), options);
            chart.render();
        }
    });
    <% } %>
</script>
<jsp:include page="includes/footer.jsp" />