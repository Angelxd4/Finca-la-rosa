<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.ProductoLacteo" %>
<%@ page import="com.finca.models.LoteProduccion" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // LÓGICA DE SEPARACIÓN Y CONTEOS (Materia Prima vs Producto Final y Lotes)
    List<ProductoLacteo> lista = (List<ProductoLacteo>) request.getAttribute("lacteos");
    List<LoteProduccion> lotes = (List<LoteProduccion>) request.getAttribute("lotes");
    
    double stockMateriaPrima = 0.0;
    int tiposProductosFinales = 0;
    int lotesActivos = 0;
    
    if(lista != null && !lista.isEmpty()) {
        for(ProductoLacteo p : lista) {
            if("LAC-001".equals(p.getCodigo())) {
                stockMateriaPrima = p.getStock();
            } else {
                tiposProductosFinales++;
            }
        }
    }
    
    if(lotes != null && !lotes.isEmpty()) {
        for(LoteProduccion l : lotes) {
            if("En Producción".equals(l.getEstado())) {
                lotesActivos++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fábrica y Lácteos | Finca La Rosa</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            --brand-main: #1C7345;
            --brand-hover: #165c37;
            --brand-accent: #00A859;
            --brand-light: #eaf6ee;
            --text-dark: #2b3445;
        }

        body { font-family: 'Montserrat', sans-serif; background-color: #f4f7f6; color: var(--text-dark); }
        
        /* Stats Cards */
        .card-stat { background: rgba(255, 255, 255, 0.95); border-radius: 20px; padding: 20px; border: 1px solid #e0e8e3; box-shadow: 0 10px 30px rgba(28,115,69,0.05); display: flex; align-items: center; gap: 15px; height: 100%; transition: transform 0.3s; }
        .card-stat:hover { transform: translateY(-5px); }
        .icon-box { width: 50px; height: 50px; border-radius: 14px; display: flex; justify-content: center; align-items: center; font-size: 1.5rem; flex-shrink: 0; }
        
        /* Contenedor Principal */
        .module-container { background: rgba(255, 255, 255, 0.95); border: 1px solid rgba(255,255,255,0.6); border-radius: 24px; padding: 24px; box-shadow: 0 15px 40px rgba(0,0,0,0.04); }
        
        /* Tabs Personalizados (Pestañas) */
        .nav-pills .nav-link { color: #6c757d; font-weight: 600; border-radius: 50px; padding: 10px 25px; transition: all 0.3s ease; }
        .nav-pills .nav-link.active, .nav-pills .show > .nav-link { color: #fff; background-color: var(--brand-main); box-shadow: 0 5px 15px rgba(28, 115, 69, 0.3); }
        .nav-pills .nav-link:hover:not(.active) { background-color: var(--brand-light); color: var(--brand-main); }

        /* Tablas */
        .table-clean th { border-top: none; font-size: 0.75rem; text-transform: uppercase; color: #888; font-weight: 700; border-bottom: 2px solid #f1f1f1; padding-bottom: 15px; }
        .table-clean td { font-size: 0.9rem; font-weight: 600; color: #444; vertical-align: middle; border-bottom: 1px solid #f8f9fa; padding: 15px 5px; }

        /* Clases Globales */
        .text-brand { color: var(--brand-main) !important; }
        .bg-brand { background-color: var(--brand-main) !important; color: white !important; }
        .btn-brand { background-color: var(--brand-main); color: white; border: none; font-weight: 700; transition: all 0.3s ease; border-radius: 50px; }
        .btn-brand:hover { background-color: var(--brand-hover); color: white; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(28, 115, 69, 0.25); }

        .form-control, .form-select { border-radius: 12px; border: 1px solid #dce3df; background: #f9fbf9; padding: 12px 15px; transition: all 0.3s ease;}
        .form-control:focus, .form-select:focus { background: #ffffff; border-color: var(--brand-main); box-shadow: 0 0 0 4px rgba(28, 115, 69, 0.15); outline: none; }
        
        .modal-content { border-radius: 24px; border: none; box-shadow: 0 25px 50px rgba(0,0,0,0.15); }
        .modal-header { background: var(--brand-light); border-bottom: 1px solid #dce3df; border-radius: 24px 24px 0 0; }
        
        /* Badges Catálogo */
        .badge-materia { background-color: #e0f2fe; color: #0369a1; border: 1px solid #bae6fd; font-weight: 700; padding: 6px 12px; border-radius: 8px; }
        .badge-final { background-color: #eaf6ee; color: #1C7345; border: 1px solid #cde6d7; font-weight: 700; padding: 6px 12px; border-radius: 8px; }

        div:where(.swal2-container) div:where(.swal2-popup) { border-radius: 24px; font-family: 'Montserrat', sans-serif; }
        div:where(.swal2-container) button:where(.swal2-styled) { border-radius: 12px; font-weight: 600; padding: 10px 24px; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<% if(request.getAttribute("successMessage") != null) { %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            Swal.fire({ icon: 'success', title: '¡Éxito!', text: '<%= request.getAttribute("successMessage") %>', confirmButtonColor: '#1C7345', timer: 3000 });
        });
    </script>
<% } %>

<% if(request.getAttribute("errorMessage") != null) { %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            Swal.fire({ icon: 'error', title: 'Atención', text: '<%= request.getAttribute("errorMessage") %>', confirmButtonColor: '#dc3545' });
        });
    </script>
<% } %>

<div class="container-fluid px-4 py-4">
    
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
        <div>
            <h3 class="fw-bolder text-dark mb-0">Fábrica de Lácteos</h3>
            <span class="text-muted" style="font-size: 0.9rem;">Gestión de producción, lotes y catálogo de ventas</span>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-success fw-bold rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#modalLote">
                <i class="bi bi-gear-wide-connected me-2"></i> Nuevo Lote
            </button>
            <button class="btn btn-brand px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalLacteo">
                <i class="bi bi-plus-lg me-2"></i> Nuevo Producto
            </button>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="card-stat">
                <div class="icon-box" style="background: #e0f2fe; color: #0369a1;">
                    <i class="bi bi-droplet-fill"></i>
                </div>
                <div>
                    <span class="text-muted fw-bold d-block text-uppercase" style="font-size: 0.70rem;">Materia Prima (Insumo)</span>
                    <h4 class="fw-bolder text-dark mb-0"><%= stockMateriaPrima %> <span class="fs-6 fw-normal text-muted">Litros</span></h4>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-stat">
                <div class="icon-box" style="background: #fff3cd; color: #ffc107;">
                    <i class="bi bi-gear-fill"></i>
                </div>
                <div>
                    <span class="text-muted fw-bold d-block text-uppercase" style="font-size: 0.70rem;">Lotes Activos</span>
                    <h4 class="fw-bolder text-dark mb-0"><%= lotesActivos %> <span class="fs-6 fw-normal text-muted">En producción</span></h4>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-stat">
                <div class="icon-box" style="background: #eaf6ee; color: #1C7345;">
                    <i class="bi bi-basket-fill"></i>
                </div>
                <div>
                    <span class="text-muted fw-bold d-block text-uppercase" style="font-size: 0.70rem;">Productos Comerciales</span>
                    <h4 class="fw-bolder text-dark mb-0"><%= tiposProductosFinales %> <span class="fs-6 fw-normal text-muted">En catálogo</span></h4>
                </div>
            </div>
        </div>
    </div>

    <div class="module-container">
        <ul class="nav nav-pills mb-4 pb-2 border-bottom" id="pills-tab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="pills-catalogo-tab" data-bs-toggle="pill" data-bs-target="#pills-catalogo" type="button" role="tab">
                    <i class="bi bi-shop me-1"></i> Catálogo de Productos
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="pills-lotes-tab" data-bs-toggle="pill" data-bs-target="#pills-lotes" type="button" role="tab">
                    <i class="bi bi-ui-checks me-1"></i> Lotes de Producción
                </button>
            </li>
        </ul>

        <div class="tab-content" id="pills-tabContent">
            
            <div class="tab-pane fade show active" id="pills-catalogo" role="tabpanel">
                <div class="table-responsive">
                    <table class="table table-clean table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Producto</th>
                                <th>Clasificación</th>
                                <th>Stock Físico</th>
                                <th>Precio de Venta</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if(lista != null && !lista.isEmpty()) {
                                    for(ProductoLacteo p : lista) {
                                        boolean isMateriaPrima = "LAC-001".equals(p.getCodigo());
                            %>
                            <tr>
                                <td><strong class="text-secondary"><%= p.getCodigo() %></strong></td>
                                <td>
                                    <strong class="d-block text-dark mb-1"><%= p.getNombre() %></strong>
                                    <span class="text-muted" style="font-size: 0.8rem; font-weight: 500;"><%= p.getDescripcion() %></span>
                                </td>
                                <td>
                                    <% if(isMateriaPrima) { %>
                                        <span class="badge-materia"><i class="bi bi-funnel-fill me-1"></i> Materia Prima</span>
                                    <% } else { %>
                                        <span class="badge-final"><i class="bi bi-box-seam-fill me-1"></i> Producto Final</span>
                                    <% } %>
                                </td>
                                <td>
                                    <span class="badge <%= p.getStock() > 0 ? "bg-brand" : "bg-danger" %> rounded-pill px-3 py-2 fs-6 shadow-sm">
                                        <%= p.getStock() %> <%= p.getUnidadMedida() %>
                                    </span>
                                </td>
                                <td class="fw-bold text-dark fs-5">
                                    $<%= String.format("%,.0f", p.getPrecioUnitario()) %>
                                </td>
                                <td class="text-center">
                                    <% if (!isMateriaPrima) { %>
                                    <form action="lacteos" method="POST" class="d-inline" id="formDelete_<%= p.getIdProducto() %>">
                                        <input type="hidden" name="action" value="delete_producto">
                                        <input type="hidden" name="id" value="<%= p.getIdProducto() %>">
                                        <button type="button" class="btn btn-sm btn-outline-danger rounded-pill px-3" onclick="confirmarEliminacion('<%= p.getIdProducto() %>', '<%= p.getNombre() %>')">
                                            <i class="bi bi-trash3-fill"></i>
                                        </button>
                                    </form>
                                    <% } else { %>
                                        <span class="text-muted" style="font-size: 0.75rem; font-weight: 700;" title="La Materia Prima se nutre automáticamente de los ordeños"><i class="bi bi-lock-fill"></i> Protegido</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr><td colspan="6" class="text-center py-5 text-muted"><i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>No hay productos registrados en el catálogo.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="tab-pane fade" id="pills-lotes" role="tabpanel">
                <div class="table-responsive">
                    <table class="table table-clean table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Lote #</th>
                                <th>Producto a Fabricar</th>
                                <th>Meta (Cantidad)</th>
                                <th>Leche Invertida</th>
                                <th>Estado Actual</th>
                                <th class="text-center">Acción Requerida</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if(lotes != null && !lotes.isEmpty()) {
                                    for(LoteProduccion lote : lotes) {
                                        String badgeClass = "";
                                        if("En Producción".equals(lote.getEstado())) badgeClass = "bg-warning text-dark";
                                        else if("Terminado".equals(lote.getEstado())) badgeClass = "bg-info text-dark";
                                        else if("En Venta".equals(lote.getEstado())) badgeClass = "bg-brand";
                            %>
                            <tr>
                                <td class="fw-bold text-muted">L-<%= String.format("%04d", lote.getIdLote()) %></td>
                                <td class="fw-bold text-dark fs-6"><%= lote.getNombreProducto() %></td>
                                <td><span class="badge bg-light text-dark border px-3 py-2"><%= lote.getCantidad() %> unidades/kg</span></td>
                                <td><span class="text-danger fw-bold"><i class="bi bi-droplet-fill me-1"></i> - <%= lote.getLitrosLecheUsados() %> L</span></td>
                                <td><span class="badge <%= badgeClass %> px-3 py-2 shadow-sm"><%= lote.getEstado() %></span></td>
                                <td class="text-center">
                                    <form action="lacteos" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="estado_lote">
                                        <input type="hidden" name="idLote" value="<%= lote.getIdLote() %>">
                                        
                                        <% if("En Producción".equals(lote.getEstado())) { %>
                                            <input type="hidden" name="nuevoEstado" value="Terminado">
                                            <button type="submit" class="btn btn-sm btn-info fw-bold rounded-pill shadow-sm px-3"><i class="bi bi-check-circle-fill me-1"></i> Marcar Producto Hecho</button>
                                        <% } else if("Terminado".equals(lote.getEstado())) { %>
                                            <input type="hidden" name="nuevoEstado" value="En Venta">
                                            <button type="submit" class="btn btn-sm btn-success fw-bold rounded-pill shadow-sm px-3"><i class="bi bi-shop me-1"></i> Poner en Venta</button>
                                        <% } else if("En Venta".equals(lote.getEstado())) { %>
                                            <span class="text-success fw-bold small"><i class="bi bi-check-all"></i> En Catálogo</span>
                                        <% } %>
                                    </form>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr><td colspan="6" class="text-center py-5 text-muted"><i class="bi bi-gear fs-1 d-block mb-3 opacity-50"></i>No hay lotes en producción actualmente.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</div>

<div class="modal fade" id="modalLacteo" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header pb-3">
                <h5 class="modal-title fw-bold text-brand"><i class="bi bi-box-seam me-2"></i> Crear Producto Final</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="lacteos" method="POST">
                <input type="hidden" name="action" value="add_producto">
                <div class="modal-body px-4 py-4">
                    
                    <div class="alert alert-info border-0 rounded-3 mb-4" style="background-color: #e0f2fe; color: #0369a1; font-size: 0.85rem; font-weight: 500;">
                        <i class="bi bi-info-circle-fill me-1"></i> La <strong>Materia Prima</strong> se actualiza automáticamente con cada sesión de ordeño.
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase ms-1">Código Interno</label>
                        <input type="text" name="codigo" class="form-control" placeholder="Ej: QUES-01" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase ms-1">Nombre Comercial</label>
                        <input type="text" name="nombre" class="form-control" placeholder="Ej: Queso Campesino 500g" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase ms-1">Descripción</label>
                        <input type="text" name="descripcion" class="form-control" required>
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-bold text-muted text-uppercase ms-1">Medida</label>
                            <select name="unidadMedida" class="form-select fw-bold" required>
                                <option value="Unidades">Unidades</option>
                                <option value="Kg">Kilogramos</option>
                                <option value="Litros">Litros</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-bold text-muted text-uppercase ms-1">Stock Físico</label>
                            <input type="number" step="0.01" name="stock" class="form-control fw-bold text-dark" value="0" required>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-bold text-muted text-uppercase ms-1">Precio Unitario ($)</label>
                        <input type="number" step="0.01" name="precioUnitario" class="form-control fw-bold text-brand fs-5" required>
                    </div>
                </div>
                <div class="modal-footer border-0 px-4 pb-4">
                    <button type="button" class="btn btn-light fw-bold px-4 rounded-pill" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-brand px-5 rounded-pill shadow-sm"><i class="bi bi-check2-circle me-2"></i> Guardar Catálogo</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="modalLote" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header border-0 bg-brand text-white pb-3" style="border-radius: 24px 24px 0 0;">
                <h5 class="modal-title fw-bold"><i class="bi bi-gear-fill me-2"></i> Iniciar Producción en Fábrica</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="lacteos" method="POST">
                <input type="hidden" name="action" value="iniciar_lote">
                <div class="modal-body px-4 py-4">
                    <div class="mb-4">
                        <label class="form-label small fw-bold text-muted text-uppercase ms-1">¿Qué producto vas a fabricar?</label>
                        <select name="idProducto" class="form-select fw-bold border-brand" required>
                            <% 
                                if(lista != null) {
                                    for(ProductoLacteo p : lista) {
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
                            <label class="form-label small fw-bold text-muted text-uppercase ms-1">Leche Invertida (L)</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0 text-danger"><i class="bi bi-droplet-fill"></i></span>
                                <input type="number" step="0.01" name="litrosLecheUsados" class="form-control border-start-0 text-danger fw-bold" required placeholder="Ej: 50">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted text-uppercase ms-1">Estimado a Producir</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0 text-brand"><i class="bi bi-box-seam-fill"></i></span>
                                <input type="number" step="0.01" name="cantidad" class="form-control border-start-0 text-brand fw-bold" required placeholder="Ej: 5">
                            </div>
                        </div>
                    </div>
                    <div class="alert alert-warning small mt-4 border-0 bg-warning-subtle text-dark fw-medium">
                        <i class="bi bi-exclamation-triangle-fill text-warning me-2"></i> Los litros indicados serán descontados del Tanque de Leche (LAC-001) automáticamente.
                    </div>
                </div>
                <div class="modal-footer border-0 px-4 pb-4">
                    <button type="button" class="btn btn-light fw-bold px-4 rounded-pill" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-brand px-5 rounded-pill shadow-sm w-100 mt-2"><i class="bi bi-play-circle-fill me-2"></i> Iniciar Proceso de Fábrica</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function confirmarEliminacion(idForm, nombreProd) {
        Swal.fire({
            title: '¿Retirar Producto?',
            html: `Estás a punto de eliminar <b>${nombreProd}</b> del catálogo de ventas.`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Sí, Eliminar Producto',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('formDelete_' + idForm).submit();
            }
        });
    }
</script>
</body>
</html>