<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.Bovino" %>
<%@ page import="com.finca.models.HistorialClinico" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% Bovino vaca = (Bovino) request.getAttribute("bovino"); %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Perfil Bovino | Finca</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Se agrega Bootstrap Icons para la interfaz -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body style="font-family: 'Inter', sans-serif; background-color: #f8f9fa;">

<jsp:include page="navbar.jsp" />

<div class="container py-4">
    <div class="mb-3">
        <a href="inventario-ganado" class="btn btn-outline-secondary fw-bold shadow-sm">
            <i class="bi bi-arrow-left"></i> Volver al Inventario
        </a>
    </div>

    <!-- Alertas de Éxito o Error -->
    <% if(request.getAttribute("successMessage") != null) { %>
        <div class="alert alert-success alert-dismissible fade show shadow-sm">
            <i class="bi bi-check-circle-fill me-2"></i> <%= request.getAttribute("successMessage") %>
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>
    <% if(request.getParameter("error") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show shadow-sm">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> Hubo un error al registrar el evento médico.
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <div class="row">
        <!-- TARJETA DEL PERFIL DEL ANIMAL -->
        <div class="col-md-4">
            <div class="card border-0 shadow-sm text-center p-4 mb-4">
                <% if(vaca.getImageUrl() != null && !vaca.getImageUrl().isEmpty()) { %>
                    <img src="<%= vaca.getImageUrl() %>" class="rounded-circle mx-auto mb-3 shadow-sm" style="width: 180px; height: 180px; object-fit: cover; border: 4px solid #198754;">
                <% } else { %>
                    <div class="rounded-circle bg-secondary text-white mx-auto mb-3 d-flex align-items-center justify-content-center shadow-sm" style="width: 180px; height: 180px; font-size: 50px;">🐄</div>
                <% } %>
                <h3 class="fw-bold text-success"><%= vaca.getNumeroArete() %></h3>
                <h5 class="text-muted"><%= vaca.getRaza() %> - <%= vaca.getEdadAnios() %> años</h5>
                
                <hr>
                <div class="text-start">
                    <p class="mb-2"><strong><i class="bi bi-tag-fill text-success"></i> Clasificación:</strong> <%= vaca.getClasificacion() %></p>
                    <p class="mb-2"><strong><i class="bi bi-speedometer text-primary"></i> Peso Actual:</strong> <%= vaca.getPesoKg() %> Kg</p>
                    <p class="mb-2"><strong><i class="bi bi-heart-pulse-fill text-danger"></i> Salud Actual:</strong> 
                        <span class="badge <%= vaca.getEstadoSalud().equals("Sano") || vaca.getEstadoSalud().equals("Sana") ? "bg-success" : "bg-warning text-dark" %>">
                            <%= vaca.getEstadoSalud() %>
                        </span>
                    </p>
                    <p class="mb-2"><strong><i class="bi bi-clipboard2-plus-fill text-info"></i> Partos:</strong> <%= vaca.getNumeroPartos() %></p>
                </div>
            </div>
        </div>

        <!-- HISTORIAL CLÍNICO -->
        <div class="col-md-8">
            <div class="card border-0 shadow-sm p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold text-primary mb-3 mb-md-0"><i class="bi bi-journal-medical"></i> Historial Clínico y Eventos</h4>
                    <!-- BOTÓN CORREGIDO CON DATA-BS-TARGET -->
                    <button class="btn btn-primary btn-sm fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#modalEventoMedico">
                        <i class="bi bi-plus-circle"></i> Nuevo Evento Médico
                    </button>
                </div>

                <div class="table-responsive">
                    <table class="table table-striped align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th>Fecha</th>
                                <th>Tipo</th>
                                <th>Descripción Médica</th>
                                <th>Veterinario/Responsable</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                List<HistorialClinico> historial = (List<HistorialClinico>) request.getAttribute("historial");
                                if(historial != null && !historial.isEmpty()) {
                                    for(HistorialClinico h : historial) {
                                        String badge = "bg-secondary";
                                        if(h.getTipoEvento().equals("Vacuna")) badge = "bg-success";
                                        if(h.getTipoEvento().equals("Enfermedad")) badge = "bg-danger";
                                        if(h.getTipoEvento().equals("Suplemento")) badge = "bg-info text-dark";
                            %>
                            <tr>
                                <td class="fw-bold"><%= h.getFechaEvento() %></td>
                                <td><span class="badge <%= badge %>"><%= h.getTipoEvento() %></span></td>
                                <td class="text-muted small"><%= h.getDescripcion() %></td>
                                <td><i class="bi bi-person-badge"></i> <%= h.getNombreVeterinario() != null ? h.getNombreVeterinario() : "Sin asignar" %></td>
                            </tr>
                            <% }} else { %>
                            <tr><td colspan="4" class="text-center py-4 text-muted">No hay registros médicos para esta vaca.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- NUEVO MODAL: REGISTRAR EVENTO MÉDICO -->
<div class="modal fade" id="modalEventoMedico" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-heart-pulse"></i> Registrar Evento Médico</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <!-- FORMULARIO CORREGIDO -->
            <form action="perfil-bovino" method="POST">
                <!-- Se envía el ID oculto de la vaca actual -->
                <input type="hidden" name="idBovino" value="<%= vaca.getIdBovino() %>">
                
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Fecha del Evento</label>
                        <input type="date" name="fechaEvento" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Tipo de Evento</label>
                        <select name="tipoEvento" class="form-select" required>
                            <option value="Vacuna">Vacuna</option>
                            <option value="Enfermedad">Enfermedad / Tratamiento</option>
                            <option value="Suplemento">Suplemento / Vitamina</option>
                            <option value="Control">Control General</option>
                            <option value="Parto">Registro de Parto</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Descripción Médica</label>
                        <textarea name="descripcion" class="form-control" rows="3" placeholder="Ej: Aplicación de vacuna aftosa, dosis 2ml. El animal reaccionó bien." required></textarea>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary fw-bold"><i class="bi bi-save"></i> Guardar Registro</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>