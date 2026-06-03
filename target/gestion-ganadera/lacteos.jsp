<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.ProductoLacteo" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventario de Lácteos | Finca</title>
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
        <h2 class="fw-bold text-warning">🧀 Inventario de Lácteos y Derivados</h2>
        <button class="btn btn-warning fw-bold px-4 text-dark" data-bs-toggle="modal" data-bs-target="#modalLacteo">
            + Nuevo Producto
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
            <thead class="table-warning">
                <tr>
                    <th>Código</th>
                    <th>Producto</th>
                    <th>Descripción</th>
                    <th>Stock Disponible</th>
                    <th>Precio Unitario</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<ProductoLacteo> lista = (List<ProductoLacteo>) request.getAttribute("lacteos");
                    if(lista != null && !lista.isEmpty()) {
                        for(ProductoLacteo p : lista) {
                %>
                <tr>
                    <td><strong class="text-secondary"><%= p.getCodigo() %></strong></td>
                    <td class="fw-bold"><%= p.getNombre() %></td>
                    <td class="text-muted small"><%= p.getDescripcion() %></td>
                    <td>
                        <span class="badge <%= p.getStock() > 0 ? "bg-success" : "bg-danger" %> fs-6">
                            <%= p.getStock() %> <%= p.getUnidadMedida() %>
                        </span>
                    </td>
                    <td class="fw-bold text-dark">$<%= String.format("%,.2f", p.getPrecioUnitario()) %></td>
                    <td>
                        <%-- Bloqueamos el botón de eliminar para la "Leche Cruda" base porque se actualiza con la máquina --%>
                        <% if (!"LAC-001".equals(p.getCodigo())) { %>
                        <form action="lacteos" method="POST" class="d-inline" onsubmit="return confirm('¿Eliminar este producto del catálogo?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= p.getIdProducto() %>">
                            <button type="submit" class="btn btn-sm btn-outline-danger">Eliminar</button>
                        </form>
                        <% } else { %>
                            <span class="text-muted small">Protegido por Ordeño</span>
                        <% } %>
                    </td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr><td colspan="6" class="text-center py-4 text-muted">No hay productos registrados.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="modalLacteo" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header border-0 bg-warning text-dark">
                <h5 class="modal-title fw-bold">Registrar Queso / Derivado</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="lacteos" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Código Interno</label>
                        <input type="text" name="codigo" class="form-control" placeholder="Ej: QUES-01" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Nombre del Producto</label>
                        <input type="text" name="nombre" class="form-control" placeholder="Ej: Queso Campesino 500g" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Descripción</label>
                        <input type="text" name="descripcion" class="form-control" placeholder="Queso fresco salado elaborado en la finca" required>
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-bold text-muted">Unidad de Medida</label>
                            <select name="unidadMedida" class="form-select" required>
                                <option value="Unidades">Unidades</option>
                                <option value="Kg">Kilogramos (Kg)</option>
                                <option value="Litros">Litros (L)</option>
                                <option value="Bloques">Bloques</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-bold text-muted">Stock Inicial</label>
                            <input type="number" step="0.01" name="stock" class="form-control" value="0" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Precio Unitario ($)</label>
                        <input type="number" step="0.01" name="precioUnitario" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="submit" class="btn btn-warning w-100 fw-bold text-dark">Guardar en Catálogo</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>