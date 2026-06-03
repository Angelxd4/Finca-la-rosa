<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.Ordeno" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Producción | Finca</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8f9fa; }
        .card-stock { background: linear-gradient(135deg, #0d6efd, #0dcaf0); color: white; border-radius: 12px; }
        .table-container { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container py-4">
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card card-stock border-0 p-4 shadow-sm">
                <h5 class="fw-bold mb-1">🍼 Leche Cruda Disponible</h5>
                <h2 class="display-5 fw-bold mb-0">
                    <%= request.getAttribute("stockLeche") != null ? request.getAttribute("stockLeche") : "0.0" %> <small class="fs-5">Litros</small>
                </h2>
                <p class="mb-0 mt-2 small opacity-75">Actualizado en tiempo real</p>
            </div>
        </div>
        <div class="col-md-8 d-flex align-items-end justify-content-end">
            <button class="btn btn-primary btn-lg fw-bold px-4" data-bs-toggle="modal" data-bs-target="#modalOrdeno">
                + Registrar Ordeño (Máquina)
            </button>
        </div>
    </div>

    <% if(request.getAttribute("successMessage") != null) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <%= request.getAttribute("successMessage") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <h4 class="fw-bold text-primary mb-3">Historial de Ordeños</h4>
    <div class="table-container">
        <table class="table table-hover align-middle">
            <thead class="table-primary">
                <tr>
                    <th>Fecha y Hora</th>
                    <th>Vacas Ordeñadas</th>
                    <th>Litros Obtenidos</th>
                    <th>Operario Supervisor</th>
                    <th>Asistentes</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Ordeno> lista = (List<Ordeno>) request.getAttribute("historial");
                    if(lista != null && !lista.isEmpty()) {
                        for(Ordeno o : lista) {
                %>
                <tr>
                    <td><%= o.getFechaHora() %></td>
                    <td class="text-center"><span class="badge bg-secondary"><%= o.getVacasOrdenadas() %> vacas</span></td>
                    <td class="fw-bold text-primary">+ <%= o.getLitrosObtenidos() %> L</td>
                    <td>👤 <%= o.getNombreSupervisor() %></td>
                    <td class="text-muted small"><%= o.getAsistentes() %></td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr><td colspan="5" class="text-center py-4 text-muted">No hay registros de ordeño recientes.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="modalOrdeno" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header border-0 bg-primary text-white">
                <h5 class="modal-title fw-bold">Registro de Máquina de Ordeño</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="produccion" method="POST">
                <div class="modal-body">
                    <div class="alert alert-info small mb-4">
                        El sistema te registrará automáticamente a ti como el Supervisor responsable de este proceso.
                    </div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted">Cantidad de Vacas Ordeñadas</label>
                            <input type="number" name="vacasOrdenadas" class="form-control" required min="1">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted">Litros Totales Obtenidos</label>
                            <input type="number" step="0.01" name="litrosObtenidos" class="form-control" required min="0.1">
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Empleados Asistentes (Nombres)</label>
                            <input type="text" name="asistentes" class="form-control" placeholder="Ej: Carlos López, Pedro Gómez">
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Observaciones del Equipo / Proceso</label>
                            <textarea name="observaciones" class="form-control" rows="2" placeholder="Ej: Presión de máquina normal, vacas tranquilas."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="submit" class="btn btn-primary w-100 fw-bold">Guardar y Actualizar Inventario</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>