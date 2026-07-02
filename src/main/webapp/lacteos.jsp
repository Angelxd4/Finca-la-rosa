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
    <jsp:include page="includes/header.jsp" />
    <title>Fábrica y Lácteos | Finca La Rosa</title>
    
    <style>
        body {
            background: linear-gradient(135deg, #F3F5E7 0%, #e0e5d1 100%) !important;
        }
        
        html[data-theme="dark"] body {
            background: linear-gradient(135deg, #09090b 0%, #18181b 100%) !important;
        }

        /* Estilos específicos de Lácteos */
        .card-stat { background: var(--bg-card); border-radius: 20px; padding: 20px; border: 1px solid var(--border-subtle); box-shadow: 0 10px 25px rgba(66, 57, 38, 0.05); display: flex; align-items: center; gap: 15px; height: 100%; transition: transform 0.3s; }
        .card-stat:hover { transform: translateY(-5px); border-color: var(--brand-accent); }
        .icon-box { width: 55px; height: 55px; border-radius: 14px; display: flex; justify-content: center; align-items: center; font-size: 1.6rem; flex-shrink: 0; }
        
        /* Contenedor Principal */
        .module-container { background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: 24px; padding: 24px; box-shadow: var(--shadow-finca); }
        html[data-theme="dark"] .module-container, html[data-theme="dark"] .card-stat { background: rgba(24, 24, 27, 0.7); backdrop-filter: blur(12px); border-color: rgba(255, 255, 255, 0.1); }
        
        /* Tabs Personalizados (Pestañas) */
        .apple-tabs-wrapper { background: var(--bg-page); padding: 6px; border-radius: 18px; display: inline-flex; border: 1px solid var(--border-subtle); }
        .nav-pills { gap: 5px; }
        .nav-pills .nav-link { color: var(--drab); font-weight: 700; border-radius: 14px; padding: 10px 24px; transition: all 0.3s ease; }
        .nav-pills .nav-link.active, .nav-pills .show > .nav-link { color: var(--moss); background-color: var(--sage); border: 1px solid var(--moss); box-shadow: 0 4px 10px rgba(70, 71, 4, 0.15); }
        .nav-pills .nav-link:hover:not(.active) { color: var(--moss); }

        /* Tablas Limpias */
        .table-custom-wrapper { border-radius: 16px; overflow: hidden; border: 1px solid var(--border-subtle); background: var(--bg-card); }
        html[data-theme="dark"] .table-custom-wrapper { background: rgba(24, 24, 27, 0.8); }
        .table-clean th { background-color: rgba(70, 71, 4, 0.05); color: var(--moss); font-weight: 800; font-size: 0.75rem; text-transform: uppercase; border-bottom: 2px solid var(--brand-accent); padding: 18px 15px; letter-spacing: 1px; }
        html[data-theme="dark"] .table-clean th { background-color: rgba(255, 255, 255, 0.05); }
        .table-clean td { vertical-align: middle; padding: 16px 15px; color: var(--text-main); font-weight: 600; font-size: 0.95rem; border-bottom: 1px solid var(--border-subtle); }
        html[data-theme="dark"] .table-clean td { border-bottom: 1px solid rgba(255,255,255,0.05); }
        .table-hover tbody tr:hover td { background-color: var(--bg-page); }
        html[data-theme="dark"] .table-hover tbody tr:hover td { background-color: rgba(255,255,255,0.05); }

        /* Botones Paleta */
        .btn-brand { background-color: var(--brand-primary) !important; color: white !important; border: none; font-weight: 700; border-radius: 12px; transition: all 0.2s ease; }
        .btn-brand:hover { background-color: var(--brand-dark) !important; transform: translateY(-2px); box-shadow: 0 8px 15px rgba(66, 57, 38, 0.2); }
        
        .btn-outline-brand { color: var(--brand-dark) !important; border: 2px solid var(--brand-accent) !important; font-weight: 700; background: var(--bg-card); border-radius: 12px; transition: all 0.2s ease;}
        .btn-outline-brand:hover { background-color: var(--brand-accent) !important; color: var(--brand-dark) !important; transform: translateY(-2px); border-color: transparent !important; box-shadow: 0 6px 15px rgba(183, 167, 140, 0.25); }

        /* Formularios y Modales */
        .form-control, .form-select { border-radius: 14px; border: 1px solid var(--border-subtle); background: var(--bg-page); color: var(--text-main); padding: 12px 15px; transition: all 0.3s ease; font-weight: 600;}
        .form-control:focus, .form-select:focus { background: #ffffff; border-color: var(--brand-primary); box-shadow: 0 0 0 4px rgba(70, 71, 4, 0.15); outline: none; }
        
        .modal-content { border-radius: 28px; border: none; background: var(--bg-card); box-shadow: 0 25px 50px -12px rgba(66, 57, 38, 0.25); }
        .modal-header, .modal-footer { border: none !important; }
        
        /* Badges Catálogo & Lotes */
        .badge-materia { background-color: var(--brand-accent); color: var(--brand-dark); font-weight: 800; padding: 6px 12px; border-radius: 8px; border: 1px solid var(--brand-dark); }
        .badge-final { background-color: var(--brand-info); color: white; font-weight: 800; padding: 6px 12px; border-radius: 8px; border: 1px solid var(--brand-primary); }
        
        /* Lotes Status */
        .badge-lote-prod { background-color: var(--brand-accent); color: var(--brand-dark); }
        .badge-lote-term { background-color: var(--brand-info); color: white; }
        .badge-lote-venta { background-color: var(--brand-primary); color: white; }

        div:where(.swal2-container) div:where(.swal2-popup) { border-radius: 24px; font-family: 'Inter', sans-serif; background: var(--bg-card); }
        div:where(.swal2-container) button:where(.swal2-styled) { border-radius: 12px; font-weight: 700; padding: 10px 24px; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<% if(request.getAttribute("successMessage") != null) { %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            Swal.fire({ icon: 'success', title: '¡Éxito!', text: '<%= request.getAttribute("successMessage") %>', confirmButtonColor: '#464704', timer: 3000 });
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
    
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mb-4 pb-2 border-bottom" style="border-color: var(--border-subtle) !important; gap: 15px;">
        <div class="text-center text-md-start">
            <h3 class="fw-bolder mb-0" style="color: var(--brand-dark);">Fábrica de Lácteos</h3>
            <span class="fw-bold" style="font-size: 0.9rem; color: var(--text-subtle);">Gestión de producción, lotes y catálogo de ventas</span>
        </div>
        <div class="d-flex flex-column flex-sm-row gap-2 w-100 w-md-auto">
            <button class="btn btn-outline-brand fw-bold px-4 w-100 w-md-auto" data-bs-toggle="modal" data-bs-target="#modalLote">
                <i class="bi bi-gear-wide-connected me-2"></i> Nuevo Lote
            </button>
            <button class="btn btn-brand px-4 shadow-sm w-100 w-md-auto" data-bs-toggle="modal" data-bs-target="#modalLacteo">
                <i class="bi bi-plus-lg me-2"></i> Nuevo Producto
            </button>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="card-stat">
                <div class="icon-box" style="background: var(--brand-accent); color: var(--brand-dark);">
                    <i class="bi bi-droplet-fill"></i>
                </div>
                <div>
                    <span class="fw-bold d-block text-uppercase" style="font-size: 0.70rem; color: var(--text-subtle);">Materia Prima (Leche Cruda)</span>
                    <h4 class="fw-bolder mb-0" style="color: var(--brand-primary);"><%= stockMateriaPrima %> <span class="fs-6 fw-normal text-muted">Litros</span></h4>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-stat">
                <div class="icon-box" style="background: var(--brand-info); color: white;">
                    <i class="bi bi-gear-fill"></i>
                </div>
                <div>
                    <span class="fw-bold d-block text-uppercase" style="font-size: 0.70rem; color: var(--text-subtle);">Lotes Activos</span>
                    <h4 class="fw-bolder mb-0" style="color: var(--brand-primary);"><%= lotesActivos %> <span class="fs-6 fw-normal text-muted">En producción</span></h4>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-stat">
                <div class="icon-box" style="background: var(--brand-primary); color: white;">
                    <i class="bi bi-basket-fill"></i>
                </div>
                <div>
                    <span class="fw-bold d-block text-uppercase" style="font-size: 0.70rem; color: var(--text-subtle);">Productos Comerciales</span>
                    <h4 class="fw-bolder mb-0" style="color: var(--brand-primary);"><%= tiposProductosFinales %> <span class="fs-6 fw-normal text-muted">En catálogo</span></h4>
                </div>
            </div>
        </div>
    </div>

    <div class="module-container">
        <div class="apple-tabs-wrapper mb-4">
            <ul class="nav nav-pills" id="pills-tab" role="tablist">
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
        </div>

        <div class="tab-content" id="pills-tabContent">
            
            <div class="tab-pane fade show active" id="pills-catalogo" role="tabpanel">
                <div class="table-responsive table-custom-wrapper shadow-sm">
                    <table class="table table-clean table-hover align-middle mb-0">
                        <thead class="text-center">
                            <tr>
                                <th>Código</th>
                                <th>Producto</th>
                                <th>Clasificación</th>
                                <th>Stock Físico</th>
                                <th>Precio de Venta</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody class="text-center">
                            <% 
                                if(lista != null && !lista.isEmpty()) {
                                    for(ProductoLacteo p : lista) {
                                        boolean isMateriaPrima = "LAC-001".equals(p.getCodigo());
                            %>
                            <tr>
                                <td><strong style="color: var(--text-subtle);"><%= p.getCodigo() %></strong></td>
                                <td class="text-start ps-4">
                                    <strong class="d-block mb-1" style="color: var(--brand-primary); font-size: 1.05rem;"><%= p.getNombre() %></strong>
                                    <span style="font-size: 0.8rem; font-weight: 600; color: var(--text-subtle);"><%= p.getDescripcion() %></span>
                                </td>
                                <td>
                                    <% if(isMateriaPrima) { %>
                                        <span class="badge-materia"><i class="bi bi-funnel-fill me-1"></i> Materia Prima</span>
                                    <% } else { %>
                                        <span class="badge-final"><i class="bi bi-box-seam-fill me-1"></i> Producto Final</span>
                                    <% } %>
                                </td>
                                <td>
                                    <span class="badge <%= p.getStock() > 0 ? "bg-brand" : "bg-danger" %> rounded-pill px-3 py-2 fs-6 shadow-sm" style="background-color: <%= p.getStock() > 0 ? "var(--brand-primary)" : "#dc3545" %>;">
                                        <%= p.getStock() %> <%= p.getUnidadMedida() %>
                                    </span>
                                </td>
                                <td class="fw-bolder fs-5" style="color: var(--brand-dark);">
                                    $<%= String.format("%,.0f", p.getPrecioUnitario()) %>
                                </td>
                                <td>
                                    <% if (!isMateriaPrima) { %>
                                    <div class="d-flex gap-2 justify-content-center">
                                        <a href="trazabilidad.jsp?lote=<%= p.getCodigo() %>" target="_blank" class="btn btn-sm btn-outline-brand rounded-pill px-3 fw-bold">
                                            <i class="bi bi-qr-code-scan"></i> Trazabilidad
                                        </a>
                                        <form action="lacteos" method="POST" class="d-inline" id="formDelete_<%= p.getIdProducto() %>">
                                            <input type="hidden" name="action" value="delete_producto">
                                            <input type="hidden" name="id" value="<%= p.getIdProducto() %>">
                                            <button type="button" class="btn btn-sm btn-outline-danger rounded-pill px-3 fw-bold" onclick="confirmarEliminacion('<%= p.getIdProducto() %>', '<%= p.getNombre() %>')">
                                                <i class="bi bi-trash3-fill"></i> Retirar
                                            </button>
                                        </form>
                                    </div>
                                    <% } else { %>
                                        <span class="fw-bold" style="font-size: 0.8rem; color: var(--text-subtle);" title="La Materia Prima se nutre automáticamente de los ordeños"><i class="bi bi-lock-fill"></i> Reservado de Ordeño</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr><td colspan="6" class="text-center py-5"><i class="bi bi-inbox fs-1 d-block mb-3" style="color: var(--brand-accent);"></i><span class="fw-bold text-muted">No hay productos registrados.</span></td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="tab-pane fade" id="pills-lotes" role="tabpanel">
                <div class="table-responsive table-custom-wrapper shadow-sm">
                    <table class="table table-clean table-hover align-middle mb-0">
                        <thead class="text-center">
                            <tr>
                                <th>Lote #</th>
                                <th>Producto a Fabricar</th>
                                <th>Meta (Cantidad)</th>
                                <th>Leche Invertida</th>
                                <th>Estado Actual</th>
                                <th>Acción Requerida</th>
                            </tr>
                        </thead>
                        <tbody class="text-center">
                            <% 
                                if(lotes != null && !lotes.isEmpty()) {
                                    for(LoteProduccion lote : lotes) {
                                        String badgeClass = "";
                                        if("En Producción".equals(lote.getEstado())) badgeClass = "badge-lote-prod border border-dark";
                                        else if("Terminado".equals(lote.getEstado())) badgeClass = "badge-lote-term border border-dark";
                                        else if("En Venta".equals(lote.getEstado())) badgeClass = "badge-lote-venta";
                            %>
                            <tr>
                                <td><strong style="color: var(--text-subtle);">L-<%= String.format("%04d", lote.getIdLote()) %></strong></td>
                                <td class="fw-bolder fs-6" style="color: var(--brand-dark);"><%= lote.getNombreProducto() %></td>
                                <td><span class="badge border px-3 py-2 text-dark" style="background-color: var(--bg-page); border-color: var(--border-subtle) !important;"><%= lote.getCantidad() %> unidades/kg</span></td>
                                <td><span class="text-danger fw-bolder"><i class="bi bi-droplet-fill me-1"></i> - <%= lote.getLitrosLecheUsados() %> L</span></td>
                                <td><span class="badge <%= badgeClass %> px-3 py-2 shadow-sm fs-6"><%= lote.getEstado() %></span></td>
                                <td>
                                    <form action="lacteos" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="estado_lote">
                                        <input type="hidden" name="idLote" value="<%= lote.getIdLote() %>">
                                        
                                        <% if("En Producción".equals(lote.getEstado())) { %>
                                            <input type="hidden" name="nuevoEstado" value="Terminado">
                                            <button type="submit" class="btn btn-sm text-white fw-bold rounded-pill shadow-sm px-3" style="background-color: var(--brand-info);"><i class="bi bi-check-circle-fill me-1"></i> Marcar Terminado</button>
                                        <% } else if("Terminado".equals(lote.getEstado())) { %>
                                            <input type="hidden" name="nuevoEstado" value="En Venta">
                                            <button type="submit" class="btn btn-sm text-white fw-bold rounded-pill shadow-sm px-3" style="background-color: var(--brand-primary);"><i class="bi bi-shop me-1"></i> Poner en Venta</button>
                                        <% } else if("En Venta".equals(lote.getEstado())) { %>
                                            <span class="fw-bolder small" style="color: var(--brand-primary);"><i class="bi bi-check-all"></i> En Catálogo</span>
                                        <% } %>
                                    </form>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr><td colspan="6" class="text-center py-5"><i class="bi bi-gear fs-1 d-block mb-3" style="color: var(--brand-accent);"></i><span class="fw-bold text-muted">No hay lotes en producción.</span></td></tr>
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
            <div class="modal-header pb-3 px-4 mt-2 bg-white" style="border-bottom: 2px solid var(--sage) !important; border-radius: 28px 28px 0 0;">
                <h4 class="modal-title fw-bolder" style="color: var(--brand-primary);"><i class="bi bi-box-seam me-2"></i> Crear Producto Final</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="lacteos" method="POST">
                <input type="hidden" name="action" value="add_producto">
                <div class="modal-body px-4 py-4">
                    
                    <div class="alert border-0 rounded-4 mb-4 shadow-sm" style="background-color: var(--brand-info); color: white; font-size: 0.85rem; font-weight: 600;">
                        <i class="bi bi-info-circle-fill me-1"></i> Recuerda: La <strong>Materia Prima</strong> se actualiza automáticamente con cada ordeño. Usa este panel solo para registrar productos transformados.
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Código Interno</label>
                        <input type="text" name="codigo" class="form-control" placeholder="Ej: QUES-01" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Nombre Comercial</label>
                        <input type="text" name="nombre" class="form-control" placeholder="Ej: Queso Campesino 500g" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Descripción</label>
                        <input type="text" name="descripcion" class="form-control" required>
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Medida</label>
                            <select name="unidadMedida" class="form-select fw-bold" required>
                                <option value="Unidades">Unidades</option>
                                <option value="Kg">Kilogramos</option>
                                <option value="Litros">Litros</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Stock Inicial Físico</label>
                            <input type="number" step="0.01" name="stock" class="form-control fw-bold text-dark" value="0" required>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Precio Unitario Venta ($)</label>
                        <input type="number" step="0.01" name="precioUnitario" class="form-control fw-bolder fs-5" style="color: var(--brand-primary);" required>
                    </div>
                </div>
                <div class="modal-footer border-0 px-4 pb-4 bg-white" style="border-top: 1px solid var(--border-subtle) !important; border-radius: 0 0 28px 28px;">
                    <button type="button" class="btn btn-outline-brand px-4" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-brand px-5 shadow-sm"><i class="bi bi-check2-circle me-2"></i> Guardar Catálogo</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="modalLote" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header border-0 pb-3 px-4 mt-2" style="background-color: var(--brand-primary); border-radius: 24px 24px 0 0;">
                <h5 class="modal-title fw-bolder text-white"><i class="bi bi-gear-fill me-2" style="color: var(--brand-accent);"></i> Iniciar Producción de Lote</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="lacteos" method="POST">
                <input type="hidden" name="action" value="iniciar_lote">
                <div class="modal-body px-4 py-4" style="background-color: var(--bg-card);">
                    
                    <div class="mb-4 p-3 rounded-4 border" style="background-color: var(--bg-page); border-color: var(--border-subtle) !important;">
                        <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">1. ¿Qué producto vas a fabricar?</label>
                        <select name="idProducto" class="form-select fw-bold border-brand bg-white" required>
                            <option value="" disabled selected>Seleccione producto del catálogo...</option>
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
                            <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Leche a Invertir (L)</label>
                            <div class="input-group shadow-sm" style="border-radius: 14px; overflow: hidden; border: 1px solid var(--border-subtle);">
                                <span class="input-group-text bg-white border-0 text-danger"><i class="bi bi-droplet-fill"></i></span>
                                <input type="number" step="0.01" name="litrosLecheUsados" class="form-control border-0 text-danger fw-bolder" required placeholder="Ej: 50">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Meta a Producir</label>
                            <div class="input-group shadow-sm" style="border-radius: 14px; overflow: hidden; border: 1px solid var(--border-subtle);">
                                <span class="input-group-text bg-white border-0" style="color: var(--brand-primary);"><i class="bi bi-box-seam-fill"></i></span>
                                <input type="number" step="0.01" name="cantidad" class="form-control border-0 fw-bolder" style="color: var(--brand-primary);" required placeholder="Ej: 5">
                            </div>
                        </div>
                    </div>
                    
                    <div class="alert mt-4 border-0 rounded-4 shadow-sm" style="background-color: var(--brand-accent); color: var(--brand-dark); font-weight: 600; font-size: 0.85rem;">
                        <i class="bi bi-exclamation-triangle-fill me-2" style="color: var(--brand-dark);"></i> 
                        <strong>Atención:</strong> Los litros de leche invertidos serán descontados del Tanque Principal automáticamente.
                    </div>
                </div>
                <div class="modal-footer border-0 px-4 pb-4" style="background-color: var(--bg-card); border-radius: 0 0 24px 24px;">
                    <button type="button" class="btn btn-outline-brand fw-bold px-4 rounded-pill" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-brand px-4 rounded-pill shadow-sm"><i class="bi bi-play-circle-fill me-2 text-white"></i> Iniciar Proceso</button>
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
            cancelButtonColor: '#B7A78C',
            confirmButtonText: 'Sí, Eliminar Producto',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('formDelete_' + idForm).submit();
            }
        });
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<jsp:include page="includes/footer.jsp" />