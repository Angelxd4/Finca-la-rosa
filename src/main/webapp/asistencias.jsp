<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.Asistencia" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Asistencias | Finca La Rosa</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
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
            --brand-dark: #423926 !important;    
            
            --text-main: #1d1d1f !important;
            --text-subtle: #86868b !important;
            --border-subtle: #d2d2d7 !important;
            
            --shadow-apple: 0 4px 6px rgba(0, 0, 0, 0.02), 0 10px 20px rgba(0, 0, 0, 0.04);
            --shadow-hover: 0 8px 12px rgba(0, 0, 0, 0.04), 0 20px 30px rgba(70, 71, 4, 0.08);
        }

        body { 
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; 
            background-color: var(--bg-page) !important; 
            color: var(--text-main); 
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
        }
        
        .module-container { background: transparent; padding: 0; border: none; }

        /* ================= TABLA ESTILO TARJETAS FLOTANTES ================= */
        .table { border-collapse: separate; border-spacing: 0 12px; margin-top: -12px; }
        .table th { background-color: transparent !important; color: var(--text-subtle) !important; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 1px; padding: 0 20px 8px 20px; border: none !important; }
        .table tbody tr { background-color: var(--bg-card); box-shadow: var(--shadow-apple); border-radius: 20px; transition: all 0.3s ease; }
        .table tbody tr:hover { transform: translateY(-3px); box-shadow: var(--shadow-hover); }
        .table td { vertical-align: middle; padding: 20px; color: var(--text-main); font-weight: 500; border: none; }
        .table td:first-child { border-top-left-radius: 20px; border-bottom-left-radius: 20px; }
        .table td:last-child { border-top-right-radius: 20px; border-bottom-right-radius: 20px; }

        .badge-custom { padding: 6px 14px; border-radius: 12px; font-weight: 600; font-size: 0.8rem; letter-spacing: 0.3px; }
        .badge-role-admin { background-color: rgba(183, 167, 140, 0.2); color: var(--brand-dark); }
        .badge-role-vet { background-color: rgba(156, 168, 137, 0.2); color: var(--brand-primary); }
        .badge-role-op { background-color: #f5f5f7; color: var(--text-subtle); border: 1px solid var(--border-subtle); }

        .badge-status-atiempo { background-color: rgba(156, 168, 137, 0.2); color: var(--brand-primary); }
        .badge-status-tarde { background-color: rgba(220, 53, 69, 0.1); color: #dc3545; }

        .action-btn { transition: all 0.2s ease; border-radius: 10px; width: 36px; height: 36px; display: inline-flex; align-items: center; justify-content: center; background: transparent; border: none; color: var(--text-subtle); text-decoration: none; }
        .btn-pdf:hover { background-color: rgba(156, 168, 137, 0.15); color: var(--brand-primary); }

        /* Header Layout */
        .page-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 30px; }
        .page-title { font-weight: 800; font-size: 2.2rem; letter-spacing: -0.5px; color: var(--brand-dark); margin: 0; line-height: 1.2;}
        .page-subtitle { color: var(--text-subtle); font-weight: 500; font-size: 1.05rem; margin-top: 5px; }

        @media (max-width: 768px) {
            .page-header { flex-direction: column; align-items: flex-start; gap: 15px; }
            .table-responsive { border-radius: 20px; box-shadow: var(--shadow-apple); background: var(--bg-card); padding: 10px; }
            .table th { display: none; }
            .table tbody tr { display: block; margin-bottom: 15px; border-radius: 15px; padding: 10px; }
            .table td { display: block; padding: 10px 15px; text-align: right; border-bottom: 1px solid #f5f5f7; }
            .table td:last-child { border-bottom: none; }
            .table td::before { content: attr(data-label); float: left; font-weight: 600; color: var(--text-subtle); font-size: 0.8rem; text-transform: uppercase; }
        }
    </style>
</head>
<body>

    <!-- Incluir el Navbar -->
    <jsp:include page="navbar.jsp" />

    <div class="container py-4">
        
        <!-- Alertas de Éxito y Error -->
        <% if (request.getAttribute("successMessage") != null) { %>
            <script>
                Swal.fire({
                    icon: 'success',
                    title: '¡Éxito!',
                    text: '<%= request.getAttribute("successMessage") %>',
                    confirmButtonColor: '#464704',
                    background: '#ffffff',
                    customClass: { popup: 'rounded-4' }
                });
            </script>
        <% } %>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <script>
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: '<%= request.getAttribute("errorMessage") %>',
                    confirmButtonColor: '#dc3545',
                    background: '#ffffff',
                    customClass: { popup: 'rounded-4' }
                });
            </script>
        <% } %>

        <div class="page-header">
            <div>
                <h1 class="page-title">Historial de Asistencias</h1>
                <div class="page-subtitle">Registro de entradas y salidas del personal</div>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table align-middle">
                <thead>
                    <tr>
                        <th class="ps-4">Empleado</th>
                        <th>Rol</th>
                        <th>Fecha</th>
                        <th>Entrada</th>
                        <th>Salida</th>
                        <th>Estado</th>
                        <th class="text-end pe-4">Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Asistencia> historial = (List<Asistencia>) request.getAttribute("historialAsistencias");
                        if (historial != null && !historial.isEmpty()) {
                            for (Asistencia a : historial) {
                                String rolClase = "badge-role-op";
                                String rolTexto = a.getRolUsuario();
                                if ("1".equals(a.getRolUsuario()) || "Administrador".equalsIgnoreCase(a.getRolUsuario())) { rolClase = "badge-role-admin"; rolTexto = "Administrador"; }
                                else if ("2".equals(a.getRolUsuario()) || "Veterinario".equalsIgnoreCase(a.getRolUsuario())) { rolClase = "badge-role-vet"; rolTexto = "Veterinario"; }
                                else if ("3".equals(a.getRolUsuario()) || "Operario".equalsIgnoreCase(a.getRolUsuario())) { rolTexto = "Operario"; }
                                
                                String estado = a.getEstadoAsistencia() != null ? a.getEstadoAsistencia() : "A Tiempo";
                                String estadoClase = estado.equalsIgnoreCase("A Tiempo") ? "badge-status-atiempo" : "badge-status-tarde";
                    %>
                    <tr>
                        <td data-label="Empleado" class="ps-4">
                            <div class="d-flex align-items-center gap-3">
                                <% if (a.getProfilePicture() != null && !a.getProfilePicture().isEmpty()) { %>
                                    <img src="uploads/<%= a.getProfilePicture() %>" alt="Foto" class="rounded-circle shadow-sm" style="width: 42px; height: 42px; object-fit: cover;">
                                <% } else { %>
                                    <div class="avatar-circle shadow-sm" style="width: 42px; height: 42px; font-size: 1rem;">
                                        <%= a.getNombreUsuario().substring(0, 1).toUpperCase() %>
                                    </div>
                                <% } %>
                                <div>
                                    <div class="fw-bold text-dark"><%= a.getNombreUsuario() %></div>
                                    <div class="small text-subtle">C.C. <%= a.getDocumentoUsuario() %></div>
                                </div>
                            </div>
                        </td>
                        <td data-label="Rol"><span class="badge badge-custom <%= rolClase %>"><%= rolTexto %></span></td>
                        <td data-label="Fecha" class="fw-medium"><i class="bi bi-calendar3 text-subtle me-1"></i> <%= a.getFecha() %></td>
                        <td data-label="Entrada" class="fw-medium text-success"><i class="bi bi-box-arrow-in-right me-1"></i> <%= a.getHoraEntrada() != null ? new java.text.SimpleDateFormat("hh:mm a").format(a.getHoraEntrada()) : "--:-- --" %></td>
                        <td data-label="Salida" class="fw-medium text-danger"><i class="bi bi-box-arrow-right me-1"></i> <%= a.getHoraSalida() != null ? new java.text.SimpleDateFormat("hh:mm a").format(a.getHoraSalida()) : "--:-- --" %></td>
                        <td data-label="Estado"><span class="badge badge-custom <%= estadoClase %>"><%= estado %></span></td>
                        
                        <td data-label="Comprobante" class="text-end pe-4">
                            <a href="asistencias?action=pdf&id=<%= a.getIdAsistencia() %>" class="action-btn btn-pdf" title="Descargar PDF">
                                <i class="bi bi-file-earmark-pdf-fill fs-5"></i>
                            </a>
                        </td>
                    </tr>
                    <% 
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="7" class="text-center py-5">
                            <i class="bi bi-inbox fs-1 text-subtle d-block mb-3"></i>
                            <span class="text-subtle fw-medium">No hay registros de asistencia disponibles.</span>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
