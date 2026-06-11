<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Empleados | Finca La Rosa</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            /* PALETA FINCA LA ROSA (DARK MOSS GREEN & EARTH TONES) */
            --bg-page: #F3F5E7 !important;       /* IVORY */
            --bg-card: #FFFFFF !important;
            
            --brand-primary: #464704 !important; /* DARK MOSS GREEN */
            --brand-accent: #B7A78C !important;  /* KHAKI */
            --brand-info: #9CA889 !important;    /* SAGE */
            --brand-dark: #423926 !important;    /* DRAB DARK BROWN */
            
            --text-main: #423926 !important;
            --text-subtle: #7A7463 !important;
            --border-subtle: #E2E4D5 !important;
            
            --shadow-finca: 0 10px 25px rgba(66, 57, 38, 0.05);
        }

        body { 
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; 
            background-color: var(--bg-page) !important; 
            color: var(--text-main); 
            min-height: 100vh;
        }
        
        .module-container { 
            background: var(--bg-card); 
            border-radius: 24px; 
            padding: 24px; 
            box-shadow: var(--shadow-finca); 
            border: 1px solid var(--border-subtle); 
        }

        /* TABLAS MODERNAS */
        .table { margin-bottom: 0; }
        .table th { 
            background-color: var(--bg-page) !important; 
            color: var(--brand-primary) !important; 
            font-weight: 800; 
            text-transform: uppercase; 
            font-size: 0.75rem; 
            letter-spacing: 1px; 
            padding: 18px 15px; 
            border-bottom: 2px solid var(--brand-accent) !important; 
        }
        .table td { 
            vertical-align: middle; 
            padding: 16px 15px; 
            color: var(--text-main); 
            font-weight: 500; 
            border-bottom: 1px solid var(--border-subtle); 
        }
        .table-hover tbody tr:hover td { background-color: var(--bg-page); }

        /* AVATAR Y ROLES */
        .avatar-circle {
            width: 45px; height: 45px;
            background-color: var(--brand-info);
            color: white;
            font-weight: 800; font-size: 1.2rem;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 4px 10px rgba(156, 168, 137, 0.3);
        }
        
        .badge-role-admin { background-color: var(--brand-accent); color: var(--brand-dark); font-weight: 800; padding: 6px 12px; border-radius: 8px; }
        .badge-role-vet { background-color: var(--brand-info); color: white; font-weight: 800; padding: 6px 12px; border-radius: 8px; }
        .badge-role-op { background-color: var(--bg-page); color: var(--brand-dark); font-weight: 700; padding: 6px 12px; border-radius: 8px; border: 1px solid var(--border-subtle); }

        /* BOTONES DE ACCIÓN (Íconos) */
        .action-btn { transition: all 0.3s ease; border-radius: 12px; width: 36px; height: 36px; display: inline-flex; align-items: center; justify-content: center; padding: 0; border: none; }
        .action-btn i { font-size: 1rem; margin: 0; padding: 0; line-height: 1; }
        .btn-edit { background-color: var(--bg-page); color: var(--brand-primary); border: 1px solid var(--brand-primary); }
        .btn-edit:hover { background-color: var(--brand-primary); color: white; transform: translateY(-3px); box-shadow: 0 6px 12px rgba(70, 71, 4, 0.2); }
        .btn-delete { background-color: #fff0f0; color: #dc3545; border: 1px solid #ffcaca; }
        .btn-delete:hover { background-color: #dc3545; color: white; transform: translateY(-3px); box-shadow: 0 6px 12px rgba(220, 53, 69, 0.2); }

        /* BOTONES PRINCIPALES */
        .btn-brand { background-color: var(--brand-primary) !important; color: #FFFFFF !important; font-weight: 700 !important; border-radius: 12px !important; transition: all 0.2s ease; border: none;}
        .btn-brand:hover { background-color: var(--brand-dark) !important; transform: translateY(-2px); box-shadow: 0 8px 15px rgba(66, 57, 38, 0.2); }

        /* MODALES */
        .modal-content { border-radius: 28px; border: none; background: var(--bg-card); box-shadow: 0 25px 50px -12px rgba(66, 57, 38, 0.25); }
        .modal-header, .modal-footer { border: none !important; }
        .form-control, .form-select { border-radius: 14px; background: var(--bg-page) !important; border: 1px solid var(--border-subtle) !important; color: var(--text-main) !important; padding: 12px 15px; transition: all 0.3s ease; font-weight: 600;}
        .form-control:focus, .form-select:focus { background: #ffffff !important; border-color: var(--brand-primary) !important; box-shadow: 0 0 0 4px rgba(70, 71, 4, 0.15) !important; outline: none; }
        
        /* SWEET ALERT */
        div:where(.swal2-container) div:where(.swal2-popup) { border-radius: 24px; font-family: 'Inter', sans-serif; }
        div:where(.swal2-container) button:where(.swal2-styled) { border-radius: 12px; font-weight: 600; padding: 10px 24px; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container py-4">
    
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom" style="border-color: var(--border-subtle) !important;">
        <div>
            <h3 class="fw-bolder mb-0" style="color: var(--brand-dark);"><i class="bi bi-people-fill me-2" style="color: var(--brand-primary);"></i> Directorio de Personal</h3>
            <span class="fw-bold" style="font-size: 0.9rem; color: var(--text-subtle);">Administra los accesos y roles de la finca</span>
        </div>
        <button class="btn btn-brand px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalAddEmpleado">
            <i class="bi bi-person-plus-fill me-2"></i> Añadir Empleado
        </button>
    </div>

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

    <div class="module-container table-responsive">
        <table class="table table-hover align-middle">
            <thead class="text-center">
                <tr>
                    <th class="text-start">Empleado</th>
                    <th>Documento</th>
                    <th>Rol Asignado</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody class="text-center">
                <% 
                    List<Usuario> lista = (List<Usuario>) request.getAttribute("empleados");
                    if(lista != null && !lista.isEmpty()) {
                        for(Usuario u : lista) {
                            String r = u.getRol() != null ? u.getRol() : "";
                            String rolTexto = "Desconocido";
                            String badgeClass = "badge-role-op";
                            
                            if(r.equals("1") || r.equalsIgnoreCase("Administrador")) { rolTexto = "👑 Administrador"; badgeClass = "badge-role-admin"; }
                            else if(r.equals("2") || r.equalsIgnoreCase("Veterinario")) { rolTexto = "🩺 Veterinario"; badgeClass = "badge-role-vet"; }
                            else if(r.equals("3") || r.equalsIgnoreCase("Operario")) { rolTexto = "🚜 Operario / Vaquero"; badgeClass = "badge-role-op"; }
                            else if(r.equals("4") || r.equalsIgnoreCase("Vendedor")) { rolTexto = "💼 Vendedor"; badgeClass = "badge-role-op"; }
                            else if(r.equals("5") || r.equalsIgnoreCase("Cliente")) { rolTexto = "🛒 Cliente"; badgeClass = "badge-role-op"; }
                            else { rolTexto = r; badgeClass = "badge-role-op"; }
                            
                            String inicial = u.getFullName().substring(0, 1).toUpperCase();
                %>
                <tr>
                    <td class="text-start">
                        <div class="d-flex align-items-center gap-3">
                            <div class="avatar-circle"><%= inicial %></div>
                            <div>
                                <strong class="d-block" style="color: var(--brand-dark); font-size: 1.05rem;"><%= u.getFullName() %></strong>
                                <small style="color: var(--text-subtle); font-weight: 600;"><i class="bi bi-envelope-fill me-1"></i><%= u.getEmail() %></small>
                            </div>
                        </div>
                    </td>
                    <td class="fw-bold" style="color: var(--brand-dark);"><%= u.getDocumentId() %></td>
                    <td><span class="<%= badgeClass %> shadow-sm"><%= rolTexto %></span></td>
                    <td>
                        <div class="d-flex gap-2 justify-content-center">
                            <button type="button" class="action-btn btn-edit" title="Editar" 
                                onclick="abrirModalEditar('<%= u.getId() %>', '<%= u.getFullName() %>', '<%= u.getDocumentId() %>', '<%= u.getEmail() %>', '<%= r %>')">
                                <i class="bi bi-pencil-fill"></i>
                            </button>
                            
                            <form action="empleados" method="POST" class="d-inline" id="formDelete_<%= u.getId() %>">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= u.getId() %>">
                                <button type="button" class="action-btn btn-delete" title="Retirar" onclick="confirmarEliminacion('<%= u.getId() %>', '<%= u.getFullName() %>')">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </form>
                        </div>
                    </td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr><td colspan="4" class="text-center py-5"><i class="bi bi-person-x fs-1 d-block mb-3" style="color: var(--brand-accent);"></i><span class="fw-bold text-muted">No hay personal registrado en el sistema.</span></td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="modalAddEmpleado" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header pb-2 px-4 mt-2 border-bottom" style="border-color: var(--border-subtle) !important;">
                <h4 class="modal-title fw-bolder" style="color: var(--brand-primary);"><i class="bi bi-person-plus-fill me-2"></i> Alta de Personal</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="empleados" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-body px-4 py-4">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Nombre Completo</label>
                        <input type="text" name="fullName" class="form-control" placeholder="Ej: Juan Pérez" required>
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Documento</label>
                            <input type="text" name="documentId" class="form-control" placeholder="Cédula" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Rol en Finca</label>
                            <select name="rol" class="form-select" required>
                                <option value="1">Administrador</option>
                                <option value="2">Veterinario</option>
                                <option value="3" selected>Operario (Vaquero)</option>
                                <option value="4">Vendedor</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Correo Electrónico (Login)</label>
                        <input type="email" name="email" class="form-control" placeholder="juan@fincalarosa.com" required>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Contraseña Inicial</label>
                        <input type="text" name="password" class="form-control fw-bold" style="color: var(--brand-primary) !important;" value="12345" required>
                    </div>
                </div>
                <div class="modal-footer px-4 pb-4">
                    <button type="button" class="btn fw-bold px-4" data-bs-dismiss="modal" style="color: var(--text-subtle);">Cancelar</button>
                    <button type="submit" class="btn btn-brand px-5 shadow-sm"><i class="bi bi-save-fill me-2"></i> Guardar Empleado</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="modalEditEmpleado" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header pb-2 px-4 mt-2 border-bottom" style="border-color: var(--border-subtle) !important;">
                <h4 class="modal-title fw-bolder" style="color: var(--brand-primary);"><i class="bi bi-pencil-square me-2"></i> Editar Personal</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="empleados" method="POST">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" id="editId">
                <div class="modal-body px-4 py-4">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Nombre Completo</label>
                        <input type="text" name="fullName" id="editFullName" class="form-control" required>
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Documento</label>
                            <input type="text" name="documentId" id="editDocument" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Rol en Finca</label>
                            <select name="rol" id="editRol" class="form-select" required>
                                <option value="1">Administrador</option>
                                <option value="2">Veterinario</option>
                                <option value="3">Operario (Vaquero)</option>
                                <option value="4">Vendedor</option>
                                <option value="5">Cliente</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-bold text-uppercase ms-1" style="color: var(--brand-dark);">Correo Electrónico (Login)</label>
                        <input type="email" name="email" id="editEmail" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer px-4 pb-4">
                    <button type="button" class="btn fw-bold px-4" data-bs-dismiss="modal" style="color: var(--text-subtle);">Cancelar</button>
                    <button type="submit" class="btn btn-brand px-5 shadow-sm"><i class="bi bi-arrow-repeat me-2"></i> Actualizar Datos</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Llenar Modal de Edición
    function abrirModalEditar(id, nombre, doc, email, rol) {
        document.getElementById('editId').value = id;
        document.getElementById('editFullName').value = nombre;
        document.getElementById('editDocument').value = doc;
        document.getElementById('editEmail').value = email;
        
        // Ajustar el select según el valor recibido (Soporta número o texto)
        let select = document.getElementById('editRol');
        let optionValues = { "1": "1", "Administrador": "1", "2": "2", "Veterinario": "2", "3": "3", "Operario": "3", "4": "4", "Vendedor": "4", "5": "5", "Cliente": "5" };
        select.value = optionValues[rol] || "3";
        
        var modal = new bootstrap.Modal(document.getElementById('modalEditEmpleado'));
        modal.show();
    }

    // Alerta de Eliminación
    function confirmarEliminacion(idForm, nombre) {
        Swal.fire({
            title: '¿Retirar Empleado?',
            html: `Estás a punto de dar de baja a <b>${nombre}</b> del sistema. No podrá iniciar sesión nuevamente.`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#B7A78C',
            confirmButtonText: 'Sí, Retirar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('formDelete_' + idForm).submit();
            }
        });
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>