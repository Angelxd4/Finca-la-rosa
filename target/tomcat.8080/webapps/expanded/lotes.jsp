<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.LoteProduccion" %>
<%@ page import="com.finca.models.ProductoLacteo" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Procesamiento de Quesos | Finca</title>
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
        <h2 class="fw-bold text-primary">⚙️ Procesamiento de Quesos (Lotes)</h2>
        <button class="btn btn-primary fw-bold px-4" data-bs-toggle="modal" data-bs-target="#modalLote">
            + Iniciar Nuevo Lote
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
            <thead class="table-primary">
                <tr>
                    <th>Lote #</th>
                    <th>Producto a Fabricar</th>
                    <th>Meta (Cantidad)</th>
                    <th>Leche Invertida</th>
                    <th>Estado Actual</th>
                    <th>Acción Requerida</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<LoteProduccion> lista = (List<LoteProduccion>) request.getAttribute("lotes");
                    if(lista != null && !lista.isEmpty()) {
                        for(LoteProduccion lote : lista) {
                            String badgeColor = "";
                            if(lote.getEstado().equals("En Producción")) badgeColor = "bg-warning text-dark";
                            if(lote.getEstado().equals("Terminado")) badgeColor = "bg-info text-dark";
                            if(lote.getEstado().equals("En Venta")) badgeColor = "bg-success";
                %>
                <tr>
                    <td class="fw-bold text-muted">L-<%= String.format("%04d", lote.getIdLote()) %></td>
                    <td class="fw-bold"><%= lote.getNombreProducto() %></td>
                    <td><%= lote.getCantidad() %> unidades/kg</td>
                    <td class="text-danger fw-bold">- <%= lote.getLitrosLecheUsados() %> L</td>
                    <td><span class="badge <%= badgeColor %> fs-6"><%= lote.getEstado() %></span></td>
                    <td>
                        <form action="lotes-produccion" method="POST" class="d-inline">
                            <input type="hidden" name="action" value="cambiarEstado">
                            <input type="hidden" name="idLote" value="<%= lote.getIdLote() %>">
                            
                            <% if(lote.getEstado().equals("En Producción")) { %>
                                <input type="hidden" name="nuevoEstado" value="Terminado">
                                <button type="submit" class="btn btn-sm btn-info fw-bold">Marcar Producto Hecho</button>
                            <% } else if(lote.getEstado().equals("Terminado")) { %>
                                <input type="hidden" name="nuevoEstado" value="En Venta">
                                <button type="submit" class="btn btn-sm btn-success fw-bold">Poner en Venta</button>
                            <% } else if(lote.getEstado().equals("En Venta")) { %>
                                <span class="text-success fw-bold small">✅ En Catálogo Comercial</span>
                            <% } %>
                        </form>
                    </td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr><td colspan="6" class="text-center py-4 text-muted">No hay lotes en producción actualmente.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="modalLote" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header border-0 bg-primary text-white">
                <h5 class="modal-title fw-bold">Iniciar Producción de Queso</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="lotes-produccion" method="POST">
                <input type="hidden" name="action" value="iniciar">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">¿Qué vas a producir?</label>
                        <select name="idProducto" class="form-select" required>
                            <% 
                                List<ProductoLacteo> catalogo = (List<ProductoLacteo>) request.getAttribute("catalogoLacteos");
                                if(catalogo != null) {
                                    for(ProductoLacteo p : catalogo) {
                                        // Filtramos la leche cruda porque no podemos hacer leche de la leche
                                        if(!"LAC-001".equals(p.getCodigo())) {
                            %>
                                <option value="<%= p.getIdProducto() %>"><%= p.getNombre() %></option>
                            <% 
                                        }
                                    }
                                } 
                            %>
                        </select>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted">Litros de Leche a Usar</label>
                            <input type="number" step="0.01" name="litrosLecheUsados" class="form-control" required placeholder="Ej: 50">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted">Quesos Estimados (Cantidad)</label>
                            <input type="number" step="0.01" name="cantidad" class="form-control" required placeholder="Ej: 5">
                        </div>
                    </div>
                    <div class="alert alert-warning small mt-3 border-0">
                        ⚠️ Asegúrate de tener la leche cruda suficiente en el inventario. Al darle a guardar, se restará automáticamente.
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="submit" class="btn btn-primary w-100 fw-bold">Iniciar Proceso</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>