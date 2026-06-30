<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.finca.models.Bovino" %>
<%@ page import="com.finca.models.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="includes/header.jsp" />
<style>
    /* Estilos específicos de Inventario */
        .btn-success { background-color: var(--sage) !important; border-color: var(--moss) !important; color: var(--moss) !important; font-weight: 800;}
        .btn-success:hover { background-color: var(--moss) !important; border-color: var(--moss) !important; color: var(--ivory) !important; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(70, 71, 4, 0.3); }
        
        .btn-outline-success { color: var(--moss) !important; border: 2px solid var(--moss) !important; background-color: transparent !important; font-weight: 800;}
        .btn-outline-success:hover, .btn-outline-success.active { background-color: var(--moss) !important; color: var(--ivory) !important; }

        .btn-edit { background-color: var(--khaki) !important; border-color: var(--drab) !important; color: var(--drab) !important; font-weight: 800;}
        .btn-edit:hover { background-color: var(--drab) !important; color: var(--ivory) !important; transform: translateY(-2px); box-shadow: 0 6px 16px rgba(183, 167, 140, 0.4); }

        .btn-warning { background-color: var(--khaki) !important; border-color: var(--drab) !important; color: var(--drab) !important; font-weight: 800; }
        .btn-warning:hover { background-color: var(--drab) !important; color: var(--khaki) !important; }

        .btn-info { background-color: var(--ivory) !important; border: 2px solid var(--moss) !important; color: var(--moss) !important; font-weight: 800;}
        .btn-info:hover { background-color: var(--moss) !important; color: var(--ivory) !important; }

        .text-muted, .text-secondary { color: var(--drab) !important; opacity: 0.8; }
        .text-dark { color: var(--moss) !important; }
        .badge-prod { background-color: rgba(156, 168, 137, 0.25) !important; color: var(--moss) !important; border: 1px solid rgba(156, 168, 137, 0.5); }
        .badge-cria { background-color: rgba(13, 202, 240, 0.15) !important; color: #087990 !important; border: 1px solid rgba(13, 202, 240, 0.3); }
        .badge-venta { background-color: rgba(183, 167, 140, 0.3) !important; color: var(--drab) !important; border: 1px solid rgba(183, 167, 140, 0.6); }
        .badge-sano { background-color: rgba(25, 135, 84, 0.15) !important; color: #146c43 !important; }
        .badge-enfermo { background-color: rgba(220, 53, 69, 0.15) !important; color: #b02a37 !important; }

        .glass-panel { background: #FFFFFF !important; border: 1px solid var(--border-subtle) !important; border-radius: 24px; box-shadow: var(--glass-shadow); padding: 25px; margin-bottom: 20px;}
        .apple-tabs-wrapper { background: var(--ivory); padding: 6px; border-radius: 18px; display: inline-flex; gap: 5px; border: 1px solid var(--border-subtle); margin-bottom: 20px;}
        .nav-tabs { border-bottom: none; gap: 0; }
        .nav-tabs .nav-link { color: var(--drab); font-weight: 700; border: none; border-radius: 14px; padding: 10px 24px; transition: all 0.3s ease; }
        .nav-tabs .nav-link:hover { color: var(--moss); }
        .nav-tabs .nav-link.active { color: var(--moss) !important; background-color: var(--bg-card) !important; border: 1px solid var(--border-subtle); box-shadow: 0 4px 12px rgba(70, 71, 4, 0.08); }
        .table-custom-wrapper { border-radius: 20px; overflow: hidden; background: #FFFFFF; border: 1px solid var(--border-subtle); }
        .table { margin-bottom: 0; background: transparent; }
        .table th { white-space: nowrap; font-weight: 800; text-transform: uppercase; font-size: 0.75rem; padding: 18px 15px; border-bottom: 2px solid var(--border-subtle) !important; background-color: var(--ivory); color: var(--moss);}
        .table td { vertical-align: middle; padding: 16px 15px; color: var(--drab); font-size: 0.95rem; border-bottom: 1px solid var(--border-subtle) !important; font-weight: 500;}
        .table-hover tbody tr:hover td { background-color: var(--ivory); }
        .cow-thumbnail { width: 55px; height: 55px; object-fit: cover; border-radius: 50%; border: 2px solid var(--border-subtle); box-shadow: 0 4px 12px rgba(70,71,4,0.1); transition: transform 0.4s ease; }
        .cow-thumbnail:hover { transform: scale(1.3); z-index: 10; position: relative; border-color: var(--moss); }
        .cow-placeholder { width: 55px; height: 55px; border-radius: 50%; background: var(--ivory); border: 2px dashed var(--sage); display: flex; align-items: center; justify-content: center; font-size: 24px; color: var(--moss); }
        div.dataTables_wrapper div.dataTables_filter input { border-radius: 20px; border: 2px solid var(--border-subtle); padding: 8px 16px; outline: none; transition: 0.3s; color: var(--moss); font-weight: 600;}
        div.dataTables_wrapper div.dataTables_filter input:focus { border-color: var(--moss); box-shadow: 0 0 0 4px rgba(70, 71, 4, 0.1); }
        .dt-buttons .btn { border-radius: 12px; font-weight: 700; padding: 6px 16px; margin-right: 8px; border-width: 2px;}
        .page-item.active .page-link { background-color: var(--moss) !important; border-color: var(--moss) !important; color: white !important; border-radius: 10px;}
        .page-link { color: var(--moss); border-radius: 10px; margin: 0 3px; font-weight: 600; border: 1px solid var(--border-subtle); }
        .bovino-card { background: #FFFFFF; border: 1px solid var(--border-subtle) !important; border-radius: 24px; overflow: hidden; transition: all 0.4s ease; box-shadow: var(--card-shadow); }
        .bovino-card:hover { transform: translateY(-8px); box-shadow: 0 15px 35px rgba(70,71,4,0.12); border-color: var(--sage) !important;}
        
        .card-img-wrapper { height: 190px; position: relative; background: var(--ivory); display: flex; justify-content: center; align-items: center; margin: 8px 8px 0 8px; border-radius: 18px; overflow: hidden;}
        .card-img-wrapper img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s ease; }
        .bovino-card:hover .card-img-wrapper img { transform: scale(1.05); }
        .card-placeholder-icon { font-size: 70px; opacity: 0.5; color: var(--sage); }
        
        .card-stat-box { background: var(--ivory); border-radius: 14px; padding: 10px; text-align: center; flex: 1; border: 1px solid var(--border-subtle);}
        .action-btn { transition: all 0.3s ease; border-radius: 12px; width: 38px; height: 38px; display: inline-flex; align-items: center; justify-content: center; padding: 0; font-size: 1.1rem; }
        .action-btn:hover { transform: translateY(-3px); box-shadow: 0 6px 16px rgba(70,71,4,0.15); }
                .modal-content { background: #FFFFFF; border: none !important; border-radius: 32px; box-shadow: 0 25px 50px rgba(70,71,4,0.25); }
        .modal-header, .modal-footer { border: none !important; padding: 25px 30px; }
        .form-control, .form-select { border-radius: 16px; padding: 14px 18px; background: var(--ivory) !important; border: 1px solid var(--border-subtle) !important; color: var(--drab) !important; transition: all 0.3s ease; font-weight: 600; }
        .form-control:focus, .form-select:focus { background: #ffffff !important; border-color: var(--moss) !important; box-shadow: 0 0 0 4px rgba(70, 71, 4, 0.2) !important; outline: none; }
        .modal-section-card { background: var(--ivory) !important; border: 1px solid var(--border-subtle) !important; border-radius: 24px; padding: 25px; margin-bottom: 20px; }
        .form-switch .form-check-input { width: 3rem; height: 1.5rem; margin-top: 0.1rem; cursor: pointer; background-color: var(--sage); border-color: var(--moss); }
        .form-switch .form-check-input:checked { background-color: var(--moss) !important; border-color: var(--moss) !important; }

        .d-none { display: none !important; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<%
    Usuario usr = (Usuario) session.getAttribute("usuarioLogueado");
    String rolActual = (usr != null && usr.getRol() != null) ? usr.getRol() : "";
    boolean esVeterinario = rolActual.equals("2") || rolActual.equalsIgnoreCase("Veterinario");
    boolean esOperario = rolActual.equals("3") || rolActual.equalsIgnoreCase("Operario");

    List<Bovino> listaProd = (List<Bovino>) request.getAttribute("listaProduccion");
    List<Bovino> listaVenta = (List<Bovino>) request.getAttribute("listaVenta");
    List<Bovino> listaCriasData = (List<Bovino>) request.getAttribute("listaCrias");
    
    List<Bovino> listaTodos = new ArrayList<>();
    if(listaProd != null) listaTodos.addAll(listaProd);
    if(listaVenta != null) listaTodos.addAll(listaVenta);
    if(listaCriasData != null) listaTodos.addAll(listaCriasData);
    
    List<Bovino> listaCrias = new ArrayList<>();
    if(listaCriasData != null) { listaCrias.addAll(listaCriasData); } 
    else { for(Bovino b : listaTodos) { if("Cría".equals(b.getClasificacion())) { listaCrias.add(b); } } }
    
    listaTodos.sort((a, b) -> Integer.compare(b.getIdBovino(), a.getIdBovino()));
    listaCrias.sort((a, b) -> Integer.compare(b.getIdBovino(), a.getIdBovino()));
%>

<input type="hidden" id="appContextPath" value="<%= request.getContextPath() %>">
<input type="hidden" id="esOperario" value="<%= esOperario %>">
<%
    StringBuilder aretesBuilder = new StringBuilder();
    if(listaTodos != null) { for(Bovino b : listaTodos) { aretesBuilder.append(b.getNumeroArete()).append(","); } }
%>
<input type="hidden" id="existingAretesData" value="<%= aretesBuilder.toString() %>">

<div class="container py-4">

    <div class="glass-panel mb-4 d-flex flex-column flex-md-row justify-content-between align-items-center">
        <div>
            <h2 class="fw-bold mb-1" style="color: var(--moss);"><i class="bi bi-boxes text-success"></i> Gestión de Inventario</h2>
            <p class="text-muted mb-0 fw-bold">Administración general del ganado de la finca</p>
        </div>
        
        <div class="d-flex gap-3 mt-3 mt-md-0 align-items-center">
            <div class="bg-white border rounded-pill p-1 shadow-sm d-flex align-items-center" style="border-color: var(--border-subtle) !important;">
                <button type="button" class="btn btn-sm btn-outline-success border-0 rounded-pill active" id="btn-list" onclick="setView('list')" title="Vista de Lista" style="padding: 5px 15px;">
                    <i class="bi bi-list-ul fs-5"></i>
                </button>
                <button type="button" class="btn btn-sm btn-outline-success border-0 rounded-pill" id="btn-grid" onclick="setView('grid')" title="Vista de Tarjetas" style="padding: 5px 15px;">
                    <i class="bi bi-grid-fill fs-5"></i>
                </button>
            </div>

            <% if(!esVeterinario && !esOperario) { %>
            <button class="btn btn-success btn-lg shadow-sm rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#modalBovino">
                <i class="bi bi-plus-circle-fill me-1"></i> Registrar
            </button>
            <% } %>
        </div>
    </div>

    <div class="text-center text-md-start">
        <div class="apple-tabs-wrapper">
            <ul class="nav nav-tabs" id="inventarioTabs">
                <li class="nav-item">
                    <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#todos"><i class="bi bi-collection-fill me-1"></i> Todos</button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#produccion"><i class="bi bi-droplet-fill me-1"></i> Hato Lechero</button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#crias"><i class="bi bi-brightness-alt-high-fill me-1"></i> Crías / Levante</button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#ventas"><i class="bi bi-tags-fill me-1"></i> Para Venta</button>
                </li>
            </ul>
        </div>
    </div>

    <div class="tab-content glass-panel p-4">
        
        <div class="tab-pane fade show active" id="todos">
            
            <div class="view-list table-responsive table-custom-wrapper">
                <table class="table align-middle" id="tableTodos">
                    <thead class="text-center">
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
                            for(Bovino b : listaTodos) { 
                                boolean isSano = "Sano".equalsIgnoreCase(b.getEstadoSalud()) || "Sana".equalsIgnoreCase(b.getEstadoSalud());
                                String bgSalud = isSano ? "badge-sano" : "badge-enfermo";
                                String iconSalud = isSano ? "bi-heart-fill" : "bi-bandaid-fill";
                        %>
                        <tr>
                            <td>
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto" class="cow-thumbnail mx-auto d-block">
                                <% } else { %>
                                    <div class="cow-placeholder mx-auto text-secondary"><i class="bi bi-camera"></i></div>
                                <% } %>
                            </td>
                            <td class="fw-bolder fs-5 text-dark"><%= b.getNumeroArete() %></td>
                            <td>
                                <div class="fw-bold text-dark"><%= b.getRaza() %></div>
                                <span class="badge bg-light text-secondary border mt-1 rounded-pill fw-normal"><%= b.getGenero() %></span>
                            </td>
                            <td>
                                <%
                                    String badgeClass = "badge-venta";
                                    if(b.getClasificacion().equals("Producción")) badgeClass = "badge-prod";
                                    else if(b.getClasificacion().equals("Cría")) badgeClass = "badge-cria";
                                %>
                                <span class="badge <%= badgeClass %> px-3 py-2 rounded-pill fw-bold"><%= b.getClasificacion() %></span>
                            </td>
                            <td>
                                <span class="badge <%= bgSalud %> px-3 py-2 rounded-pill">
                                    <i class="bi <%= iconSalud %>"></i> <%= b.getEstadoSalud() %>
                                </span>
                            </td>
                            <td>
                                <div class="d-flex gap-2 justify-content-center flex-wrap">
                                    <button class="btn btn-info action-btn btn-resumen" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalResumen" title="Vista Rápida"><i class="bi bi-eye-fill"></i></button>
                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success action-btn" title="Historial Médico"><i class="bi bi-journal-medical"></i></a>
                                    <button class="btn btn-edit action-btn btn-editar" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalEditarBovino" title="Editar"><i class="bi bi-pencil-fill"></i></button>
                                    
                                    <% if(!esVeterinario && !esOperario) { %>
                                        <% if(b.getClasificacion().equals("Producción") || b.getClasificacion().equals("Cría")) { %>
                                            <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Venta"><button type="submit" class="btn btn-warning action-btn" title="Mover a Venta" onclick="return confirm('¿Mover a lote de venta?');"><i class="bi bi-tag-fill"></i></button></form>
                                        <% } else if(b.getClasificacion().equals("Venta") && b.getGenero().equals("Hembra")) { %>
                                            <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Producción"><button type="submit" class="btn btn-success action-btn" title="Regresar a Producción" onclick="return confirm('¿Regresar a producción?');"><i class="bi bi-droplet-fill"></i></button></form>
                                        <% } %>
                                        <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><button type="submit" class="btn btn-danger action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill text-white"></i></button></form>
                                    <% } %>
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
                        for(Bovino b : listaTodos) { 
                            boolean isSano = "Sano".equalsIgnoreCase(b.getEstadoSalud()) || "Sana".equalsIgnoreCase(b.getEstadoSalud());
                            String textSalud = isSano ? "text-success" : "text-danger";
                            String iconSalud = isSano ? "bi-check-circle-fill" : "bi-exclamation-circle-fill";
                            
                            String badgeClassGrid = "badge-venta";
                            if(b.getClasificacion().equals("Producción")) badgeClassGrid = "badge-prod";
                            else if(b.getClasificacion().equals("Cría")) badgeClassGrid = "badge-cria";
                    %>
                    <div class="col">
                        <div class="bovino-card d-flex flex-column h-100">
                            <div class="card-img-wrapper">
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto Bovino">
                                <% } else { %>
                                    <i class="bi bi-camera card-placeholder-icon opacity-25"></i>
                                <% } %>
                            </div>
                            
                            <div class="card-body p-4 pb-3 flex-grow-1 d-flex flex-column">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <div class="d-flex align-items-center gap-2">
                                        <h4 class="fw-bolder text-dark mb-0"><%= b.getNumeroArete() %></h4>
                                        <i class="bi <%= b.getGenero().equals("Hembra") ? "bi-gender-female text-danger" : "bi-gender-male text-primary" %> fs-5 opacity-75"></i>
                                    </div>
                                    <span class="badge <%= badgeClassGrid %> rounded-pill px-3 py-1"><%= b.getClasificacion() %></span>
                                </div>
                                <p class="text-muted fw-semibold mb-3" style="font-size: 0.85rem;"><%= b.getRaza() %> • <%= b.getEdadAnios() %> años</p>
                                
                                <div class="d-flex justify-content-around mb-3 p-2 rounded-4" style="background: var(--ivory); border: 1px solid var(--border-subtle);">
                                    <div class="text-center w-50 border-end border-light">
                                        <small class="text-muted d-block" style="font-size: 10px; font-weight:800; letter-spacing: 0.5px;">PESO</small>
                                        <strong class="text-dark"><%= b.getPesoKg() %> kg</strong>
                                    </div>
                                    <div class="text-center w-50">
                                        <small class="text-muted d-block" style="font-size: 10px; font-weight:800; letter-spacing: 0.5px;">SALUD</small>
                                        <strong class="<%= textSalud %>"><i class="bi <%= iconSalud %>"></i> <%= b.getEstadoSalud() %></strong>
                                    </div>
                                </div>
                                
                                <div class="d-flex gap-2 justify-content-center flex-wrap pt-3 border-top mt-auto" style="border-color: var(--border-subtle) !important;">
                                    <button class="btn btn-info action-btn btn-resumen" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalResumen" title="Vista Rápida"><i class="bi bi-eye-fill"></i></button>
                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success action-btn" title="Historial Médico"><i class="bi bi-journal-medical"></i></a>
                                    <button class="btn btn-edit action-btn btn-editar" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalEditarBovino" title="Editar"><i class="bi bi-pencil-fill"></i></button>
                                    
                                    <% if(!esVeterinario && !esOperario) { %>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Venta"><button type="submit" class="btn btn-warning action-btn" title="Mover a Venta"><i class="bi bi-tag-fill"></i></button></form>
                                    <% if(b.getGenero().equals("Hembra")) { %>
                                        <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Producción"><button type="submit" class="btn btn-success action-btn" title="Pasar a Producción"><i class="bi bi-droplet-fill"></i></button></form>
                                    <% } %>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><button type="submit" class="btn btn-danger action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill text-white"></i></button></form>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% }} %>
                </div>
            </div>
        </div>

        <div class="tab-pane fade" id="produccion">
            <div class="view-list table-responsive table-custom-wrapper">
                <table class="table align-middle mb-0" id="tableProduccion">
                    <thead class="text-center">
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
                            for(Bovino b : listaProd) { 
                                boolean isSano = "Sano".equalsIgnoreCase(b.getEstadoSalud()) || "Sana".equalsIgnoreCase(b.getEstadoSalud());
                                String bgSalud = isSano ? "badge-sano" : "badge-enfermo";
                        %>
                        <tr>
                            <td>
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto" class="cow-thumbnail mx-auto d-block">
                                <% } else { %>
                                    <div class="cow-placeholder mx-auto text-success"><i class="bi bi-camera"></i></div>
                                <% } %>
                            </td>
                            <td class="fw-bolder fs-5 text-dark"><%= b.getNumeroArete() %></td>
                            <td>
                                <div class="fw-bold text-dark"><%= b.getRaza() %></div>
                                <span class="badge bg-light text-secondary border mt-1 rounded-pill fw-normal"><%= b.getEdadAnios() %> años</span>
                            </td>
                            <td>
                                <div class="badge-prod fw-bold rounded-pill py-2 px-3 d-inline-block">
                                    <i class="bi bi-droplet-half"></i> <%= b.getLitrosDiariosPromedio() %> L
                                </div>
                            </td>
                            <td>
                                <span class="badge <%= bgSalud %> rounded-pill px-3 py-2">
                                    <%= b.getEstadoSalud() %>
                                </span>
                            </td>
                            <td>
                                <div class="d-flex gap-2 justify-content-center flex-wrap">
                                    <button class="btn btn-info action-btn btn-resumen" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalResumen"><i class="bi bi-eye-fill"></i></button>
                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success action-btn"><i class="bi bi-journal-medical"></i></a>
                                    <button class="btn btn-edit action-btn btn-editar" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalEditarBovino"><i class="bi bi-pencil-fill"></i></button>
                                    <% if(!esVeterinario && !esOperario) { %>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Venta"><button type="submit" class="btn btn-warning action-btn" title="Mover a Venta"><i class="bi bi-tag-fill"></i></button></form>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><button type="submit" class="btn btn-danger action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill text-white"></i></button></form>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr><td colspan="6" class="text-center py-5 text-muted"><i class="bi bi-droplet fs-1 d-block mb-3 opacity-50"></i>Hato lechero vacío.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <div class="view-grid d-none">
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-4 mt-1">
                    <% if(listaProd != null && !listaProd.isEmpty()) {
                        for(Bovino b : listaProd) { 
                            boolean isSano = "Sano".equalsIgnoreCase(b.getEstadoSalud()) || "Sana".equalsIgnoreCase(b.getEstadoSalud());
                            String textSalud = isSano ? "text-success" : "text-danger";
                            String iconSalud = isSano ? "bi-check-circle-fill" : "bi-exclamation-circle-fill";
                    %>
                    <div class="col">
                        <div class="bovino-card d-flex flex-column h-100">
                            <div class="card-img-wrapper">
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto">
                                <% } else { %>
                                    <i class="bi bi-droplet card-placeholder-icon text-success opacity-50"></i>
                                <% } %>
                            </div>
                            <div class="card-body p-4 pb-3 flex-grow-1 d-flex flex-column">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h4 class="fw-bolder text-dark mb-0"><%= b.getNumeroArete() %></h4>
                                    <span class="badge badge-prod rounded-pill px-3 py-1">Producción</span>
                                </div>
                                <p class="text-muted fw-semibold small mb-3"><%= b.getRaza() %> • <%= b.getEdadAnios() %> años</p>
                                
                                <div class="w-100 text-center p-2 rounded-4 mb-3 badge-prod">
                                    <small class="d-block fw-bold" style="font-size: 10px; letter-spacing: 0.5px; opacity: 0.8;">PRODUCCIÓN PROMEDIO</small>
                                    <strong class="fs-5"><i class="bi bi-droplet-half"></i> <%= b.getLitrosDiariosPromedio() %> L <span class="fs-6 fw-normal">/ día</span></strong>
                                </div>

                                <div class="d-flex gap-2 justify-content-center mt-auto border-top pt-3" style="border-color: var(--border-subtle) !important;">
                                    <button class="btn btn-info action-btn btn-resumen" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalResumen"><i class="bi bi-eye-fill"></i></button>
                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success action-btn"><i class="bi bi-journal-medical"></i></a>
                                    <button class="btn btn-edit action-btn btn-editar" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalEditarBovino"><i class="bi bi-pencil-fill"></i></button>
                                    <% if(!esVeterinario && !esOperario) { %>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Venta"><button type="submit" class="btn btn-warning action-btn" title="Mover a Venta"><i class="bi bi-tag-fill"></i></button></form>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><button type="submit" class="btn btn-danger action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill text-white"></i></button></form>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% }} %>
                </div>
            </div>
        </div>

        <div class="tab-pane fade" id="crias">
            <div class="view-list table-responsive table-custom-wrapper">
                <table class="table align-middle mb-0" id="tableCrias">
                    <thead class="text-center">
                        <tr>
                            <th>Foto</th>
                            <th>Arete</th>
                            <th>Raza / Género</th>
                            <th>Peso (Kg)</th>
                            <th>Salud</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody class="text-center table-hover">
                        <% if(!listaCrias.isEmpty()) {
                            for(Bovino b : listaCrias) { 
                                boolean isSano = "Sano".equalsIgnoreCase(b.getEstadoSalud()) || "Sana".equalsIgnoreCase(b.getEstadoSalud());
                                String bgSalud = isSano ? "badge-sano" : "badge-enfermo";
                        %>
                        <tr>
                            <td>
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto" class="cow-thumbnail mx-auto d-block">
                                <% } else { %>
                                    <div class="cow-placeholder mx-auto text-info"><i class="bi bi-camera"></i></div>
                                <% } %>
                            </td>
                            <td class="fw-bolder fs-5 text-dark"><%= b.getNumeroArete() %></td>
                            <td>
                                <div class="fw-bold text-dark"><%= b.getRaza() %></div>
                                <span class="badge border bg-light text-secondary rounded-pill fw-normal mt-1"><%= b.getGenero() %></span>
                            </td>
                            <td><strong class="fs-6 text-dark"><%= b.getPesoKg() %> kg</strong></td>
                            <td>
                                <span class="badge <%= bgSalud %> px-3 py-2 rounded-pill fw-bold">
                                    <%= b.getEstadoSalud() %>
                                </span>
                            </td>
                            <td>
                                <div class="d-flex gap-2 justify-content-center flex-wrap">
                                    <button class="btn btn-info action-btn btn-resumen" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalResumen"><i class="bi bi-eye-fill"></i></button>
                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success action-btn"><i class="bi bi-journal-medical"></i></a>
                                    <button class="btn btn-edit action-btn btn-editar" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalEditarBovino"><i class="bi bi-pencil-fill"></i></button>
                                    <% if(!esVeterinario && !esOperario) { %>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Venta"><button type="submit" class="btn btn-warning action-btn" title="Mover a Venta"><i class="bi bi-tag-fill"></i></button></form>
                                    <% if(b.getGenero().equals("Hembra")) { %>
                                        <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Producción"><button type="submit" class="btn btn-success action-btn" title="Pasar a Producción"><i class="bi bi-droplet-fill"></i></button></form>
                                    <% } %>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><button type="submit" class="btn btn-danger action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill text-white"></i></button></form>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr><td colspan="6" class="text-center py-5 text-muted"><i class="bi bi-brightness-alt-high fs-1 d-block mb-3 opacity-50"></i>No hay crías en etapa de levante.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <div class="view-grid d-none">
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-4 mt-1">
                    <% if(!listaCrias.isEmpty()) {
                        for(Bovino b : listaCrias) { 
                            boolean isSano = "Sano".equalsIgnoreCase(b.getEstadoSalud()) || "Sana".equalsIgnoreCase(b.getEstadoSalud());
                            String textSalud = isSano ? "text-success" : "text-danger";
                            String iconSalud = isSano ? "bi-check-circle-fill" : "bi-exclamation-circle-fill";
                    %>
                    <div class="col">
                        <div class="bovino-card d-flex flex-column h-100">
                            <div class="card-img-wrapper">
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto">
                                <% } else { %>
                                    <i class="bi bi-brightness-alt-high card-placeholder-icon text-info opacity-50"></i>
                                <% } %>
                            </div>
                            <div class="card-body p-4 pb-3 flex-grow-1 d-flex flex-column">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h4 class="fw-bolder text-dark mb-0"><%= b.getNumeroArete() %></h4>
                                    <span class="badge badge-cria rounded-pill px-3 py-1">Cría / Levante</span>
                                </div>
                                <p class="text-muted fw-semibold small mb-3"><%= b.getRaza() %> • <%= b.getGenero() %></p>
                                
                                <div class="d-flex justify-content-around mb-4 mt-auto p-2 rounded-4" style="background: var(--ivory); border: 1px solid var(--border-subtle);">
                                    <div class="text-center w-50 border-end border-light">
                                        <small class="text-muted d-block fw-bold" style="font-size: 10px; letter-spacing:0.5px;">PESO</small>
                                        <strong class="text-dark"><%= b.getPesoKg() %> kg</strong>
                                    </div>
                                    <div class="text-center w-50">
                                        <small class="text-muted d-block fw-bold" style="font-size: 10px; letter-spacing:0.5px;">SALUD</small>
                                        <strong class="<%= textSalud %>"><i class="bi <%= iconSalud %>"></i> <%= b.getEstadoSalud() %></strong>
                                    </div>
                                </div>
                                
                                <div class="d-flex gap-2 justify-content-center flex-wrap pt-3 border-top mt-auto" style="border-color: var(--border-subtle) !important;">
                                    <button class="btn btn-info action-btn btn-resumen" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalResumen"><i class="bi bi-eye-fill"></i></button>
                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success action-btn"><i class="bi bi-journal-medical"></i></a>
                                    <button class="btn btn-edit action-btn btn-editar" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalEditarBovino"><i class="bi bi-pencil-fill"></i></button>
                                    
                                    <% if(!esVeterinario && !esOperario) { %>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Venta"><button type="submit" class="btn btn-warning action-btn" title="Mover a Venta"><i class="bi bi-tag-fill"></i></button></form>
                                    <% if(b.getGenero().equals("Hembra")) { %>
                                        <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Producción"><button type="submit" class="btn btn-success action-btn" title="Pasar a Producción"><i class="bi bi-droplet-fill"></i></button></form>
                                    <% } %>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><button type="submit" class="btn btn-danger action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill text-white"></i></button></form>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% }} %>
                </div>
            </div>
        </div>

        <div class="tab-pane fade" id="ventas">
            <div class="view-list table-responsive table-custom-wrapper">
                <table class="table align-middle mb-0" id="tableVentas">
                    <thead class="text-center">
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
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto" class="cow-thumbnail mx-auto d-block">
                                <% } else { %>
                                    <div class="cow-placeholder mx-auto text-warning"><i class="bi bi-camera"></i></div>
                                <% } %>
                            </td>
                            <td class="fw-bolder fs-5 text-dark"><%= b.getNumeroArete() %></td>
                            <td>
                                <div class="fw-bold text-dark"><%= b.getRaza() %></div>
                                <span class="badge border bg-light text-secondary rounded-pill fw-normal mt-1"><%= b.getGenero() %></span>
                            </td>
                            <td><strong class="fs-6 text-dark"><%= b.getPesoKg() %></strong></td>
                            <td>
                                <div class="badge-venta fw-bold rounded-pill py-2 px-3 d-inline-block shadow-sm">
                                    $<%= String.format("%,.2f", b.getPrecioEstimado()) %>
                                </div>
                            </td>
                            <td>
                                <div class="d-flex gap-2 justify-content-center flex-wrap">
                                    <button class="btn btn-info action-btn btn-resumen" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalResumen"><i class="bi bi-eye-fill"></i></button>
                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success action-btn"><i class="bi bi-journal-medical"></i></a>
                                    <button class="btn btn-edit action-btn btn-editar" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalEditarBovino"><i class="bi bi-pencil-fill"></i></button>
                                    
                                    <% if(!esVeterinario && !esOperario) { %>
                                    <% if(b.getGenero().equals("Hembra")) { %>
                                        <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Producción"><button type="submit" class="btn btn-success action-btn" title="Regresar a Producción"><i class="bi bi-droplet-fill"></i></button></form>
                                    <% } %>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><button type="submit" class="btn btn-danger action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill text-white"></i></button></form>
                                    <% } %>
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
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-4 mt-1">
                    <% if(listaVenta != null && !listaVenta.isEmpty()) {
                        for(Bovino b : listaVenta) { %>
                    <div class="col">
                        <div class="bovino-card d-flex flex-column h-100">
                            <div class="card-img-wrapper">
                                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty() && !b.getImageUrl().equals("null")) { %>
                                    <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>" alt="Foto">
                                <% } else { %>
                                    <i class="bi bi-tags card-placeholder-icon text-warning opacity-50"></i>
                                <% } %>
                            </div>
                            <div class="card-body p-4 pb-3 flex-grow-1 d-flex flex-column">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h4 class="fw-bolder text-dark mb-0"><%= b.getNumeroArete() %></h4>
                                    <span class="badge badge-venta rounded-pill px-3 py-1">Venta</span>
                                </div>
                                <p class="text-muted fw-semibold small mb-3"><%= b.getRaza() %> • <%= b.getGenero() %></p>
                                
                                <div class="w-100 text-center p-2 rounded-4 mb-3 badge-venta">
                                    <small class="d-block fw-bold" style="font-size: 10px; letter-spacing: 0.5px; opacity: 0.8;">PRECIO ESTIMADO</small>
                                    <strong class="fs-5"><i class="bi bi-tag-fill me-1"></i> $<%= String.format("%,.2f", b.getPrecioEstimado()) %></strong>
                                </div>
                                
                                <div class="d-flex gap-2 justify-content-center flex-wrap pt-3 border-top mt-auto" style="border-color: var(--border-subtle) !important;">
                                    <button class="btn btn-info action-btn btn-resumen" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-edad="<%= b.getEdadAnios() %>" data-peso="<%= b.getPesoKg() %>" data-partos="<%= b.getNumeroPartos() %>" data-proposito="<%= b.getProposito() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalResumen"><i class="bi bi-eye-fill"></i></button>
                                    <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-success action-btn"><i class="bi bi-journal-medical"></i></a>
                                    <button class="btn btn-edit action-btn btn-editar" data-id="<%= b.getIdBovino() %>" data-arete="<%= b.getNumeroArete() %>" data-raza="<%= b.getRaza() %>" data-fecha="<%= b.getFechaNacimiento() %>" data-genero="<%= b.getGenero() %>" data-peso="<%= b.getPesoKg() %>" data-clasificacion="<%= b.getClasificacion() %>" data-proposito="<%= b.getProposito() %>" data-salud="<%= b.getEstadoSalud() %>" data-leche="<%= b.getLitrosDiariosPromedio() %>" data-partos="<%= b.getNumeroPartos() %>" data-precio="<%= b.getPrecioEstimado() %>" data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>" data-bs-toggle="modal" data-bs-target="#modalEditarBovino"><i class="bi bi-pencil-fill"></i></button>
                                    
                                    <% if(!esVeterinario && !esOperario) { %>
                                    <% if(b.getGenero().equals("Hembra")) { %>
                                        <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="mover"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><input type="hidden" name="destino" value="Producción"><button type="submit" class="btn btn-success action-btn" title="Regresar a Producción"><i class="bi bi-droplet-fill"></i></button></form>
                                    <% } %>
                                    <form action="inventario-ganado" method="POST" class="d-inline"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= b.getIdBovino() %>"><button type="submit" class="btn btn-danger action-btn" title="Eliminar" onclick="return confirm('¿Eliminar definitivamente?');"><i class="bi bi-trash3-fill text-white"></i></button></form>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% }} %>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalResumen" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0">
            <div class="modal-header border-0 pb-0 justify-content-center position-relative mt-3">
                <h4 class="modal-title fw-bold text-dark"><i class="bi bi-info-circle-fill text-success me-2"></i> Resumen</h4>
                <button type="button" class="btn-close position-absolute end-0 me-4" data-bs-dismiss="modal" style="top: 50%; transform: translateY(-50%);"></button>
            </div>
            
            <div class="modal-body py-4 px-4">
                <div class="text-center mb-4 position-relative">
                    <img id="resFoto" src="" class="rounded-circle mb-3 border border-3 shadow d-none" style="width: 150px; height: 150px; object-fit: cover; border-color: var(--border-subtle) !important;">
                    <div id="resFotoPlaceholder" class="rounded-circle bg-light border border-3 shadow-sm mx-auto mb-3 d-flex align-items-center justify-content-center" style="width: 150px; height: 150px; font-size: 60px; border-color: var(--border-subtle) !important;"><i class="bi bi-camera"></i></div>
                    
                    <h3 class="fw-bold text-dark mb-2" id="resArete"></h3>
                    <h6 class="text-muted fw-semibold mb-2" id="resRaza"></h6>
                    <span id="resSalud" class="badge fs-6 rounded-pill px-4 py-2 shadow-sm border border-dark"></span>
                </div>
                
                <div class="row g-3 text-start bg-white p-3 rounded-4 shadow-sm border border-light">
                    <div class="col-6 d-flex align-items-center">
                        <i class="bi bi-calendar3 fs-3 text-secondary me-3"></i>
                        <div><span class="text-muted small d-block text-uppercase fw-bold" style="font-size: 11px;">Edad</span><strong class="fs-6 text-dark"><span id="resEdad"></span> años</strong></div>
                    </div>
                    <div class="col-6 d-flex align-items-center">
                        <i class="bi bi-speedometer2 fs-3 text-success me-3"></i>
                        <div><span class="text-muted small d-block text-uppercase fw-bold" style="font-size: 11px;">Peso Actual</span><strong class="fs-6 text-dark"><span id="resPeso"></span> Kg</strong></div>
                    </div>
                    <div class="col-6 d-flex align-items-center">
                        <i class="bi bi-bullseye fs-3 text-secondary me-3"></i>
                        <div><span class="text-muted small d-block text-uppercase fw-bold" style="font-size: 11px;">Propósito</span><strong class="fs-6 text-dark" id="resProposito"></strong></div>
                    </div>
                    <div class="col-6 d-flex align-items-center">
                        <i class="bi bi-clipboard2-plus fs-3 text-success me-3"></i>
                        <div><span class="text-muted small d-block text-uppercase fw-bold" style="font-size: 11px;">N° Partos</span><strong class="fs-6 text-dark" id="resPartos"></strong></div>
                    </div>
                </div>

                <div class="mt-4 text-center rounded-4 p-3 shadow-sm text-white" style="background-color: var(--moss);">
                    <p class="mb-1 text-uppercase fw-bold" style="letter-spacing: 1px; font-size: 12px; color: var(--ivory);">Producción Promedio</p>
                    <h2 class="fw-bold mb-0"><i class="bi bi-droplet-half"></i> <span id="resLeche"></span> <small class="fs-5 opacity-75">L/día</small></h2>
                </div>
            </div>
            
            <div class="modal-footer border-0 pt-0 pb-4 px-4 d-flex justify-content-center">
                <a href="#" id="btnInfoCompleta" class="btn btn-success btn-lg fw-bold w-100 shadow-sm rounded-pill"><i class="bi bi-journal-medical me-2"></i> Ver Historial Médico</a>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalBovino" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0">
            <div class="modal-header border-0 pb-0 justify-content-center position-relative mt-3">
                <h4 class="modal-title fw-bold text-dark"><i class="bi bi-plus-circle-fill text-success me-2"></i> Registrar Animal</h4>
                <button type="button" class="btn-close position-absolute end-0 me-4" data-bs-dismiss="modal" style="top: 50%; transform: translateY(-50%);"></button>
            </div>
            
            <form action="inventario-ganado" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                <div class="modal-body px-4 py-4">
                    
                    <div class="mb-4">
                        <div class="modal-section-card d-flex justify-content-between align-items-center shadow-sm">
                            <div class="d-flex align-items-center">
                                <div class="bg-success-subtle text-success rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                                    <i class="bi bi-brightness-alt-high-fill fs-5" style="margin: 0; padding: 0;"></i>
                                </div>
                                <div>
                                    <h6 class="mb-0 fw-bold text-dark">¿Es una cría recién nacida?</h6>
                                    <small class="text-muted">Autocompleta datos de nacimiento y bloquea producción</small>
                                </div>
                            </div>
                            <div class="form-check form-switch fs-4 mb-0">
                                <input class="form-check-input shadow-sm" type="checkbox" id="recienNacidaToggle" onchange="actualizarCamposLogicosAdd()">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row g-4">
                        <div class="col-12 text-center mb-2">
                            <label class="form-label text-muted fw-bold small text-uppercase w-100 text-start ps-1"><i class="bi bi-camera-fill text-success fs-5 me-1"></i> Fotografía</label>
                            <img id="previewAdd" src="" class="d-none rounded-4 shadow-sm mb-3" style="width: 130px; height: 130px; object-fit: cover; border: 3px solid #fff; margin: 0 auto;">
                            <input type="file" name="imageFile" class="form-control shadow-sm" accept="image/*" onchange="previewImage(this, 'previewAdd')">
                        </div>
                    </div>

                    <div class="modal-section-card mt-3">
                        <h6 class="fw-bold text-success mb-3"><i class="bi bi-card-heading me-1"></i> Identificación y Origen</h6>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="d-flex justify-content-between align-items-center mb-1 ps-1">
                                    <label class="form-label text-muted fw-bold small text-uppercase mb-0">Número de Arete</label>
                                    <div class="form-check form-switch mb-0">
                                        <input class="form-check-input" type="checkbox" id="autoAreteToggle" onchange="toggleAutoArete()">
                                        <label class="form-check-label text-muted small fw-bold" for="autoAreteToggle">Auto</label>
                                    </div>
                                </div>
                                <input type="text" name="numeroArete" id="inputAreteAdd" class="form-control shadow-sm" placeholder="Ej: V-001" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1 mt-2 mt-md-0">Raza</label>
                                <input type="text" name="raza" class="form-control shadow-sm" placeholder="Ej: Holstein, Brahman" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Nacimiento</label>
                                <input type="date" name="fechaNacimiento" id="addFechaNacimiento" class="form-control shadow-sm" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Género</label>
                                <select name="genero" id="addGenero" class="form-select shadow-sm" required onchange="actualizarCamposLogicosAdd()">
                                    <option value="Hembra">Hembra</option>
                                    <option value="Macho">Macho</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="modal-section-card">
                        <h6 class="fw-bold text-success mb-3"><i class="bi bi-activity me-1"></i> Estado y Producción</h6>
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Peso (Kg)</label>
                                <input type="number" step="0.01" name="pesoKg" class="form-control shadow-sm" placeholder="0.00" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Clasificación</label>
                                <select name="clasificacion" id="addClasificacion" class="form-select shadow-sm" required>
                                    <option value="Cría">Cría / Levante</option>
                                    <option value="Producción">Producción (Hato Lechero)</option>
                                    <option value="Venta">Para Venta</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Propósito</label>
                                <select name="proposito" id="addProposito" class="form-select shadow-sm" required>
                                    <option value="Leche">Leche</option>
                                    <option value="Carne">Carne</option>
                                    <option value="Doble Propósito">Doble Propósito</option>
                                </select>
                            </div>
                            
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Estado de Salud</label>
                                <select name="estadoSalud" class="form-select shadow-sm" required>
                                    <option value="Sano">Sano / Sana</option>
                                    <option value="Enfermo">Enfermo / Enferma</option>
                                    <option value="En Tratamiento">En Tratamiento</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Litros Diarios</label>
                                <input type="number" step="0.01" name="litrosDiarios" id="addLitrosDiarios" class="form-control shadow-sm" placeholder="0.0" value="0">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">N° de Partos</label>
                                <input type="number" name="numeroPartos" id="addNumeroPartos" class="form-control shadow-sm" placeholder="0" value="0">
                            </div>
                            <div class="col-md-12">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Precio Estimado ($)</label>
                                <input type="number" step="0.01" name="precioEstimado" class="form-control shadow-sm" placeholder="Valor comercial" required>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0 pb-4 px-4 d-flex justify-content-between">
                    <button type="button" class="btn btn-outline-success fw-bold px-4 rounded-pill shadow-sm" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-success fw-bold px-5 rounded-pill shadow-sm"><i class="bi bi-save-fill me-2"></i> Guardar Registro</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="modalEditarBovino" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0">
            <div class="modal-header border-0 pb-0 justify-content-center position-relative mt-3">
                <h4 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square text-edit me-2"></i> Editar Animal</h4>
                <button type="button" class="btn-close position-absolute end-0 me-4" data-bs-dismiss="modal" style="top: 50%; transform: translateY(-50%);"></button>
            </div>
            
            <form action="inventario-ganado" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="idBovino" id="editIdBovino">
                <input type="hidden" name="imageUrl" id="editImageUrlOld">
                
                <div class="modal-body px-4 py-4">
                    <div class="row g-4">
                        <div class="col-12 text-center mb-2">
                            <label class="form-label text-muted fw-bold small text-uppercase w-100 text-start ps-1"><i class="bi bi-image-fill text-edit fs-5 me-1"></i> Cambiar Foto</label>
                            <img id="previewEdit" src="" class="d-none rounded-4 shadow-sm mb-3 mx-auto" style="width: 130px; height: 130px; object-fit: cover; border: 3px solid #fff;">
                            <input type="file" name="imageFile" class="form-control shadow-sm" accept="image/*" onchange="previewImage(this, 'previewEdit')">
                        </div>
                    </div>
                    
                    <div class="modal-section-card mt-3">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label text-edit fw-bold small text-uppercase ps-1">Número de Arete</label>
                                <input type="text" name="numeroArete" id="editArete" class="form-control shadow-sm" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Raza</label>
                                <input type="text" name="raza" id="editRaza" class="form-control shadow-sm" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Nacimiento</label>
                                <input type="date" name="fechaNacimiento" id="editFecha" class="form-control shadow-sm" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Género</label>
                                <select name="genero" id="editGenero" class="form-select shadow-sm" required onchange="actualizarCamposLogicosEdit()">
                                    <option value="Hembra">Hembra</option>
                                    <option value="Macho">Macho</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Peso (Kg)</label>
                                <input type="number" step="0.01" name="pesoKg" id="editPeso" class="form-control shadow-sm" required>
                            </div>
                        </div>
                    </div>

                    <div class="modal-section-card">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Clasificación</label>
                                <select name="clasificacion" id="editClasificacion" class="form-select shadow-sm" required>
                                    <option value="Cría">Cría / Levante</option>
                                    <option value="Producción">Producción (Hato Lechero)</option>
                                    <option value="Venta">Para Venta</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Propósito</label>
                                <select name="proposito" id="editProposito" class="form-select shadow-sm" required>
                                    <option value="Leche">Leche</option>
                                    <option value="Carne">Carne</option>
                                    <option value="Doble Propósito">Doble Propósito</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Estado de Salud</label>
                                <select name="estadoSalud" id="editSalud" class="form-select shadow-sm" required>
                                    <option value="Sano">Sano / Sana</option>
                                    <option value="Enfermo">Enfermo / Enferma</option>
                                    <option value="En Tratamiento">En Tratamiento</option>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Litros Diarios</label>
                                <input type="number" step="0.01" name="litrosDiarios" id="editLeche" class="form-control shadow-sm" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">N° de Partos</label>
                                <input type="number" name="numeroPartos" id="editPartos" class="form-control shadow-sm" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted fw-bold small text-uppercase ps-1">Precio Estimado ($)</label>
                                <input type="number" step="0.01" name="precioEstimado" id="editPrecio" class="form-control shadow-sm" required>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer border-0 pt-0 pb-4 px-4 d-flex justify-content-between">
                    <button type="button" class="btn btn-outline-success fw-bold px-4 rounded-pill shadow-sm" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-edit fw-bold px-5 rounded-pill shadow-sm"><i class="bi bi-arrow-repeat me-2"></i> Actualizar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.bootstrap5.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.print.min.js"></script>

<script>
    $(document).ready(function() {
        const dataTableConfig = {
            language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
            dom: '<"row align-items-center mb-3"<"col-md-6 text-start"B><"col-md-6 text-end"f>>rt<"row mt-3 align-items-center"<"col-md-6 text-start text-muted small"i><"col-md-6 d-flex justify-content-end"p>>',
            buttons: [
                {
                    extend: 'excelHtml5',
                    text: '<i class="bi bi-file-earmark-excel-fill"></i> Excel',
                    className: 'btn btn-outline-success btn-sm',
                    exportOptions: { columns: ':not(:last-child)' } 
                },
                {
                    extend: 'pdfHtml5',
                    text: '<i class="bi bi-file-earmark-pdf-fill"></i> PDF',
                    className: 'btn btn-outline-success btn-sm',
                    exportOptions: { 
                        columns: ':visible:not(:first-child):not(:last-child)' 
                    },
                    orientation: 'landscape',
                    pageSize: 'A4',
                    title: 'FINCA LA ROSA - INVENTARIO BOVINO',
                    customize: function(doc) {
                        // Color corporativo y alineación
                        doc.styles.title = {
                            color: '#464704',
                            fontSize: '20',
                            alignment: 'center',
                            bold: true,
                            margin: [0, 0, 0, 20]
                        };
                        doc.styles.tableHeader = {
                            fillColor: '#464704',
                            color: 'white',
                            alignment: 'center',
                            bold: true,
                            margin: [0, 5, 0, 5]
                        };
                        doc.defaultStyle.alignment = 'center';
                        
                        // Ajuste ancho de tabla
                        var objLayout = {};
                        objLayout.hLineWidth = function(i) { return 0.5; };
                        objLayout.vLineWidth = function(i) { return 0.5; };
                        objLayout.hLineColor = function(i) { return '#E2E4D5'; };
                        objLayout.vLineColor = function(i) { return '#E2E4D5'; };
                        doc.content[1].layout = objLayout;
                        
                        // Centrado automático de tabla
                        var colCount = doc.content[1].table.body[0].length;
                        doc.content[1].table.widths = Array(colCount).fill('*');
                    }
                }
            ],
            pageLength: 10
        };

        $('#tableTodos').DataTable(dataTableConfig);
        $('#tableProduccion').DataTable(dataTableConfig);
        $('#tableCrias').DataTable(dataTableConfig);
        $('#tableVentas').DataTable(dataTableConfig);
    });

    function setView(viewType) {
        if (viewType === 'list') {
            document.querySelectorAll('.view-list').forEach(el => el.classList.remove('d-none'));
            document.querySelectorAll('.view-grid').forEach(el => el.classList.add('d-none'));
            document.getElementById('btn-list').classList.add('active', 'bg-white');
            document.getElementById('btn-grid').classList.remove('active', 'bg-white');
        } else {
            document.querySelectorAll('.view-grid').forEach(el => el.classList.remove('d-none'));
            document.querySelectorAll('.view-list').forEach(el => el.classList.add('d-none'));
            document.getElementById('btn-grid').classList.add('active', 'bg-white');
            document.getElementById('btn-list').classList.remove('active', 'bg-white');
        }
        localStorage.setItem('vistaInventario', viewType);
    }

    document.addEventListener('DOMContentLoaded', () => {
        const vistaGuardada = localStorage.getItem('vistaInventario');
        if (vistaGuardada) setView(vistaGuardada);
    });

    function previewImage(input, previewElementId) {
        const preview = document.getElementById(previewElementId);
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.classList.remove('d-none');
            };
            reader.readAsDataURL(input.files[0]);
        } else {
            if(previewElementId === 'previewAdd') {
                preview.src = "";
                preview.classList.add('d-none');
            }
        }
    }

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
                saludBadge.className = "badge bg-success-subtle text-success fs-6 rounded-pill px-4 py-2 shadow-sm border border-dark";
            } else {
                saludBadge.className = "badge bg-danger-subtle text-danger fs-6 rounded-pill px-4 py-2 shadow-sm border border-dark";
            }
            
            let img = document.getElementById('resFoto');
            let placeholder = document.getElementById('resFotoPlaceholder');
            let contextPath = document.getElementById('appContextPath').value;
            
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
            
            let foto = this.dataset.foto;
            document.getElementById('editImageUrlOld').value = foto !== "null" ? foto : "";
            
            let editPreview = document.getElementById('previewEdit');
            let contextPath = document.getElementById('appContextPath').value;
            
            if(foto && foto !== "null" && foto.trim() !== "") {
                editPreview.src = contextPath + "/" + foto;
                editPreview.classList.remove('d-none');
            } else {
                editPreview.src = "";
                editPreview.classList.add('d-none');
            }
            
            actualizarCamposLogicosEdit();

            if (document.getElementById('esOperario').value === 'true') {
                document.querySelectorAll('#modalEditarBovino input, #modalEditarBovino select').forEach(el => {
                    if(el.id !== 'editSalud' && el.id !== 'editIdBovino' && el.name !== 'action' && el.type !== 'submit') {
                        el.setAttribute('readonly', 'true');
                        if(el.tagName === 'SELECT' || el.type === 'file') {
                            el.style.pointerEvents = 'none';
                            el.style.opacity = '0.6';
                        }
                    }
                });
            }
        });
    });

    function actualizarCamposLogicosAdd() {
        const isRecienNacido = document.getElementById('recienNacidaToggle').checked;
        const genero = document.getElementById('addGenero').value;
        const inputFecha = document.getElementById('addFechaNacimiento');
        const inputPartos = document.getElementById('addNumeroPartos');
        const inputLitros = document.getElementById('addLitrosDiarios');
        const selectProposito = document.getElementById('addProposito');
        const selectClasificacion = document.getElementById('addClasificacion');

        if (isRecienNacido) {
            inputFecha.value = new Date().toISOString().split('T')[0];
        } else if (inputFecha.value === new Date().toISOString().split('T')[0]) {
            inputFecha.value = "";
        }

        if (genero === 'Macho' || isRecienNacido) {
            inputPartos.value = 0; inputPartos.readOnly = true; inputPartos.style.backgroundColor = "var(--ivory)";
            inputLitros.value = 0; inputLitros.readOnly = true; inputLitros.style.backgroundColor = "var(--ivory)";
        } else {
            inputPartos.readOnly = false; inputPartos.style.backgroundColor = "";
            inputLitros.readOnly = false; inputLitros.style.backgroundColor = "";
        }

        if (genero === 'Macho') {
            Array.from(selectProposito.options).forEach(opt => { opt.disabled = (opt.value === 'Leche' || opt.value === 'Doble Propósito'); });
            selectProposito.value = 'Carne';
            Array.from(selectClasificacion.options).forEach(opt => { opt.disabled = (opt.value === 'Producción'); });
            if (isRecienNacido) selectClasificacion.value = 'Cría';
            else if (selectClasificacion.value === 'Producción') selectClasificacion.value = 'Venta';
        } else {
            Array.from(selectProposito.options).forEach(opt => { opt.disabled = false; });
            Array.from(selectClasificacion.options).forEach(opt => { opt.disabled = false; });
            if (isRecienNacido) selectClasificacion.value = 'Cría';
        }
    }

    function actualizarCamposLogicosEdit() {
        const genero = document.getElementById('editGenero').value;
        const inputPartos = document.getElementById('editPartos');
        const inputLitros = document.getElementById('editLeche');
        const selectProposito = document.getElementById('editProposito');
        const selectClasificacion = document.getElementById('editClasificacion');

        if (genero === 'Macho') {
            inputPartos.value = 0; inputPartos.readOnly = true; inputPartos.style.backgroundColor = "var(--ivory)";
            inputLitros.value = 0; inputLitros.readOnly = true; inputLitros.style.backgroundColor = "var(--ivory)";
            Array.from(selectProposito.options).forEach(opt => { opt.disabled = (opt.value === 'Leche' || opt.value === 'Doble Propósito'); });
            selectProposito.value = 'Carne';
            Array.from(selectClasificacion.options).forEach(opt => { opt.disabled = (opt.value === 'Producción'); });
            if (selectClasificacion.value === 'Producción') selectClasificacion.value = 'Venta';
        } else {
            inputPartos.readOnly = false; inputPartos.style.backgroundColor = "";
            inputLitros.readOnly = false; inputLitros.style.backgroundColor = "";
            Array.from(selectProposito.options).forEach(opt => { opt.disabled = false; });
            Array.from(selectClasificacion.options).forEach(opt => { opt.disabled = false; });
        }
    }

    function toggleAutoArete() {
        const toggle = document.getElementById('autoAreteToggle');
        const input = document.getElementById('inputAreteAdd');
        
        if (toggle.checked) {
            input.readOnly = true;
            input.style.backgroundColor = "var(--ivory)"; 
            
            const aretesData = document.getElementById('existingAretesData').value;
            const existingAretes = aretesData.split(',').filter(a => a !== '');
            
            let maxNum = 0;
            existingAretes.forEach(arete => {
                let match = arete.match(/\d+/); 
                if (match) {
                    let num = parseInt(match[0]);
                    if (num > maxNum) maxNum = num;
                }
            });

            let nextNum = maxNum + 1;
            input.value = "V-" + nextNum.toString().padStart(3, '0');
        } else {
            input.readOnly = false;
            input.style.backgroundColor = "";
            input.value = "";
        }
    }

    // Inicialización de DataTables para las vistas de Inventario
    $(document).ready(function() {
        const tableOptions = {
            language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
            dom: '<"d-flex flex-wrap gap-2 justify-content-between align-items-center mb-3"Bf>rt<"d-flex flex-wrap justify-content-between align-items-center mt-3"ip>',
            buttons: [
                { extend: 'excelHtml5', text: '<i class="bi bi-file-earmark-excel"></i> Excel', className: 'btn btn-success btn-sm shadow-sm rounded-pill px-3' },
                { extend: 'pdfHtml5', text: '<i class="bi bi-file-earmark-pdf"></i> PDF', className: 'btn btn-danger btn-sm shadow-sm rounded-pill px-3' }
            ],
            pageLength: 10,
            ordering: true,
            responsive: true
        };
        
        if (!$.fn.DataTable.isDataTable('#tableTodos')) $('#tableTodos').DataTable(tableOptions);
        if (!$.fn.DataTable.isDataTable('#tableProduccion')) $('#tableProduccion').DataTable(tableOptions);
        if (!$.fn.DataTable.isDataTable('#tableCrias')) $('#tableCrias').DataTable(tableOptions);
        if (!$.fn.DataTable.isDataTable('#tableVentas')) $('#tableVentas').DataTable(tableOptions);
    });
</script>
</body>
</html>