<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.finca.models.Bovino" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Inventario Ganadero | Finca</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f7f6; }
        .main-card { background: #fff; border-radius: 0 0 16px 16px; padding: 25px; box-shadow: 0 8px 25px rgba(0,0,0,0.05); border: 1px solid #eaebec; border-top: none; }
        .nav-tabs { border-bottom: none; gap: 5px; margin-top: 15px; }
        .nav-tabs .nav-link { color: #6c757d; font-weight: 600; border: 1px solid transparent; border-radius: 12px 12px 0 0; padding: 14px 24px; transition: all 0.3s ease; background-color: #e9ecef; }
        .nav-tabs .nav-link:hover { background-color: #dee2e6; color: #198754; }
        .nav-tabs .nav-link.active { color: #fff; font-weight: 700; background-color: #198754; border-color: #198754; box-shadow: 0 -4px 15px rgba(25, 135, 84, 0.15); }
        
        .table-custom-wrapper { border-radius: 12px; overflow: hidden; border: 1px solid #eaebec; }
        .table { margin-bottom: 0; }
        .table th { white-space: nowrap; font-weight: 700; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px; padding: 16px 15px; border-bottom: 2px solid #dee2e6; }
        .table td { vertical-align: middle; padding: 14px 15px; color: #495057; font-size: 0.95rem; }
        .table-hover tbody tr { transition: all 0.2s ease; border-bottom: 1px solid #f1f3f5; }
        .table-hover tbody tr:hover { background-color: #f8fff9; transform: translateY(-1px); box-shadow: 0 4px 10px rgba(0,0,0,0.02); position: relative; z-index: 1; }
        
        .cow-avatar { width: 48px; height: 48px; object-fit: cover; border-radius: 50%; box-shadow: 0 3px 6px rgba(0,0,0,0.1); transition: transform 0.3s ease; }
        .cow-avatar:hover { transform: scale(1.1); }
        .cow-avatar-placeholder { width: 48px; height: 48px; border-radius: 50%; background: #f8f9fa; border: 2px dashed #ced4da; display: flex; align-items: center; justify-content: center; font-size: 22px; }
        
        .action-btn { transition: all 0.2s ease; border-radius: 8px; width: 34px; height: 34px; display: inline-flex; align-items: center; justify-content: center; padding: 0; }
        .action-btn:hover { transform: translateY(-2px); }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<%
    List<Bovino> listaProd = (List<Bovino>) request.getAttribute("listaProduccion");
    List<Bovino> listaVenta = (List<Bovino>) request.getAttribute("listaVenta");
    List<Bovino> listaTodos = new ArrayList<>();
    
    if(listaProd != null) listaTodos.addAll(listaProd);
    if(listaVenta != null) listaTodos.addAll(listaVenta);
    
    listaTodos.sort((a, b) -> Integer.compare(b.getIdBovino(), a.getIdBovino()));
%>

<div class="container py-5">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mb-2">
        <div>
            <h2 class="fw-bold text-dark mb-1"><i class="bi bi-boxes text-success"></i> Gestión de Inventario</h2>
            <p class="text-muted mb-0">Administración general del ganado de la finca</p>
        </div>
        <button class="btn btn-success btn-lg fw-bold shadow-sm rounded-pill px-4 mt-3 mt-md-0" data-bs-toggle="modal" data-bs-target="#modalBovino">
            <i class="bi bi-plus-circle-fill me-1"></i> Registrar Animal
        </button>
    </div>

    <% if(request.getAttribute("successMessage") != null) { %>
        <div class="alert alert-success alert-dismissible fade show shadow-sm rounded-4 border-0 border-start border-5 border-success mt-3">
            <i class="bi bi-check-circle-fill me-2 fs-5"></i> <strong>¡Éxito!</strong> <%= request.getAttribute("successMessage") %>
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>
    
    <% if(request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show shadow-sm rounded-4 border-0 border-start border-5 border-danger mt-3">
            <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i> <strong>Error:</strong> <%= request.getAttribute("errorMessage") %>
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <ul class="nav nav-tabs" id="inventarioTabs">
        <li class="nav-item">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#todos"><i class="bi bi-collection-fill me-1"></i> Todos los Animales</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#produccion"><i class="bi bi-droplet-fill me-1"></i> Hato Lechero</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#ventas"><i class="bi bi-tags-fill me-1"></i> Lote para Venta</button>
        </li>
    </ul>

    <div class="tab-content main-card">
        <!-- ================= PESTAÑA: TODOS ================= -->
        <div class="tab-pane fade show active" id="todos">
            <div class="table-responsive table-custom-wrapper">
                <table class="table table-hover align-middle">
                    <thead class="table-light text-secondary text-center">
                        <tr>
                            <th>Foto</th>
                            <th>Arete</th>
                            <th>Raza / Género</th>
                            <th>Clasificación</th>
                            <th>Salud</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody class="text-center">
                        <% if(listaTodos != null && !listaTodos.isEmpty()) {
                            for(Bovino b : listaTodos) { %>
                        <tr>
                            <td>
                                <%-- CORRECCIÓN: Evitamos falsos nulos ("null") y armamos la ruta completa --%>
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto" class="cow-avatar border border-2 border-white">
                                <% } else { %>
                                    <div class="cow-avatar-placeholder mx-auto text-secondary">🐄</div>
                                <% } %>
                            </td>
                            <td class="fw-bold fs-5 text-dark"><%= b.getNumeroArete() %></td>
                            <td>
                                <div class="fw-bold text-dark"><%= b.getRaza() %></div>
                                <span class="badge bg-light text-secondary border mt-1"><%= b.getGenero() %></span>
                            </td>
                            <td>
                                <span class="badge <%= b.getClasificacion().equals("Producción") ? "bg-success-subtle text-success border border-success-subtle" : "bg-warning-subtle text-warning-emphasis border border-warning-subtle" %> px-3 py-2 rounded-pill fw-bold">
                                    <%= b.getClasificacion() %>
                                </span>
                            </td>
                            <td>
                                <span class="badge <%= b.getEstadoSalud().equals("Sano") || b.getEstadoSalud().equals("Sana") ? "bg-success" : "bg-danger" %> px-2 py-1 rounded-pill">
                                    <i class="bi <%= b.getEstadoSalud().equals("Sano") || b.getEstadoSalud().equals("Sana") ? "bi-heart-fill" : "bi-bandaid-fill" %>"></i> <%= b.getEstadoSalud() %>
                                </span>
                            </td>
                            <td>
                                <div class="d-flex gap-2 justify-content-center flex-wrap">
                                    <button class="btn btn-info text-white shadow-sm action-btn btn-resumen" 
                                        data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>"
                                        data-bs-toggle="modal" data-bs-target="#modalResumen" title="Vista Rápida"><i class="bi bi-eye-fill"></i></button>

                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success shadow-sm action-btn" title="Historial Médico"><i class="bi bi-journal-medical"></i></a>

                                    <button class="btn btn-primary shadow-sm action-btn btn-editar"
                                        data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>"
                                        data-bs-toggle="modal" data-bs-target="#modalEditarBovino" title="Editar Información"><i class="bi bi-pencil-fill"></i></button>

                                    <% if(b.getClasificacion().equals("Producción")) { %>
                                        <form action="inventario-ganado" method="POST" class="d-inline">
                                            <input type="hidden" name="action" value="mover">
                                            <input type="hidden" name="id" value="<%= b.getIdBovino() %>">
                                            <input type="hidden" name="destino" value="Venta">
                                            <button type="submit" class="btn btn-warning text-dark shadow-sm action-btn" title="Mover a Lote de Venta" onclick="return confirm('¿Mover a lote de venta?');"><i class="bi bi-tag-fill"></i></button>
                                        </form>
                                    <% } else if(b.getClasificacion().equals("Venta") && b.getGenero().equals("Hembra")) { %>
                                        <form action="inventario-ganado" method="POST" class="d-inline">
                                            <input type="hidden" name="action" value="mover">
                                            <input type="hidden" name="id" value="<%= b.getIdBovino() %>">
                                            <input type="hidden" name="destino" value="Producción">
                                            <button type="submit" class="btn btn-success shadow-sm action-btn" title="Regresar a Hato Lechero" onclick="return confirm('¿Regresar a producción?');"><i class="bi bi-droplet-fill"></i></button>
                                        </form>
                                    <% } %>

                                    <form action="inventario-ganado" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= b.getIdBovino() %>">
                                        <button type="submit" class="btn btn-danger shadow-sm action-btn" title="Eliminar Registro" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill"></i></button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr>
                            <td colspan="6" class="text-center py-5">
                                <div class="text-muted">
                                    <i class="bi bi-inbox fs-1 d-block mb-3 text-secondary opacity-50"></i>
                                    <h5 class="fw-bold">No hay animales registrados</h5>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ================= PESTAÑA: HATO LECHERO ================= -->
        <div class="tab-pane fade" id="produccion">
            <div class="table-responsive table-custom-wrapper">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-success text-success text-center" style="border-bottom: 2px solid #a3cfbb;">
                        <tr>
                            <th>Foto</th>
                            <th>Arete</th>
                            <th>Raza / Edad</th>
                            <th>Litros/Día</th>
                            <th>Salud</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody class="text-center">
                        <% if(listaProd != null && !listaProd.isEmpty()) {
                            for(Bovino b : listaProd) { %>
                        <tr>
                            <td>
                                <%-- CORRECCIÓN APLICADA --%>
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto" class="cow-avatar border border-2 border-success">
                                <% } else { %>
                                    <div class="cow-avatar-placeholder mx-auto border border-2 border-success text-success">🐄</div>
                                <% } %>
                            </td>
                            <td class="fw-bold fs-5 text-success"><%= b.getNumeroArete() %></td>
                            <td>
                                <div class="fw-bold text-dark"><%= b.getRaza() %></div>
                                <span class="badge bg-light text-secondary border mt-1"><%= b.getEdadAnios() %> años</span>
                            </td>
                            <td>
                                <div class="bg-success-subtle text-success fw-bold rounded-3 py-1 px-3 d-inline-block">
                                    <i class="bi bi-droplet-half"></i> <%= b.getLitrosDiariosPromedio() %> L
                                </div>
                            </td>
                            <td>
                                <span class="badge <%= b.getEstadoSalud().equals("Sano") || b.getEstadoSalud().equals("Sana") ? "bg-success" : "bg-warning text-dark" %> rounded-pill px-3 py-1">
                                    <%= b.getEstadoSalud() %>
                                </span>
                            </td>
                            <td>
                                <div class="d-flex gap-2 justify-content-center flex-wrap">
                                    <button class="btn btn-info text-white shadow-sm action-btn btn-resumen" 
                                        data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>"
                                        data-bs-toggle="modal" data-bs-target="#modalResumen" title="Vista Rápida"><i class="bi bi-eye-fill"></i></button>

                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success shadow-sm action-btn" title="Historial Médico"><i class="bi bi-journal-medical"></i></a>

                                    <button class="btn btn-primary shadow-sm action-btn btn-editar"
                                        data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>"
                                        data-bs-toggle="modal" data-bs-target="#modalEditarBovino" title="Editar"><i class="bi bi-pencil-fill"></i></button>

                                    <form action="inventario-ganado" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="mover">
                                        <input type="hidden" name="id" value="<%= b.getIdBovino() %>">
                                        <input type="hidden" name="destino" value="Venta">
                                        <button type="submit" class="btn btn-warning text-dark shadow-sm action-btn" title="Vender"><i class="bi bi-tag-fill"></i></button>
                                    </form>

                                    <form action="inventario-ganado" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= b.getIdBovino() %>">
                                        <button type="submit" class="btn btn-danger shadow-sm action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill"></i></button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="bi bi-droplet fs-1 d-block mb-3 opacity-50"></i>
                                Hato lechero vacío.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ================= PESTAÑA: LOTE PARA VENTA ================= -->
        <div class="tab-pane fade" id="ventas">
            <div class="table-responsive table-custom-wrapper">
                <table class="table table-hover align-middle mt-3 mb-0">
                    <thead class="table-warning text-dark text-center" style="border-bottom: 2px solid #ffda6a;">
                        <tr>
                            <th>Foto</th>
                            <th>Arete</th>
                            <th>Raza / Género</th>
                            <th>Peso (Kg)</th>
                            <th>Precio Estimado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody class="text-center">
                        <% if(listaVenta != null && !listaVenta.isEmpty()) {
                            for(Bovino b : listaVenta) { %>
                        <tr>
                            <td>
                                <%-- CORRECCIÓN APLICADA --%>
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto" class="cow-avatar border border-2 border-warning">
                                <% } else { %>
                                    <div class="cow-avatar-placeholder mx-auto border border-2 border-warning text-warning">🐄</div>
                                <% } %>
                            </td>
                            <td class="fw-bold fs-5 text-dark"><%= b.getNumeroArete() %></td>
                            <td>
                                <div class="fw-bold text-dark"><%= b.getRaza() %></div>
                                <span class="badge bg-light text-secondary border mt-1"><%= b.getGenero() %></span>
                            </td>
                            <td><strong class="fs-6 text-dark"><%= b.getPesoKg() %></strong></td>
                            <td>
                                <div class="bg-success text-white fw-bold rounded-pill py-1 px-3 d-inline-block shadow-sm">
                                    $<%= String.format("%,.2f", b.getPrecioEstimado()) %>
                                </div>
                            </td>
                            <td>
                                <div class="d-flex gap-2 justify-content-center flex-wrap">
                                    <button class="btn btn-info text-white shadow-sm action-btn btn-resumen" 
                                        data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>"
                                        data-bs-toggle="modal" data-bs-target="#modalResumen" title="Vista Rápida"><i class="bi bi-eye-fill"></i></button>

                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success shadow-sm action-btn" title="Historial Médico"><i class="bi bi-journal-medical"></i></a>

                                    <button class="btn btn-primary shadow-sm action-btn btn-editar"
                                        data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>"
                                        data-bs-toggle="modal" data-bs-target="#modalEditarBovino" title="Editar"><i class="bi bi-pencil-fill"></i></button>

                                    <% if(b.getGenero().equals("Hembra")) { %>
                                        <form action="inventario-ganado" method="POST" class="d-inline">
                                            <input type="hidden" name="action" value="mover">
                                            <input type="hidden" name="id" value="<%= b.getIdBovino() %>">
                                            <input type="hidden" name="destino" value="Producción">
                                            <button type="submit" class="btn btn-success shadow-sm action-btn" title="A Producción"><i class="bi bi-droplet-fill"></i></button>
                                        </form>
                                    <% } %>

                                    <form action="inventario-ganado" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= b.getIdBovino() %>">
                                        <button type="submit" class="btn btn-danger shadow-sm action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill"></i></button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="bi bi-tags fs-1 d-block mb-3 opacity-50"></i>
                                No hay animales registrados para la venta.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- ================= MODAL: RESUMEN RÁPIDO ================= -->
<div class="modal fade" id="modalResumen" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow-lg">
            <div class="modal-header bg-success text-white rounded-top-4 border-0">
                <h5 class="modal-title fw-bold"><i class="bi bi-info-circle-fill me-2"></i> Resumen de Vaca: <span id="resArete"></span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body py-4 px-4">
                <div class="text-center mb-4 position-relative">
                    <!-- CORRECCIÓN DE LA VACA DUPLICADA (USO DE D-NONE EN LUGAR DE STYLE.DISPLAY) -->
                    <img id="resFoto" src="" class="rounded-circle mb-3 border border-5 border-success shadow d-none" style="width: 150px; height: 150px; object-fit: cover;">
                    <div id="resFotoPlaceholder" class="rounded-circle bg-light border border-4 border-secondary shadow-sm mx-auto mb-3 align-items-center justify-content-center" style="width: 150px; height: 150px; font-size: 60px;">🐄</div>
                    
                    <h3 class="fw-bold text-dark mb-2" id="resRaza"></h3>
                    <span id="resSalud" class="badge fs-6 rounded-pill px-4 py-2 shadow-sm"></span>
                </div>
                
                <div class="row g-3 text-start bg-light p-3 rounded-4 shadow-sm border">
                    <div class="col-6 d-flex align-items-center">
                        <i class="bi bi-calendar3 fs-3 text-secondary me-3"></i>
                        <div>
                            <span class="text-muted small d-block text-uppercase fw-bold" style="font-size: 11px;">Edad</span>
                            <strong class="fs-6 text-dark"><span id="resEdad"></span> años</strong>
                        </div>
                    </div>
                    <div class="col-6 d-flex align-items-center">
                        <i class="bi bi-speedometer2 fs-3 text-secondary me-3"></i>
                        <div>
                            <span class="text-muted small d-block text-uppercase fw-bold" style="font-size: 11px;">Peso Actual</span>
                            <strong class="fs-6 text-dark"><span id="resPeso"></span> Kg</strong>
                        </div>
                    </div>
                    <div class="col-6 d-flex align-items-center">
                        <i class="bi bi-bullseye fs-3 text-secondary me-3"></i>
                        <div>
                            <span class="text-muted small d-block text-uppercase fw-bold" style="font-size: 11px;">Propósito</span>
                            <strong class="fs-6 text-dark" id="resProposito"></strong>
                        </div>
                    </div>
                    <div class="col-6 d-flex align-items-center">
                        <i class="bi bi-clipboard2-plus fs-3 text-secondary me-3"></i>
                        <div>
                            <span class="text-muted small d-block text-uppercase fw-bold" style="font-size: 11px;">N° de Partos</span>
                            <strong class="fs-6 text-dark" id="resPartos"></strong>
                        </div>
                    </div>
                </div>

                <div class="mt-4 text-center bg-success-subtle rounded-4 p-3 border border-success-subtle">
                    <p class="mb-1 text-success text-uppercase fw-bold" style="letter-spacing: 1px; font-size: 12px;">Producción Promedio</p>
                    <h2 class="text-success fw-bold mb-0"><i class="bi bi-droplet-half"></i> <span id="resLeche"></span> <small class="fs-5 opacity-75">L/día</small></h2>
                </div>
            </div>
            <div class="modal-footer bg-white border-0 rounded-bottom-4 justify-content-center pb-4">
                <a href="#" id="btnInfoCompleta" class="btn btn-success btn-lg fw-bold w-100 shadow-sm rounded-pill"><i class="bi bi-journal-medical me-2"></i> Ver Historial Médico</a>
            </div>
        </div>
    </div>
</div>

<!-- ================= MODAL: REGISTRAR NUEVO ANIMAL ================= -->
<div class="modal fade" id="modalBovino" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow-lg">
            <div class="modal-header bg-success text-white rounded-top-4 border-0 px-4 py-3">
                <h5 class="fw-bold mb-0"><i class="bi bi-plus-circle-fill me-2"></i> Registro de Nuevo Animal</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="inventario-ganado" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                <div class="modal-body p-4 bg-light">
                    <div class="row g-4 bg-white p-4 rounded-4 shadow-sm border">
                        <div class="col-md-6">
                            <label class="form-label text-muted fw-bold small text-uppercase">Número de Arete</label>
                            <input type="text" name="numeroArete" class="form-control form-control-lg bg-light" placeholder="Ej: V-001" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted fw-bold small text-uppercase">Raza</label>
                            <input type="text" name="raza" class="form-control form-control-lg bg-light" placeholder="Ej: Holstein, Brahman" required>
                        </div>
                        
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Nacimiento</label>
                            <input type="date" name="fechaNacimiento" class="form-control bg-light" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Género</label>
                            <select name="genero" class="form-select bg-light" required>
                                <option value="Hembra">Hembra</option>
                                <option value="Macho">Macho</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Peso (Kg)</label>
                            <input type="number" step="0.01" name="pesoKg" class="form-control bg-light" placeholder="0.00" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Clasificación</label>
                            <select name="clasificacion" class="form-select bg-light" required>
                                <option value="Producción">Producción (Hato Lechero)</option>
                                <option value="Venta">Para Venta</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Propósito</label>
                            <select name="proposito" class="form-select bg-light" required>
                                <option value="Leche">Leche</option>
                                <option value="Carne">Carne</option>
                                <option value="Doble Propósito">Doble Propósito</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Estado de Salud</label>
                            <select name="estadoSalud" class="form-select bg-light" required>
                                <option value="Sano">Sano / Sana</option>
                                <option value="Enfermo">Enfermo / Enferma</option>
                                <option value="En Tratamiento">En Tratamiento</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Litros Diarios</label>
                            <input type="number" step="0.01" name="litrosDiarios" class="form-control bg-light" placeholder="0.0" value="0">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">N° de Partos</label>
                            <input type="number" name="numeroPartos" class="form-control bg-light" placeholder="0" value="0">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Precio Estimado ($)</label>
                            <input type="number" step="0.01" name="precioEstimado" class="form-control bg-light" placeholder="Valor comercial" required>
                        </div>

                        <div class="col-12 mt-4 pt-3 border-top">
                            <label class="form-label text-muted fw-bold small text-uppercase"><i class="bi bi-camera-fill text-success fs-5 me-1"></i> Subir Fotografía</label>
                            <input type="file" name="imageFile" class="form-control form-control-lg bg-light" accept="image/*">
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-white border-0 rounded-bottom-4 px-4 py-3">
                    <button type="button" class="btn btn-light fw-bold px-4 rounded-pill" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-success fw-bold px-5 rounded-pill shadow-sm"><i class="bi bi-save-fill me-2"></i> Guardar Registro</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ================= MODAL: EDITAR ANIMAL ================= -->
<div class="modal fade" id="modalEditarBovino" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow-lg">
            <div class="modal-header bg-primary text-white rounded-top-4 border-0 px-4 py-3">
                <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i> Editar Información del Animal</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="inventario-ganado" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="idBovino" id="editIdBovino">
                <input type="hidden" name="imageUrl" id="editImageUrlOld">
                
                <div class="modal-body p-4 bg-light">
                    <div class="row g-4 bg-white p-4 rounded-4 shadow-sm border border-primary-subtle">
                        <div class="col-md-6">
                            <label class="form-label text-primary fw-bold small text-uppercase">Número de Arete</label>
                            <input type="text" name="numeroArete" id="editArete" class="form-control form-control-lg bg-light border-primary-subtle" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted fw-bold small text-uppercase">Raza</label>
                            <input type="text" name="raza" id="editRaza" class="form-control form-control-lg bg-light" required>
                        </div>
                        
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Nacimiento</label>
                            <input type="date" name="fechaNacimiento" id="editFecha" class="form-control bg-light" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Género</label>
                            <select name="genero" id="editGenero" class="form-select bg-light" required>
                                <option value="Hembra">Hembra</option>
                                <option value="Macho">Macho</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Peso (Kg)</label>
                            <input type="number" step="0.01" name="pesoKg" id="editPeso" class="form-control bg-light" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Clasificación</label>
                            <select name="clasificacion" id="editClasificacion" class="form-select bg-light" required>
                                <option value="Producción">Producción (Hato Lechero)</option>
                                <option value="Venta">Para Venta</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Propósito</label>
                            <select name="proposito" id="editProposito" class="form-select bg-light" required>
                                <option value="Leche">Leche</option>
                                <option value="Carne">Carne</option>
                                <option value="Doble Propósito">Doble Propósito</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Estado de Salud</label>
                            <select name="estadoSalud" id="editSalud" class="form-select bg-light" required>
                                <option value="Sano">Sano / Sana</option>
                                <option value="Enfermo">Enfermo / Enferma</option>
                                <option value="En Tratamiento">En Tratamiento</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Litros Diarios</label>
                            <input type="number" step="0.01" name="litrosDiarios" id="editLeche" class="form-control bg-light" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">N° de Partos</label>
                            <input type="number" name="numeroPartos" id="editPartos" class="form-control bg-light" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Precio Estimado ($)</label>
                            <input type="number" step="0.01" name="precioEstimado" id="editPrecio" class="form-control bg-light" required>
                        </div>

                        <div class="col-12 mt-4 pt-3 border-top">
                            <label class="form-label text-muted fw-bold small text-uppercase"><i class="bi bi-image-fill text-primary fs-5 me-1"></i> Cambiar Foto (Opcional)</label>
                            <input type="file" name="imageFile" class="form-control form-control-lg bg-light" accept="image/*">
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-white border-0 rounded-bottom-4 px-4 py-3">
                    <button type="button" class="btn btn-light fw-bold px-4 rounded-pill" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary fw-bold px-5 rounded-pill shadow-sm"><i class="bi bi-arrow-repeat me-2"></i> Actualizar Cambios</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // JS CORREGIDO PARA EVITAR DUPLICADOS Y APLICAR LA RUTA ABSOLUTA
    document.querySelectorAll('.btn-resumen').forEach(button => {
        button.addEventListener('click', function() {
            document.getElementById('resArete').innerText = this.dataset.arete;
            document.getElementById('resRaza').innerText = this.dataset.raza;
            document.getElementById('resLeche').innerText = this.dataset.leche;
            document.getElementById('resEdad').innerText = this.dataset.edad;
            document.getElementById('resPeso').innerText = this.dataset.peso;
            document.getElementById('resProposito').innerText = this.dataset.proposito;
            document.getElementById('resPartos').innerText = this.dataset.partos;
            
            let saludBadge = document.getElementById('resSalud');
            saludBadge.innerText = this.dataset.salud;
            if (this.dataset.salud === "Sano" || this.dataset.salud === "Sana") {
                saludBadge.className = "badge bg-success fs-6 rounded-pill px-4 py-2 shadow-sm";
            } else {
                saludBadge.className = "badge bg-danger fs-6 rounded-pill px-4 py-2 shadow-sm";
            }
            
            let img = document.getElementById('resFoto');
            let placeholder = document.getElementById('resFotoPlaceholder');
            
            let contextPath = '<%= request.getContextPath() %>';
            
            if(this.dataset.foto && this.dataset.foto !== "null" && this.dataset.foto.trim() !== "") { 
                img.src = contextPath + "/" + this.dataset.foto; 
                img.classList.remove('d-none');
                
                placeholder.classList.add('d-none');
                placeholder.classList.remove('d-flex');
            } else { 
                img.classList.add('d-none');
                
                placeholder.classList.remove('d-none');
                placeholder.classList.add('d-flex');
            }

            document.getElementById('btnInfoCompleta').href = "perfil-bovino?id=" + this.dataset.id;
        });
    });

    document.querySelectorAll('.btn-editar').forEach(button => {
        button.addEventListener('click', function() {
            document.getElementById('editIdBovino').value = this.dataset.id;
            document.getElementById('editArete').value = this.dataset.arete;
            document.getElementById('editRaza').value = this.dataset.raza;
            document.getElementById('editFecha').value = this.dataset.fecha;
            document.getElementById('editGenero').value = this.dataset.genero;
            document.getElementById('editPeso').value = this.dataset.peso;
            document.getElementById('editClasificacion').value = this.dataset.clasificacion;
            document.getElementById('editProposito').value = this.dataset.proposito;
            document.getElementById('editSalud').value = this.dataset.salud;
            document.getElementById('editLeche').value = this.dataset.leche;
            document.getElementById('editPartos').value = this.dataset.partos;
            document.getElementById('editPrecio').value = this.dataset.precio;
            
            document.getElementById('editImageUrlOld').value = this.dataset.foto !== "null" ? this.dataset.foto : "";
        });
    });
</script>
</body>
</html>