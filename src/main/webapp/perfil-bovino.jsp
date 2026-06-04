<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.Bovino" %>
<%@ page import="com.finca.models.HistorialClinico" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% Bovino vaca = (Bovino) request.getAttribute("bovino"); %>
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
            /* COLOR PERSONALIZADO APPLE STYLE */
            --brand-main: #2F855A;
            --brand-hover: #246b48;
            
            /* VARIABLES APPLE GLASSMORPHISM */
            --apple-bg: #f5f5f7;
            --glass-bg: rgba(255, 255, 255, 0.75);
            --glass-border: rgba(255, 255, 255, 0.6);
            --glass-shadow: 0 16px 40px rgba(0, 0, 0, 0.06);
        }

        body { 
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; 
            background-color: var(--apple-bg); 
            color: #1d1d1f; 
            /* Fondo con manchas de luz sutiles para resaltar el efecto cristal */
            background-image: 
                radial-gradient(circle at 10% 20%, rgba(47, 133, 90, 0.1), transparent 30%),
                radial-gradient(circle at 90% 80%, rgba(47, 133, 90, 0.08), transparent 30%);
            background-attachment: fixed;
            min-height: 100vh;
        }
        
        /* OVERRIDES DE BOOTSTRAP */
        .text-success { color: var(--brand-main) !important; }
        .bg-success { background-color: var(--brand-main) !important; color: white !important; }
        .btn-success { background-color: var(--brand-main); border-color: var(--brand-main); }
        .btn-success:hover { background-color: var(--brand-hover); border-color: var(--brand-hover); transform: translateY(-2px); box-shadow: 0 6px 15px rgba(47, 133, 90, 0.25); }
        .bg-success-subtle { background-color: rgba(47, 133, 90, 0.12) !important; }
        
        /* EFECTO CRISTAL PRINCIPAL */
        .glass-panel {
            background: var(--glass-bg);
            backdrop-filter: blur(24px) saturate(180%);
            -webkit-backdrop-filter: blur(24px) saturate(180%);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            box-shadow: var(--glass-shadow);
        }

        /* --- IMAGEN DEL PERFIL (SIN CÍRCULOS) --- */
        .profile-img {
            width: 200px;
            height: 200px;
            object-fit: cover;
            border-radius: 24px;
            border: 4px solid #ffffff;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .profile-img:hover {
            transform: scale(1.05) translateY(-5px);
        }
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

        /* --- ESTILOS DE TABLA DE HISTORIAL --- */
        .table-custom-wrapper { border-radius: 18px; overflow: hidden; background: rgba(255,255,255,0.4); border: 1px solid var(--glass-border); }
        .table { margin-bottom: 0; background: transparent; }
        .table th { white-space: nowrap; font-weight: 700; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; padding: 18px 15px; border-bottom: 1px solid rgba(0,0,0,0.05); background-color: rgba(255,255,255,0.6); color: #6c757d;}
        .table td { vertical-align: middle; padding: 16px 15px; color: #495057; font-size: 0.95rem; border-bottom: 1px solid rgba(0,0,0,0.03); background: transparent; }
        .table-hover tbody tr { transition: all 0.2s ease; }
        .table-hover tbody tr:hover td { background-color: rgba(255,255,255,0.9); }
        
        /* --- MODALES ESTILO APPLE PURO --- */
        .modal-content {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(40px) saturate(200%);
            -webkit-backdrop-filter: blur(40px) saturate(200%);
            border: 1px solid rgba(255, 255, 255, 0.8);
            border-radius: 28px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.15);
        }
        
        /* Campos flotantes y elegantes */
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
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container py-4">
    <!-- BOTÓN VOLVER -->
    <div class="mb-4">
        <a href="inventario-ganado" class="btn btn-light fw-bold shadow-sm" style="border-radius: 14px; color: #555; background: rgba(255,255,255,0.8);">
            <i class="bi bi-arrow-left me-2"></i> Volver al Inventario
        </a>
    </div>

    <!-- Alertas de Éxito o Error (Con estilo Glass) -->
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
                    <img src="<%= request.getContextPath() %>/<%= vaca.getImageUrl() %>" class="profile-img mx-auto mb-4">
                <% } else { %>
                    <div class="profile-placeholder mx-auto mb-4">🐄</div>
                <% } %>
                
                <h2 class="fw-bold text-success mb-1"><%= vaca.getNumeroArete() %></h2>
                <h5 class="text-muted fw-semibold mb-4"><%= vaca.getRaza() %> • <%= vaca.getEdadAnios() %> años</h5>
                
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
                    <p class="mb-0 d-flex justify-content-between">
                        <span class="text-muted fw-bold small text-uppercase"><i class="bi bi-clipboard2-plus-fill me-2 text-info"></i> Partos</span>
                        <span class="fw-bold text-dark"><%= vaca.getNumeroPartos() %></span>
                    </p>
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
                                List<HistorialClinico> historial = (List<HistorialClinico>) request.getAttribute("historial");
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

<!-- ================= MODAL ESTILO APPLE REAL: REGISTRAR EVENTO MÉDICO ================= -->
<div class="modal fade" id="modalEventoMedico" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0">
            
            <div class="modal-header border-0 pb-0 justify-content-center position-relative mt-3">
                <h4 class="modal-title fw-bold text-dark"><i class="bi bi-heart-pulse-fill text-success me-2"></i> Nuevo Evento</h4>
                <button type="button" class="btn-close position-absolute end-0 me-4" data-bs-dismiss="modal" style="top: 50%; transform: translateY(-50%);"></button>
            </div>
            
            <form action="perfil-bovino" method="POST">
                <input type="hidden" name="idBovino" value="<%= vaca.getIdBovino() %>">
                <!-- CAMPO OCULTO QUE LE AVISARÁ AL SERVLET EL CAMBIO DE ESTADO -->
                <input type="hidden" name="nuevoEstadoSalud" id="nuevoEstadoSalud" value="">
                
                <div class="modal-body px-4 py-4">
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
                            <option value="Parto">Registro de Parto</option>
                        </select>
                    </div>
                    
                    <!-- ALERTA DINÁMICA DE CAMBIO DE ESTADO (Oculta por defecto) -->
                    <div id="alertaEstado" class="alert alert-warning border-0 shadow-sm d-none align-items-center mb-4" style="border-radius: 16px; background: rgba(255, 193, 7, 0.15); color: #856404;">
                        <i class="bi bi-info-circle-fill fs-5 me-2"></i>
                        <small>El estado de salud cambiará automáticamente a <strong>En Tratamiento</strong>.</small>
                    </div>

                    <div class="mb-2">
                        <label class="form-label text-muted fw-bold small text-uppercase ms-1">Descripción Médica</label>
                        <textarea name="descripcion" class="form-control shadow-sm" rows="4" placeholder="Ej: Aplicación de medicina. El animal está en observación." required style="border-radius: 18px;"></textarea>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // --- Lógica automática para cambio de estado de salud ---
    document.getElementById('tipoEventoSelect').addEventListener('change', function() {
        let alerta = document.getElementById('alertaEstado');
        let inputEstado = document.getElementById('nuevoEstadoSalud');
        
        if (this.value === 'Enfermedad') {
            // Muestra la alerta elegante y asigna el valor al campo oculto
            alerta.classList.remove('d-none');
            alerta.classList.add('d-flex');
            inputEstado.value = 'En Tratamiento';
        } else {
            // Oculta la alerta si selecciona otra cosa
            alerta.classList.add('d-none');
            alerta.classList.remove('d-flex');
            inputEstado.value = '';
        }
    });
</script>
</body>
</html>