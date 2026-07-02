<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.Tarea" %>
<%@ page import="com.finca.models.Usuario" %>

<%
    Usuario usuarioActual = (Usuario) session.getAttribute("usuarioLogueado");
    
    // Verificamos si es Admin o Veterinario para darle permisos de asignar

    String r = usuarioActual.getRol() != null ? usuarioActual.getRol() : "3";
    boolean tienePermisos = r.equals("1") || r.equalsIgnoreCase("Administrador") || r.equals("2") || r.equalsIgnoreCase("Veterinario");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tablero de Tareas | Finca La Rosa</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            --bg-page: #F3F5E7 !important;
            --bg-card: #FFFFFF !important;
            --brand-primary: #464704 !important;
            --brand-accent: #B7A78C !important;
            --brand-info: #9CA889 !important;
            --text-main: #1d1d1f !important;
            --text-subtle: #86868b !important;
            --border-subtle: #d2d2d7 !important;
            --shadow-apple: 0 4px 6px rgba(0, 0, 0, 0.02), 0 10px 20px rgba(0, 0, 0, 0.04);
        }

        body { font-family: 'Inter', sans-serif; background-color: var(--bg-page) !important; color: var(--text-main); -webkit-font-smoothing: antialiased; }

        .kanban-board { display: flex; gap: 24px; overflow-x: auto; padding-bottom: 20px; align-items: flex-start; }
        .kanban-col { flex: 0 0 350px; background: rgba(255, 255, 255, 0.6); border: 1px solid var(--border-subtle); border-radius: 24px; padding: 20px; display: flex; flex-direction: column; min-height: 60vh; transition: background 0.3s; }
        .kanban-header { font-size: 0.9rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; color: var(--brand-primary); margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }

        .task-card { background: var(--bg-card); border-radius: 16px; padding: 18px; margin-bottom: 15px; box-shadow: var(--shadow-apple); border: 1px solid rgba(0,0,0,0.03); cursor: grab; transition: transform 0.2s ease; }
        .task-card:active { cursor: grabbing; transform: scale(0.98); }
        .task-card:hover { border-color: var(--brand-info); box-shadow: 0 8px 15px rgba(70, 71, 4, 0.08); }

        .task-title { font-size: 0.95rem; font-weight: 700; color: var(--text-main); margin-bottom: 8px; line-height: 1.3;}
        .task-desc { font-size: 0.8rem; color: var(--text-subtle); margin-bottom: 15px; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
        .task-footer { display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #f0f0f5; padding-top: 12px; }
        .task-date { font-size: 0.75rem; font-weight: 600; color: var(--brand-accent); }
        
        .task-assignee { display: flex; align-items: center; gap: 8px; }
        .assignee-avatar { width: 32px; height: 32px; border-radius: 50%; background: var(--brand-info); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 800; overflow: hidden; border: 2px solid #fff; }
        .assignee-avatar img { width: 100%; height: 100%; object-fit: cover; }
        
        .btn-delete-task { color: #dc3545; background: none; border: none; padding: 0; font-size: 1rem; opacity: 0; transition: 0.3s; }
        .task-card:hover .btn-delete-task { opacity: 1; }

        .btn-brand { background-color: var(--brand-primary) !important; color: #FFFFFF !important; font-weight: 600 !important; border-radius: 14px !important; border: none; padding: 10px 20px;}
        .btn-brand:hover { background-color: var(--text-main) !important; transform: scale(1.02); }

        .modal-content { border-radius: 28px; border: none; background: #f5f5f7; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25); }
        .form-control, .form-select { border-radius: 12px; background: #ffffff !important; border: 1px solid transparent !important; padding: 14px 16px; font-size: 0.95rem; font-weight: 500; }
        .form-control:focus, .form-select:focus { border-color: var(--brand-info) !important; box-shadow: 0 0 0 4px rgba(156, 168, 137, 0.2) !important; outline: none; }
        .form-label { font-size: 0.75rem; font-weight: 600; color: var(--text-subtle); text-transform: uppercase; margin-bottom: 6px; }

        .kanban-col.drag-over { background: rgba(156, 168, 137, 0.15); border: 2px dashed var(--brand-info); }
        
        div:where(.swal2-container) div:where(.swal2-popup) { border-radius: 24px; font-family: 'Inter', sans-serif; }

        @media (max-width: 768px) {
            .kanban-board {
                flex-direction: column;
                overflow-x: visible;
                gap: 20px;
            }
            .kanban-col {
                flex: 1 1 auto;
                width: 100%;
                min-height: 120px;
                margin-bottom: 15px;
            }
            .task-card {
                margin-bottom: 12px;
            }
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container-fluid py-4" style="max-width: 1400px;">
    
    <div class="d-flex justify-content-between align-items-center mb-5 mt-2 border-bottom pb-3" style="border-color: var(--border-subtle) !important;">
        <div>
            <h2 class="fw-bolder mb-1" style="color: var(--text-main); letter-spacing: -0.5px;">${tituloTablero}</h2>
            <span class="fw-medium" style="font-size: 0.95rem; color: var(--text-subtle);">${subTitulo}</span>
        </div>
        
        <% if(tienePermisos) { %>
        <button class="btn btn-brand shadow-sm" data-bs-toggle="modal" data-bs-target="#modalTarea">
            <i class="bi bi-plus-lg me-1"></i> Asignar Tarea
        </button>
        <% } %>
    </div>

    <% if(request.getAttribute("successMessage") != null) { %>
        <script> document.addEventListener("DOMContentLoaded", () => Swal.fire({ icon: 'success', title: 'Completado', text: '<%= request.getAttribute("successMessage") %>', confirmButtonColor: '#464704', timer: 3500, showConfirmButton: false })); </script>
    <% } %>

    <% if(request.getAttribute("errorMessage") != null) { %>
        <script> document.addEventListener("DOMContentLoaded", () => Swal.fire({ icon: 'error', title: 'Acceso Denegado', text: '<%= request.getAttribute("errorMessage") %>', confirmButtonColor: '#dc3545' })); </script>
    <% } %>

    <div class="kanban-board">
        
        <div class="kanban-col" id="col-Pendiente" ondrop="drop(event, 'Pendiente')" ondragover="allowDrop(event)" ondragleave="leaveDrop(event)">
            <div class="kanban-header">
                <span><i class="bi bi-circle me-2"></i> Pendientes</span>
            </div>
            <% 
                List<Tarea> tareas = (List<Tarea>) request.getAttribute("tareas");
                Boolean esAdmin = (Boolean) request.getAttribute("esAdmin");
                if (tareas != null) {
                    for (Tarea t : tareas) {
                        if ("Pendiente".equals(t.getEstado())) {
                            String inicial = (t.getAsignadoNombre() != null && !t.getAsignadoNombre().trim().isEmpty()) ? t.getAsignadoNombre().trim().substring(0,1).toUpperCase() : "U";
            %>
            <div class="task-card" draggable="true" ondragstart="drag(event)" id="task-<%= t.getIdTarea() %>">
                <div class="d-flex justify-content-between align-items-start">
                    <div class="task-title"><%= t.getTitulo() %></div>
                    <% if (tienePermisos) { %>
                    <form action="kanban" method="POST" class="d-inline" id="del-<%= t.getIdTarea() %>">
                        <input type="hidden" name="action" value="eliminar">
                        <input type="hidden" name="idTarea" value="<%= t.getIdTarea() %>">
                        <button type="button" class="btn-delete-task" title="Eliminar" onclick="borrarTarea('<%= t.getIdTarea() %>')"><i class="bi bi-x-circle-fill"></i></button>
                    </form>
                    <% } %>
                </div>
                <div class="task-desc"><%= t.getDescripcion() %></div>
                <div class="task-footer">
                    <div class="task-date"><i class="bi bi-calendar-event me-1"></i> <%= t.getFechaLimite() != null ? t.getFechaLimite() : "Sin fecha" %></div>
                    <div class="task-assignee" title="Asignado a: <%= t.getAsignadoNombre() != null ? t.getAsignadoNombre() : "Usuario" %>">
                        <div class="assignee-avatar">
                            <% if (t.getAsignadoFoto() != null && !t.getAsignadoFoto().isEmpty()) { %>
                                <img src="<%= request.getContextPath() %>/uploads/<%= t.getAsignadoFoto().replace("\\", "/") %>?t=<%= System.currentTimeMillis() %>" alt="A">
                            <% } else { %> <%= inicial %> <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <% } } } %>
        </div>

        <div class="kanban-col" id="col-En Progreso" ondrop="drop(event, 'En Progreso')" ondragover="allowDrop(event)" ondragleave="leaveDrop(event)">
            <div class="kanban-header">
                <span style="color: var(--brand-info);"><i class="bi bi-play-circle-fill me-2"></i> En Progreso</span>
            </div>
            <% 
                if (tareas != null) {
                    for (Tarea t : tareas) {
                        if ("En Progreso".equals(t.getEstado())) {
                            String inicial = (t.getAsignadoNombre() != null && !t.getAsignadoNombre().trim().isEmpty()) ? t.getAsignadoNombre().trim().substring(0,1).toUpperCase() : "U";
            %>
            <div class="task-card" draggable="true" ondragstart="drag(event)" id="task-<%= t.getIdTarea() %>" style="border-left: 3px solid var(--brand-info);">
                <div class="d-flex justify-content-between align-items-start">
                    <div class="task-title"><%= t.getTitulo() %></div>
                    <% if (tienePermisos) { %>
                    <form action="kanban" method="POST" class="d-inline" id="del-<%= t.getIdTarea() %>">
                        <input type="hidden" name="action" value="eliminar">
                        <input type="hidden" name="idTarea" value="<%= t.getIdTarea() %>">
                        <button type="button" class="btn-delete-task" title="Eliminar" onclick="borrarTarea('<%= t.getIdTarea() %>')"><i class="bi bi-x-circle-fill"></i></button>
                    </form>
                    <% } %>
                </div>
                <div class="task-desc"><%= t.getDescripcion() %></div>
                <div class="task-footer">
                    <div class="task-date"><i class="bi bi-calendar-event me-1"></i> <%= t.getFechaLimite() != null ? t.getFechaLimite() : "Sin fecha" %></div>
                    <div class="task-assignee" title="Asignado a: <%= t.getAsignadoNombre() != null ? t.getAsignadoNombre() : "Usuario" %>">
                        <div class="assignee-avatar">
                            <% if (t.getAsignadoFoto() != null && !t.getAsignadoFoto().isEmpty()) { %>
                                <img src="<%= request.getContextPath() %>/uploads/<%= t.getAsignadoFoto().replace("\\", "/") %>?t=<%= System.currentTimeMillis() %>" alt="A">
                            <% } else { %> <%= inicial %> <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <% } } } %>
        </div>

        <div class="kanban-col" id="col-Completada" ondrop="drop(event, 'Completada')" ondragover="allowDrop(event)" ondragleave="leaveDrop(event)">
            <div class="kanban-header">
                <span style="color: var(--text-subtle);"><i class="bi bi-check2-all me-2"></i> Completadas</span>
            </div>
            <% 
                if (tareas != null) {
                    for (Tarea t : tareas) {
                        if ("Completada".equals(t.getEstado())) {
                            String inicial = (t.getAsignadoNombre() != null && !t.getAsignadoNombre().trim().isEmpty()) ? t.getAsignadoNombre().trim().substring(0,1).toUpperCase() : "U";
            %>
            <div class="task-card" draggable="true" ondragstart="drag(event)" id="task-<%= t.getIdTarea() %>" style="opacity: 0.7; background: #fafafa;">
                <div class="d-flex justify-content-between align-items-start">
                    <div class="task-title text-decoration-line-through"><%= t.getTitulo() %></div>
                    <% if (tienePermisos) { %>
                    <form action="kanban" method="POST" class="d-inline" id="del-<%= t.getIdTarea() %>">
                        <input type="hidden" name="action" value="eliminar">
                        <input type="hidden" name="idTarea" value="<%= t.getIdTarea() %>">
                        <button type="button" class="btn-delete-task" title="Eliminar" onclick="borrarTarea('<%= t.getIdTarea() %>')"><i class="bi bi-x-circle-fill"></i></button>
                    </form>
                    <% } %>
                </div>
                <div class="task-footer border-0 pt-2">
                    <div class="task-date" style="color: var(--text-subtle);"><i class="bi bi-check-lg"></i> Terminada</div>
                    <div class="task-assignee" title="Asignado a: <%= t.getAsignadoNombre() != null ? t.getAsignadoNombre() : "Usuario" %>">
                        <div class="assignee-avatar" style="filter: grayscale(100%); border-color: #d1d5cb;">
                            <% if (t.getAsignadoFoto() != null && !t.getAsignadoFoto().isEmpty()) { %>
                                <img src="<%= request.getContextPath() %>/uploads/<%= t.getAsignadoFoto().replace("\\", "/") %>?t=<%= System.currentTimeMillis() %>" alt="A">
                            <% } else { %> <%= inicial %> <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <% } } } %>
        </div>
    </div>
</div>

<% if (tienePermisos) { %>
<div class="modal fade" id="modalTarea" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header border-0 pb-0 pt-4 px-4">
                <h4 class="modal-title fw-bolder" style="color: var(--text-main);">Asignar Nueva Tarea</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="kanban" method="POST">
                <input type="hidden" name="action" value="crear">
                <div class="modal-body px-4">
                    
                    <div class="mb-3">
                        <label class="form-label">¿Qué hay que hacer?</label>
                        <input type="text" name="titulo" class="form-control" placeholder="Ej: Limpiar el tanque de frío" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Instrucciones</label>
                        <textarea name="descripcion" class="form-control" rows="3" placeholder="Detalles de la tarea..." required></textarea>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Asignar a:</label>
                            <select name="asignadoA" class="form-select" required>
                                <option value="" disabled selected>Seleccione...</option>
                                <% 
                                    List<Usuario> empleados = (List<Usuario>) request.getAttribute("empleados");
                                    if(empleados != null) {
                                        for(Usuario e : empleados) {
                                %>
                                <option value="<%= e.getId() %>"><%= e.getFullName() %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Fecha Límite</label>
                            <input type="date" name="fechaLimite" class="form-control" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 px-4 pb-4 pt-2">
                    <button type="button" class="btn" data-bs-dismiss="modal" style="color: var(--text-subtle); font-weight: 600;">Cancelar</button>
                    <button type="submit" class="btn btn-brand shadow-sm">Delegar Tarea</button>
                </div>
            </form>
        </div>
    </div>
</div>
<% } %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mobile-drag-drop@2.3.0-rc.2/default.css">
<script src="https://cdn.jsdelivr.net/npm/mobile-drag-drop@2.3.0-rc.2/index.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/mobile-drag-drop@2.3.0-rc.2/scroll-behaviour.min.js"></script>
<script>
    // Iniciar polyfill para celulares
    MobileDragDrop.polyfill({
        dragImageTranslateOverride: MobileDragDrop.scrollBehaviourDragImageTranslateOverride
    });
    // Necesario para iOS
    window.addEventListener('touchmove', function() {}, {passive: false});
</script>

<script>
    // LÓGICA DE DRAG & DROP
    function allowDrop(ev) { ev.preventDefault(); ev.currentTarget.classList.add('drag-over'); }
    function leaveDrop(ev) { ev.currentTarget.classList.remove('drag-over'); }
    function drag(ev) { 
        ev.dataTransfer.setData("idTareaNode", ev.target.id); 
        // Hack para el polyfill
        ev.dataTransfer.dropEffect = "move"; 
    }

    function drop(ev, nuevoEstado) {
        ev.preventDefault();
        const col = ev.currentTarget;
        col.classList.remove('drag-over');
        
        let idNode = ev.dataTransfer.getData("idTareaNode"); 
        let card = document.getElementById(idNode);
        
        // Mover visualmente
        col.appendChild(card);

        // Cambios visuales dependiendo de la columna
        if(nuevoEstado === 'Completada') {
            card.style.opacity = '0.7'; card.style.background = '#fafafa'; card.style.borderLeft = 'none';
            card.querySelector('.task-title').classList.add('text-decoration-line-through');
        } else if(nuevoEstado === 'En Progreso') {
            card.style.opacity = '1'; card.style.background = '#FFFFFF'; card.style.borderLeft = '3px solid #9CA889';
            card.querySelector('.task-title').classList.remove('text-decoration-line-through');
        } else {
            card.style.opacity = '1'; card.style.background = '#FFFFFF'; card.style.borderLeft = 'none';
            card.querySelector('.task-title').classList.remove('text-decoration-line-through');
        }

        let idReal = idNode.split('-')[1];

        // Guardar en Java (Base de datos) por debajo
        let formData = new URLSearchParams();
        formData.append("action", "mover");
        formData.append("idTarea", idReal);
        formData.append("estado", nuevoEstado);

        fetch('kanban', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: formData.toString() });
    }

    function borrarTarea(id) {
        Swal.fire({
            title: '¿Eliminar Tarea?', text: "Esta acción no se puede deshacer.", icon: 'warning',
            showCancelButton: true, confirmButtonColor: '#dc3545', cancelButtonColor: '#d2d2d7', confirmButtonText: 'Sí, borrar'
        }).then((result) => {
            if (result.isConfirmed) { document.getElementById('del-' + id).submit(); }
        });
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>