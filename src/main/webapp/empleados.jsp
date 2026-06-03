<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Empleados | Finca</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8f9fa; }
        .table-container { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-success">👥 Gestión de Empleados</h2>
        <button class="btn btn-success fw-bold px-4" data-bs-toggle="modal" data-bs-target="#modalEmpleado">
            + Nuevo Empleado
        </button>
    </div>

    <% if(request.getAttribute("successMessage") != null) { %>
        <div class="alert alert-success alert-dismissible fade show"><%= request.getAttribute("successMessage") %><button class="btn-close" data-bs-dismiss="alert"></button></div>
    <% } %>
    <% if(request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show"><%= request.getAttribute("errorMessage") %><button class="btn-close" data-bs-dismiss="alert"></button></div>
    <% } %>

    <div class="table-container">
        <table class="table table-hover align-middle">
            <thead class="table-success">
                <tr>
                    <th>Nombre Completo</th>
                    <th>Documento</th>
                    <th>Correo</th>
                    <th>Rol en Finca</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Usuario> lista = (List<Usuario>) request.getAttribute("empleados");
                    if(lista != null && !lista.isEmpty()) {
                        for(Usuario u : lista) {
                            // Convertir el número de rol a texto visible
                            String rolTexto = "Desconocido";
                            if(u.getRoleId() == 1) rolTexto = "👑 Administrador";
                            if(u.getRoleId() == 2) rolTexto = "🩺 Veterinario";
                            if(u.getRoleId() == 3) rolTexto = "🚜 Operario / Vaquero";
                            if(u.getRoleId() == 4) rolTexto = "💼 Vendedor";
                            if(u.getRoleId() == 5) rolTexto = "🛒 Cliente";
                %>
                <tr>
                    <td class="fw-bold"><%= u.getFullName() %></td>
                    <td><%= u.getDocumentId() %></td>
                    <td class="text-muted"><%= u.getEmail() %></td>
                    <td><span class="badge bg-secondary"><%= rolTexto %></span></td>
                    <td>
                        <form action="empleados" method="POST" class="d-inline" onsubmit="return confirm('¿Seguro que deseas eliminar a este empleado?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= u.getId() %>">
                            <button type="submit" class="btn btn-sm btn-outline-danger">Eliminar</button>
                        </form>
                    </td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr><td colspan="5" class="text-center py-4 text-muted">No hay empleados registrados.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="modalEmpleado" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header border-0 bg-success text-white">
                <h5 class="modal-title fw-bold">Registrar Nuevo Empleado</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="empleados" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Nombre Completo</label>
                        <input type="text" name="fullName" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Documento de Identidad</label>
                        <input type="text" name="documentId" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Correo Electrónico (Para Login)</label>
                        <input type="email" name="email" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Contraseña temporal</label>
                        <input type="text" name="password" class="form-control" value="12345" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Asignar Rol</label>
                        <select name="roleId" class="form-select" required>
                            <option value="1">Administrador (Mayordomo)</option>
                            <option value="2">Veterinario</option>
                            <option value="3" selected>Operario (Vaquero / Ordeñador)</option>
                            <option value="4">Vendedor</option>
                            <option value="5">Cliente Frecuente</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="submit" class="btn btn-success w-100 fw-bold">Guardar Empleado</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>