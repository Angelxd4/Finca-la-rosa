<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.finca.models.Bovino" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventario Ganadero | Finca</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        :root {
            /* COLOR PERSONALIZADO */
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
                radial-gradient(circle at 15% 50%, rgba(47, 133, 90, 0.12), transparent 30%),
                radial-gradient(circle at 85% 20%, rgba(47, 133, 90, 0.08), transparent 30%);
            background-attachment: fixed;
        }
        
        /* OVERRIDES DE BOOTSTRAP PARA EL VERDE PERSONALIZADO */
        .text-success { color: var(--brand-main) !important; }
        .bg-success { background-color: var(--brand-main) !important; color: white !important; }
        .btn-success { background-color: var(--brand-main); border-color: var(--brand-main); }
        .btn-success:hover { background-color: var(--brand-hover); border-color: var(--brand-hover); }
        .btn-outline-success { color: var(--brand-main); border-color: var(--brand-main); }
        .btn-outline-success:hover, .btn-outline-success.active { background-color: var(--brand-main); color: white; border-color: var(--brand-main); }
        .bg-success-subtle { background-color: rgba(47, 133, 90, 0.12) !important; }
        .border-success-subtle { border-color: rgba(47, 133, 90, 0.25) !important; }

        /* EFECTO CRISTAL PRINCIPAL */
        .glass-panel {
            background: var(--glass-bg);
            backdrop-filter: blur(24px) saturate(180%);
            -webkit-backdrop-filter: blur(24px) saturate(180%);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            box-shadow: var(--glass-shadow);
        }

        .main-card { padding: 30px; margin-top: 20px; }
        
        /* PESTAÑAS ESTILO APPLE (Segmented Controls) */
        .apple-tabs-wrapper {
            background: rgba(0, 0, 0, 0.05);
            padding: 6px;
            border-radius: 18px;
            display: inline-flex;
            gap: 5px;
            flex-wrap: wrap;
        }
        .nav-tabs { border-bottom: none; gap: 0; }
        .nav-tabs .nav-link { 
            color: #555; 
            font-weight: 600; 
            border: none;
            border-radius: 14px; 
            padding: 10px 24px; 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); 
            background-color: transparent; 
        }
        .nav-tabs .nav-link:hover { color: var(--brand-main); }
        .nav-tabs .nav-link.active { 
            color: var(--brand-main); 
            background-color: #ffffff; 
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); 
        }
        
        /* --- ESTILOS DE TABLA --- */
        .table-custom-wrapper { border-radius: 18px; overflow: hidden; background: rgba(255,255,255,0.4); border: 1px solid var(--glass-border); }
        .table { margin-bottom: 0; background: transparent; }
        .table th { white-space: nowrap; font-weight: 700; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; padding: 18px 15px; border-bottom: 1px solid rgba(0,0,0,0.05); background-color: rgba(255,255,255,0.6); }
        .table td { vertical-align: middle; padding: 16px 15px; color: #495057; font-size: 0.95rem; border-bottom: 1px solid rgba(0,0,0,0.03); background: transparent; }
        .table-hover tbody tr { transition: all 0.2s ease; }
        .table-hover tbody tr:hover td { background-color: rgba(255,255,255,0.9); transform: scale(1.001); position: relative; z-index: 1; }
        
        /* --- IMÁGENES (CUADRADAS APPLE STYLE) --- */
        .cow-thumbnail { width: 60px; height: 60px; object-fit: cover; border-radius: 14px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1); }
        .cow-thumbnail:hover { transform: scale(1.15); z-index: 10; position: relative; }
        .cow-placeholder { width: 60px; height: 60px; border-radius: 14px; background: rgba(0,0,0,0.04); border: 1px dashed rgba(0,0,0,0.1); display: flex; align-items: center; justify-content: center; font-size: 24px; }
        
        /* --- ESTILOS DE TARJETAS (NUEVA VISTA) --- */
        .bovino-card { 
            background: rgba(255,255,255,0.6); 
            border: 1px solid var(--glass-border); 
            border-radius: 20px;
            overflow: hidden; 
            transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
            backdrop-filter: blur(10px);
        }
        .bovino-card:hover { transform: translateY(-8px); box-shadow: 0 20px 40px rgba(0,0,0,0.08); background: rgba(255,255,255,0.9); }
        .card-img-wrapper { height: 200px; overflow: hidden; position: relative; background: rgba(0,0,0,0.02); display: flex; justify-content: center; align-items: center; border-bottom: 1px solid rgba(0,0,0,0.03); }
        .card-img-wrapper img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s ease; }
        .bovino-card:hover .card-img-wrapper img { transform: scale(1.05); }
        .card-placeholder-icon { font-size: 70px; opacity: 0.3; }
        
        /* BOTONES DE ACCIÓN */
        .action-btn { transition: all 0.3s ease; border-radius: 12px; width: 36px; height: 36px; display: inline-flex; align-items: center; justify-content: center; padding: 0; border: none; }
        .action-btn:hover { transform: translateY(-3px); box-shadow: 0 6px 16px rgba(0,0,0,0.15); }
        
        /* Selector de vista */
        .view-toggle-btn { border-radius: 12px; padding: 8px 16px; font-weight: 600; }
        
        /* MODALES ESTILO APPLE */
        .modal-content {
            background: var(--glass-bg);
            backdrop-filter: blur(30px) saturate(180%);
            -webkit-backdrop-filter: blur(30px) saturate(180%);
            border: 1px solid var(--glass-border);
            border-radius: 28px;
            box-shadow: 0 24px 60px rgba(0,0,0,0.15);
        }
        .form-control, .form-select {
            border-radius: 14px;
            padding: 12px 16px;
            background: rgba(255,255,255,0.6);
            border: 1px solid rgba(0,0,0,0.08);
            transition: all 0.3s;
        }
        .form-control:focus, .form-select:focus {
            background: #fff;
            border-color: var(--brand-main);
            box-shadow: 0 0 0 4px rgba(47, 133, 90, 0.15);
        }

        .d-none { display: none !important; }
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

<div class="container py-4">
    <div class="glass-panel p-4 mb-4 d-flex flex-column flex-md-row justify-content-between align-items-center">
        <div>
            <h2 class="fw-bold mb-1" style="color: #1d1d1f;"><i class="bi bi-boxes text-success"></i> Gestión de Inventario</h2>
            <p class="text-muted mb-0">Administración general del ganado de la finca</p>
        </div>
        
        <div class="d-flex gap-3 mt-3 mt-md-0 align-items-center">
            <div class="apple-tabs-wrapper" role="group">
                <button type="button" class="btn btn-outline-success border-0 view-toggle-btn active" id="btn-list" onclick="setView('list')" title="Vista de Lista">
                    <i class="bi bi-list-ul fs-5"></i>
                </button>
                <button type="button" class="btn btn-outline-success border-0 view-toggle-btn" id="btn-grid" onclick="setView('grid')" title="Vista de Tarjetas">
                    <i class="bi bi-grid-fill fs-5"></i>
                </button>
            </div>

            <button class="btn btn-success btn-lg fw-bold shadow-sm rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#modalBovino">
                <i class="bi bi-plus-circle-fill me-1"></i> Registrar
            </button>
        </div>
    </div>

    <% if(request.getAttribute("successMessage") != null) { %>
        <div class="alert alert-success alert-dismissible fade show glass-panel border-0 border-start border-5 border-success mb-4">
            <i class="bi bi-check-circle-fill me-2 fs-5"></i> <strong>¡Éxito!</strong> <%= request.getAttribute("successMessage") %>
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>
    
    <% if(request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show glass-panel border-0 border-start border-5 border-danger mb-4">
            <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i> <strong>Error:</strong> <%= request.getAttribute("errorMessage") %>
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <div class="text-center text-md-start">
        <div class="apple-tabs-wrapper mb-2">
            <ul class="nav nav-tabs" id="inventarioTabs">
                <li class="nav-item">
                    <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#todos"><i class="bi bi-collection-fill me-1"></i> Todos</button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#produccion"><i class="bi bi-droplet-fill me-1"></i> Hato Lechero</button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#ventas"><i class="bi bi-tags-fill me-1"></i> Para Venta</button>
                </li>
            </ul>
        </div>
    </div>

    <div class="tab-content glass-panel main-card">
        <div class="tab-pane fade show active" id="todos">
            
            <div class="view-list table-responsive table-custom-wrapper shadow-sm">
                <table class="table align-middle">
                    <thead class="text-secondary text-center">
                        <tr>
                            <th>Foto</th>
                            <th>Arete</th>
                            <th>Raza / Género</th>
                            <th>Clasificación</th>
                            <th>Salud</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody class="text-center table-hover">
                        <% if(listaTodos != null && !listaTodos.isEmpty()) {
                            for(Bovino b : listaTodos) { %>
                        <tr>
                            <td>
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto" class="cow-thumbnail border border-2 border-white">
                                <% } else { %>
                                    <div class="cow-placeholder mx-auto text-secondary">🐄</div>
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
                                <span class="badge <%= b.getEstadoSalud().equals("Sano") || b.getEstadoSalud().equals("Sana") ? "bg-success" : "bg-danger" %> px-3 py-2 rounded-pill">
                                    <i class="bi <%= b.getEstadoSalud().equals("Sano") || b.getEstadoSalud().equals("Sana") ? "bi-heart-fill" : "bi-bandaid-fill" %>"></i> <%= b.getEstadoSalud() %>
                                </span>
                            </td>
                            <td>
                                <div class="d-flex gap-2 justify-content-center flex-wrap">
                                    <button class="btn btn-info text-white action-btn btn-resumen" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalResumen" title="Vista Rápida"><i class="bi bi-eye-fill"></i></button>
                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success action-btn" title="Historial Médico"><i class="bi bi-journal-medical"></i></a>
                                    <button class="btn btn-primary action-btn btn-editar" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalEditarBovino" title="Editar"><i class="bi bi-pencil-fill"></i></button>
                                    <% if(b.getClasificacion().equals("Producción")) { %>
                                        <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Venta"><button type="submit" class="btn btn-warning text-dark action-btn" title="Mover a Venta" onclick="return confirm('¿Mover a lote de venta?');"><i class="bi bi-tag-fill"></i></button></form>
                                    <% } else if(b.getClasificacion().equals("Venta") && b.getGenero().equals("Hembra")) { %>
                                        <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Producción"><button type="submit" class="btn btn-success action-btn" title="Regresar a Producción" onclick="return confirm('¿Regresar a producción?');"><i class="bi bi-droplet-fill"></i></button></form>
                                    <% } %>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><button type="submit" class="btn btn-danger action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill"></i></button></form>
                                </div>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr><td colspan="6" class="text-center py-5"><div class="text-muted"><i class="bi bi-inbox fs-1 d-block mb-3 text-secondary opacity-50"></i><h5 class="fw-bold">No hay animales registrados</h5></div></td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div class="view-grid d-none">
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-4">
                    <% if(listaTodos != null && !listaTodos.isEmpty()) {
                        for(Bovino b : listaTodos) { %>
                    <div class="col">
                        <div class="card h-100 bovino-card border-0">
                            <div class="card-img-wrapper">
                                <span class="position-absolute top-0 start-0 m-3 badge <%= b.getClasificacion().equals("Producción") ? "bg-success" : "bg-warning text-dark" %> rounded-pill z-2 shadow-sm px-3 py-2"><%= b.getClasificacion() %></span>
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto Bovino">
                                <% } else { %>
                                    <i class="bi bi-image card-placeholder-icon text-secondary"></i>
                                <% } %>
                            </div>
                            <div class="card-body p-4 pb-3">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h4 class="fw-bold text-dark mb-0"><%= b.getNumeroArete() %></h4>
                                    <i class="bi <%= b.getGenero().equals("Hembra") ? "bi-gender-female text-danger" : "bi-gender-male text-primary" %> fs-5"></i>
                                </div>
                                <p class="text-muted fw-semibold mb-3"><%= b.getRaza() %></p>
                                
                                <div class="d-flex justify-content-between mb-3 bg-white p-2 rounded-4 shadow-sm border border-light">
                                    <div class="text-center w-50 border-end">
                                        <small class="text-muted d-block" style="font-size: 11px;">PESO</small>
                                        <strong class="text-dark"><%= b.getPesoKg() %> kg</strong>
                                    </div>
                                    <div class="text-center w-50">
                                        <small class="text-muted d-block" style="font-size: 11px;">SALUD</small>
                                        <strong class="<%= b.getEstadoSalud().equals("Sano") || b.getEstadoSalud().equals("Sana") ? "text-success" : "text-danger" %>"><%= b.getEstadoSalud() %></strong>
                                    </div>
                                </div>
                                
                                <div class="d-flex gap-2 justify-content-center flex-wrap pt-2 mt-2">
                                    <button class="btn btn-info text-white action-btn btn-resumen" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalResumen" title="Vista Rápida"><i class="bi bi-eye-fill"></i></button>
                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success action-btn" title="Historial Médico"><i class="bi bi-journal-medical"></i></a>
                                    <button class="btn btn-primary action-btn btn-editar" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalEditarBovino" title="Editar"><i class="bi bi-pencil-fill"></i></button>
                                    <% if(b.getClasificacion().equals("Producción")) { %>
                                        <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Venta"><button type="submit" class="btn btn-warning text-dark action-btn" title="Mover a Venta" onclick="return confirm('¿Mover a lote de venta?');"><i class="bi bi-tag-fill"></i></button></form>
                                    <% } else if(b.getClasificacion().equals("Venta") && b.getGenero().equals("Hembra")) { %>
                                        <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Producción"><button type="submit" class="btn btn-success action-btn" title="Regresar a Producción" onclick="return confirm('¿Regresar a producción?');"><i class="bi bi-droplet-fill"></i></button></form>
                                    <% } %>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><button type="submit" class="btn btn-danger action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill"></i></button></form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% }} else { %>
                        <div class="col-12 text-center py-5"><div class="text-muted"><i class="bi bi-inbox fs-1 d-block mb-3 text-secondary opacity-50"></i><h5 class="fw-bold">No hay animales registrados</h5></div></div>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="tab-pane fade" id="produccion">
            
            <div class="view-list table-responsive table-custom-wrapper shadow-sm">
                <table class="table align-middle mb-0">
                    <thead class="text-success text-center" style="background-color: rgba(47, 133, 90, 0.05); border-bottom: 2px solid rgba(47, 133, 90, 0.2);">
                        <tr>
                            <th>Foto</th>
                            <th>Arete</th>
                            <th>Raza / Edad</th>
                            <th>Litros/Día</th>
                            <th>Salud</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody class="text-center table-hover">
                        <% if(listaProd != null && !listaProd.isEmpty()) {
                            for(Bovino b : listaProd) { %>
                        <tr>
                            <td>
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto" class="cow-thumbnail border border-2 border-success">
                                <% } else { %>
                                    <div class="cow-placeholder mx-auto border border-2 border-success text-success">🐄</div>
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
                                <span class="badge <%= b.getEstadoSalud().equals("Sano") || b.getEstadoSalud().equals("Sana") ? "bg-success" : "bg-warning text-dark" %> rounded-pill px-3 py-2">
                                    <%= b.getEstadoSalud() %>
                                </span>
                            </td>
                            <td>
                                <div class="d-flex gap-2 justify-content-center flex-wrap">
                                    <button class="btn btn-info text-white action-btn btn-resumen" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalResumen" title="Vista Rápida"><i class="bi bi-eye-fill"></i></button>
                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success action-btn" title="Historial Médico"><i class="bi bi-journal-medical"></i></a>
                                    <button class="btn btn-primary action-btn btn-editar" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalEditarBovino" title="Editar"><i class="bi bi-pencil-fill"></i></button>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Venta"><button type="submit" class="btn btn-warning text-dark action-btn" title="Vender"><i class="bi bi-tag-fill"></i></button></form>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><button type="submit" class="btn btn-danger action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill"></i></button></form>
                                </div>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr><td colspan="6" class="text-center py-5 text-muted"><i class="bi bi-droplet fs-1 d-block mb-3 opacity-50"></i>Hato lechero vacío.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div class="view-grid d-none mt-3">
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-4">
                    <% if(listaProd != null && !listaProd.isEmpty()) {
                        for(Bovino b : listaProd) { %>
                    <div class="col">
                        <div class="card h-100 bovino-card border-0" style="border-top: 5px solid var(--brand-main) !important;">
                            <div class="card-img-wrapper" style="height: 180px;">
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto">
                                <% } else { %>
                                    <i class="bi bi-droplet card-placeholder-icon text-success"></i>
                                <% } %>
                            </div>
                            <div class="card-body p-4">
                                <h5 class="fw-bold text-success text-center mb-1"><%= b.getNumeroArete() %></h5>
                                <p class="text-center text-muted small mb-3"><%= b.getRaza() %></p>
                                <div class="bg-success-subtle text-success text-center fw-bold rounded-4 py-2 mb-3">
                                    <i class="bi bi-droplet-half"></i> <%= b.getLitrosDiariosPromedio() %> L / día
                                </div>
                                <div class="d-flex gap-2 justify-content-center flex-wrap mt-3 pt-2">
                                    <button class="btn btn-info text-white action-btn btn-resumen" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalResumen" title="Vista Rápida"><i class="bi bi-eye-fill"></i></button>
                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success action-btn" title="Historial Médico"><i class="bi bi-journal-medical"></i></a>
                                    <button class="btn btn-primary action-btn btn-editar" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalEditarBovino" title="Editar"><i class="bi bi-pencil-fill"></i></button>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Venta"><button type="submit" class="btn btn-warning text-dark action-btn" title="Vender"><i class="bi bi-tag-fill"></i></button></form>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><button type="submit" class="btn btn-danger action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill"></i></button></form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% }} else { %>
                        <div class="col-12 text-center py-5 text-muted"><i class="bi bi-droplet fs-1 d-block mb-3 opacity-50"></i>Hato lechero vacío.</div>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="tab-pane fade" id="ventas">
            <div class="view-list table-responsive table-custom-wrapper shadow-sm">
                <table class="table align-middle mb-0">
                    <thead class="text-dark text-center" style="background-color: rgba(255, 193, 7, 0.1); border-bottom: 2px solid rgba(255, 193, 7, 0.4);">
                        <tr>
                            <th>Foto</th>
                            <th>Arete</th>
                            <th>Raza / Género</th>
                            <th>Peso (Kg)</th>
                            <th>Precio Estimado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody class="text-center table-hover">
                        <% if(listaVenta != null && !listaVenta.isEmpty()) {
                            for(Bovino b : listaVenta) { %>
                        <tr>
                            <td>
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto" class="cow-thumbnail border border-2 border-warning">
                                <% } else { %>
                                    <div class="cow-placeholder mx-auto border border-2 border-warning text-warning">🐄</div>
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
                                    <button class="btn btn-info text-white action-btn btn-resumen" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalResumen" title="Vista Rápida"><i class="bi bi-eye-fill"></i></button>
                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success action-btn" title="Historial Médico"><i class="bi bi-journal-medical"></i></a>
                                    <button class="btn btn-primary action-btn btn-editar" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalEditarBovino" title="Editar"><i class="bi bi-pencil-fill"></i></button>
                                    <% if(b.getGenero().equals("Hembra")) { %>
                                        <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Producción"><button type="submit" class="btn btn-success action-btn" title="A Producción"><i class="bi bi-droplet-fill"></i></button></form>
                                    <% } %>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><button type="submit" class="btn btn-danger action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill"></i></button></form>
                                </div>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr><td colspan="6" class="text-center py-5 text-muted"><i class="bi bi-tags fs-1 d-block mb-3 opacity-50"></i>No hay animales registrados para la venta.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <div class="view-grid d-none mt-3">
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-4">
                    <% if(listaVenta != null && !listaVenta.isEmpty()) {
                        for(Bovino b : listaVenta) { %>
                    <div class="col">
                        <div class="card h-100 bovino-card border-0" style="border-top: 5px solid #ffc107 !important;">
                            <div class="card-img-wrapper" style="height: 180px;">
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto">
                                <% } else { %>
                                    <i class="bi bi-tags card-placeholder-icon text-warning"></i>
                                <% } %>
                            </div>
                            <div class="card-body p-4">
                                <h5 class="fw-bold text-dark text-center mb-1"><%= b.getNumeroArete() %></h5>
                                <p class="text-center text-muted small mb-3"><%= b.getRaza() %></p>
                                <div class="bg-white text-dark text-center fw-bold rounded-4 py-2 mb-3 shadow-sm border border-light">
                                    $<%= String.format("%,.2f", b.getPrecioEstimado()) %>
                                </div>
                                <div class="d-flex gap-2 justify-content-center flex-wrap pt-2 mt-3">
                                    <button class="btn btn-info text-white action-btn btn-resumen" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalResumen" title="Vista Rápida"><i class="bi bi-eye-fill"></i></button>
                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success action-btn" title="Historial Médico"><i class="bi bi-journal-medical"></i></a>
                                    <button class="btn btn-primary action-btn btn-editar" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalEditarBovino" title="Editar"><i class="bi bi-pencil-fill"></i></button>
                                    <% if(b.getGenero().equals("Hembra")) { %>
                                        <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Producción"><button type="submit" class="btn btn-success action-btn" title="A Producción"><i class="bi bi-droplet-fill"></i></button></form>
                                    <% } %>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><button type="submit" class="btn btn-danger action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill"></i></button></form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% }} else { %>
                        <div class="col-12 text-center py-5 text-muted"><i class="bi bi-tags fs-1 d-block mb-3 opacity-50"></i>No hay animales registrados para venta.</div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalResumen" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0">
            <div class="modal-header bg-success text-white border-0" style="border-radius: 28px 28px 0 0;">
                <h5 class="modal-title fw-bold"><i class="bi bi-info-circle-fill me-2"></i> Resumen de Vaca: <span id="resArete"></span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body py-4 px-4">
                <div class="text-center mb-4 position-relative">
                    <img id="resFoto" src="" class="rounded-4 mb-3 border border-3 border-success shadow d-none" style="width: 180px; height: 180px; object-fit: cover;">
                    <div id="resFotoPlaceholder" class="rounded-4 bg-light border border-3 border-secondary shadow-sm mx-auto mb-3 align-items-center justify-content-center" style="width: 180px; height: 180px; font-size: 70px;">🐄</div>
                    
                    <h3 class="fw-bold text-dark mb-2" id="resRaza"></h3>
                    <span id="resSalud" class="badge fs-6 rounded-pill px-4 py-2 shadow-sm"></span>
                </div>
                
                <div class="row g-3 text-start bg-white p-3 rounded-4 shadow-sm border border-light">
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
            <div class="modal-footer border-0 justify-content-center pb-4 pt-0" style="border-radius: 0 0 28px 28px;">
                <a href="#" id="btnInfoCompleta" class="btn btn-success btn-lg fw-bold w-100 shadow-sm rounded-pill"><i class="bi bi-journal-medical me-2"></i> Ver Historial Médico</a>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalBovino" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0">
            <div class="modal-header bg-success text-white border-0" style="border-radius: 28px 28px 0 0;">
                <h5 class="fw-bold mb-0"><i class="bi bi-plus-circle-fill me-2"></i> Registro de Nuevo Animal</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="inventario-ganado" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                <div class="modal-body p-4">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label text-muted fw-bold small text-uppercase">Número de Arete</label>
                            <input type="text" name="numeroArete" class="form-control form-control-lg" placeholder="Ej: V-001" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted fw-bold small text-uppercase">Raza</label>
                            <input type="text" name="raza" class="form-control form-control-lg" placeholder="Ej: Holstein, Brahman" required>
                        </div>
                        
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Nacimiento</label>
                            <input type="date" name="fechaNacimiento" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Género</label>
                            <select name="genero" class="form-select" required>
                                <option value="Hembra">Hembra</option>
                                <option value="Macho">Macho</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Peso (Kg)</label>
                            <input type="number" step="0.01" name="pesoKg" class="form-control" placeholder="0.00" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Clasificación</label>
                            <select name="clasificacion" class="form-select" required>
                                <option value="Producción">Producción (Hato Lechero)</option>
                                <option value="Venta">Para Venta</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Propósito</label>
                            <select name="proposito" class="form-select" required>
                                <option value="Leche">Leche</option>
                                <option value="Carne">Carne</option>
                                <option value="Doble Propósito">Doble Propósito</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Estado de Salud</label>
                            <select name="estadoSalud" class="form-select" required>
                                <option value="Sano">Sano / Sana</option>
                                <option value="Enfermo">Enfermo / Enferma</option>
                                <option value="En Tratamiento">En Tratamiento</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Litros Diarios</label>
                            <input type="number" step="0.01" name="litrosDiarios" class="form-control" placeholder="0.0" value="0">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">N° de Partos</label>
                            <input type="number" name="numeroPartos" class="form-control" placeholder="0" value="0">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Precio Estimado ($)</label>
                            <input type="number" step="0.01" name="precioEstimado" class="form-control" placeholder="Valor comercial" required>
                        </div>

                        <div class="col-12 mt-4 pt-3 border-top border-secondary-subtle">
                            <label class="form-label text-muted fw-bold small text-uppercase"><i class="bi bi-camera-fill text-success fs-5 me-1"></i> Subir Fotografía</label>
                            <input type="file" name="imageFile" class="form-control form-control-lg" accept="image/*">
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 px-4 py-3" style="border-radius: 0 0 28px 28px;">
                    <button type="button" class="btn btn-light fw-bold px-4 rounded-pill" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-success fw-bold px-5 rounded-pill shadow-sm"><i class="bi bi-save-fill me-2"></i> Guardar Registro</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="modalEditarBovino" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0">
            <div class="modal-header bg-success text-white border-0" style="border-radius: 28px 28px 0 0;">
                <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i> Editar Información del Animal</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="inventario-ganado" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="idBovino" id="editIdBovino">
                <input type="hidden" name="imageUrl" id="editImageUrlOld">
                
                <div class="modal-body p-4">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label text-success fw-bold small text-uppercase">Número de Arete</label>
                            <input type="text" name="numeroArete" id="editArete" class="form-control form-control-lg border-success-subtle" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted fw-bold small text-uppercase">Raza</label>
                            <input type="text" name="raza" id="editRaza" class="form-control form-control-lg" required>
                        </div>
                        
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Nacimiento</label>
                            <input type="date" name="fechaNacimiento" id="editFecha" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Género</label>
                            <select name="genero" id="editGenero" class="form-select" required>
                                <option value="Hembra">Hembra</option>
                                <option value="Macho">Macho</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Peso (Kg)</label>
                            <input type="number" step="0.01" name="pesoKg" id="editPeso" class="form-control" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Clasificación</label>
                            <select name="clasificacion" id="editClasificacion" class="form-select" required>
                                <option value="Producción">Producción (Hato Lechero)</option>
                                <option value="Venta">Para Venta</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Propósito</label>
                            <select name="proposito" id="editProposito" class="form-select" required>
                                <option value="Leche">Leche</option>
                                <option value="Carne">Carne</option>
                                <option value="Doble Propósito">Doble Propósito</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Estado de Salud</label>
                            <select name="estadoSalud" id="editSalud" class="form-select" required>
                                <option value="Sano">Sano / Sana</option>
                                <option value="Enfermo">Enfermo / Enferma</option>
                                <option value="En Tratamiento">En Tratamiento</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Litros Diarios</label>
                            <input type="number" step="0.01" name="litrosDiarios" id="editLeche" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">N° de Partos</label>
                            <input type="number" name="numeroPartos" id="editPartos" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted fw-bold small text-uppercase">Precio Estimado ($)</label>
                            <input type="number" step="0.01" name="precioEstimado" id="editPrecio" class="form-control" required>
                        </div>

                        <div class="col-12 mt-4 pt-3 border-top border-secondary-subtle">
                            <label class="form-label text-muted fw-bold small text-uppercase"><i class="bi bi-image-fill text-success fs-5 me-1"></i> Cambiar Foto (Opcional)</label>
                            <input type="file" name="imageFile" class="form-control form-control-lg" accept="image/*">
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 px-4 py-3" style="border-radius: 0 0 28px 28px;">
                    <button type="button" class="btn btn-light fw-bold px-4 rounded-pill" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-success fw-bold px-5 rounded-pill shadow-sm"><i class="bi bi-arrow-repeat me-2"></i> Actualizar Cambios</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // --- LÓGICA DE CAMBIO DE VISTA (LISTA vs GRID) ---
    function setView(viewType) {
        if (viewType === 'list') {
            document.querySelectorAll('.view-list').forEach(el => el.classList.remove('d-none'));
            document.querySelectorAll('.view-grid').forEach(el => el.classList.add('d-none'));
            document.getElementById('btn-list').classList.add('active');
            document.getElementById('btn-grid').classList.remove('active');
        } else {
            document.querySelectorAll('.view-grid').forEach(el => el.classList.remove('d-none'));
            document.querySelectorAll('.view-list').forEach(el => el.classList.add('d-none'));
            document.getElementById('btn-grid').classList.add('active');
            document.getElementById('btn-list').classList.remove('active');
        }
        
        // Guardar la elección del usuario en el navegador
        localStorage.setItem('vistaInventario', viewType);
    }

    // Cargar la preferencia automáticamente cuando el archivo inicia
    document.addEventListener('DOMContentLoaded', () => {
        const vistaGuardada = localStorage.getItem('vistaInventario');
        if (vistaGuardada) {
            setView(vistaGuardada);
        }
    });

    // --- LÓGICA DE MODALES (MANTENIDA INTACTA) ---
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