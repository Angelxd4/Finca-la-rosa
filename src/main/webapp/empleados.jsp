<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Directorio de Personal | Finca La Rosa</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

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

        .avatar-circle {
            width: 48px; height: 48px; background-color: var(--brand-info); color: white;
            font-weight: 700; font-size: 1.1rem; border-radius: 50%; display: flex; align-items: center; justify-content: center; overflow: hidden; border: 2px solid #F3F5E7;
        }
        .avatar-circle img { width: 100%; height: 100%; object-fit: cover; }
        
        .badge-custom { padding: 6px 14px; border-radius: 12px; font-weight: 600; font-size: 0.8rem; letter-spacing: 0.3px; }
        .badge-role-admin { background-color: rgba(183, 167, 140, 0.2); color: var(--brand-dark); }
        .badge-role-vet { background-color: rgba(156, 168, 137, 0.2); color: var(--brand-primary); }
        .badge-role-op { background-color: #f5f5f7; color: var(--text-subtle); border: 1px solid var(--border-subtle); }
        
        html[data-theme="dark"] .badge-role-admin { background-color: rgba(183, 167, 140, 0.15) !important; color: #E0E0E0 !important; }
        html[data-theme="dark"] .badge-role-vet { background-color: rgba(156, 168, 137, 0.15) !important; color: #E0E0E0 !important; }
        html[data-theme="dark"] .badge-role-op { background-color: #2a2a2a !important; color: #E0E0E0 !important; border-color: #444 !important; }

        /* Botones de Acción Mínimos */
        .action-btn { transition: all 0.2s ease; border-radius: 10px; width: 36px; height: 36px; display: inline-flex; align-items: center; justify-content: center; background: transparent; border: none; color: var(--text-subtle); }
        .btn-view:hover { background-color: rgba(156, 168, 137, 0.15); color: var(--brand-primary); }
        .btn-edit:hover { background-color: rgba(183, 167, 140, 0.2); color: var(--brand-dark); }
        .btn-delete:hover { background-color: #fff0f0; color: #dc3545; }
        .btn-qr:hover { background-color: rgba(70, 71, 4, 0.15); color: var(--brand-primary); }

        .btn-brand { background-color: var(--brand-primary) !important; color: #FFFFFF !important; font-weight: 600 !important; border-radius: 14px !important; border: none; padding: 12px 24px; font-size: 0.95rem; letter-spacing: 0.5px;}
        .btn-brand:hover { background-color: var(--brand-dark) !important; transform: scale(1.02); }

        /* ================= MODALES ESTILO APPLE ================= */
        .modal-content { border-radius: 32px; border: none; background: #f5f5f7; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25); }
        .modal-header { border-bottom: none !important; padding: 30px 40px 10px 40px; }
        .modal-body { padding: 10px 40px 30px 40px; }
        .modal-footer { border-top: none !important; padding: 20px 40px 30px 40px; background: transparent; }
        
        .form-section { background: var(--bg-card); border-radius: 20px; padding: 25px; margin-bottom: 20px; box-shadow: var(--shadow-apple); }

        .form-control, .form-select { 
            border-radius: 12px; background: #f5f5f7 !important; border: 1px solid transparent !important; 
            color: var(--text-main) !important; padding: 14px 16px; font-size: 0.95rem; font-weight: 500; transition: all 0.3s ease; 
        }
        .form-control:focus, .form-select:focus { background: #ffffff !important; border-color: var(--brand-info) !important; box-shadow: 0 0 0 4px rgba(156, 168, 137, 0.2) !important; outline: none; }
        .form-control:read-only { opacity: 0.7; cursor: not-allowed; }
        .form-label { font-size: 0.75rem; font-weight: 600; color: var(--text-subtle); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px; margin-left: 4px;}

        /* Previsualización de Imagen */
        .preview-wrapper { text-align: center; margin-bottom: 25px; }
        .preview-circle { 
            width: 110px; height: 110px; border-radius: 50%; background: #f5f5f7; margin: 0 auto 15px auto; 
            overflow: hidden; border: 3px solid var(--bg-card); box-shadow: var(--shadow-apple);
            display: flex; align-items: center; justify-content: center; color: var(--text-subtle); font-size: 2rem;
        }
        .preview-circle img { width: 100%; height: 100%; object-fit: cover; }

        .file-upload-wrapper { position: relative; display: inline-block; }
        .file-upload-wrapper input[type=file] { position: absolute; left: 0; top: 0; opacity: 0; cursor: pointer; height: 100%; width: 100%; }
        .btn-upload { background: rgba(156, 168, 137, 0.15); color: var(--brand-primary); border-radius: 50px; padding: 8px 20px; font-weight: 600; font-size: 0.85rem; transition: 0.3s; cursor: pointer; }
        .file-upload-wrapper:hover .btn-upload { background: rgba(156, 168, 137, 0.25); }

        /* ================= MODAL "VER FICHA" ================= */
        .profile-view-header { d-flex: flex; flex-direction: column; align-items: center; text-align: center; padding: 20px 0 10px 0; }
        .profile-view-avatar { width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 4px solid #fff; box-shadow: var(--shadow-apple); margin-bottom: 15px; background: var(--brand-info); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 2.5rem; font-weight: bold; }
        .profile-view-name { font-size: 1.4rem; font-weight: 800; color: var(--text-main); margin-bottom: 4px; letter-spacing: -0.5px; }
        .profile-view-role { font-size: 0.9rem; font-weight: 600; color: var(--brand-info); text-transform: uppercase; letter-spacing: 1px; }
        
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .info-item { background: #f9f9fb; padding: 15px 20px; border-radius: 16px; border: 1px solid rgba(0,0,0,0.02); }
        html[data-theme="dark"] .info-item { background-color: #1e1e1e !important; border-color: #333 !important; }
        .info-label { font-size: 0.75rem; color: var(--text-subtle); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px; display: block; }
        .info-value { font-size: 0.95rem; color: var(--text-main); font-weight: 600; word-break: break-word; }
        
        .info-item-full { grid-column: span 2; }

        div:where(.swal2-container) div:where(.swal2-popup) { border-radius: 28px; box-shadow: var(--shadow-hover) !important;}
        div:where(.swal2-container) button:where(.swal2-styled) { border-radius: 12px; font-weight: 600; }
        
        /* Ajuste para el contenedor del QR interno */
        #qrContenedor img { margin: 0 auto; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container py-4">
    
    <div class="d-flex justify-content-between align-items-center mb-5 mt-2">
        <div>
            <h2 class="fw-bolder mb-1" style="color: var(--text-main); letter-spacing: -0.5px;">Recursos Humanos</h2>
            <span class="fw-medium" style="font-size: 0.95rem; color: var(--text-subtle);">Directorio y fichas técnicas del personal</span>
        </div>
        <button class="btn btn-brand shadow-sm" data-bs-toggle="modal" data-bs-target="#modalAddEmpleado">
            <i class="bi bi-plus-lg me-1"></i> Alta de Personal
        </button>
    </div>

    <div class="module-container table-responsive">
        <table id="tablaEmpleados" class="table table-hover align-middle">
            <thead class="text-center">
                <tr>
                    <th class="text-start">Empleado</th>
                    <th>Documento</th>
                    <th>Cargo</th>
                    <th>Acceso / Estado</th>
                    <th>Opciones</th>
                </tr>
            </thead>
            <tbody class="text-center">
                <% 
                    List<Usuario> lista = (List<Usuario>) request.getAttribute("empleados");
                    if(lista != null && !lista.isEmpty()) {
                        for(Usuario u : lista) {
                            String r = u.getRol() != null ? u.getRol() : "";
                            String rolTexto = "Desconocido";
                            String badgeClass = "badge-role-op badge-custom";
                            
                            if(r.equals("1") || r.equalsIgnoreCase("Administrador")) { rolTexto = "Administrador"; badgeClass = "badge-role-admin badge-custom"; }
                            else if(r.equals("2") || r.equalsIgnoreCase("Veterinario")) { rolTexto = "Veterinario"; badgeClass = "badge-role-vet badge-custom"; }
                            else if(r.equals("3") || r.equalsIgnoreCase("Operario")) { rolTexto = "Operario"; badgeClass = "badge-role-op badge-custom"; }
                            else if(r.equals("4") || r.equalsIgnoreCase("Vendedor")) { rolTexto = "Vendedor"; badgeClass = "badge-role-op badge-custom"; }
                            else if(r.equals("5") || r.equalsIgnoreCase("Cliente")) { rolTexto = "Cliente"; badgeClass = "badge-role-op badge-custom"; }
                            
                            String inicial = u.getFullName().substring(0, 1).toUpperCase();
                            String cargoReal = (u.getCargo() != null && !u.getCargo().isEmpty()) ? u.getCargo() : "Sin asignar";
                            
                            String fotoHtml = (u.getProfilePicture() != null && !u.getProfilePicture().isEmpty())
                                              ? "<img src='uploads/" + u.getProfilePicture().replace("\\", "/") + "?t=" + System.currentTimeMillis() + "' alt='Foto' style='width: 100%; height: 100%; object-fit: cover; border-radius: 50%;' onerror=\"this.style.display='none'; this.nextElementSibling.style.display='flex';\">" +
                                                "<div style='width: 100%; height: 100%; border-radius: 50%; background: #9CA889; color: white; display: none; align-items: center; justify-content: center; font-weight: bold;'>" + inicial + "</div>"
                                              : inicial;
                %>
                <tr>
                    <td class="text-start">
                        <div class="d-flex align-items-center gap-3">
                            <div class="avatar-circle"><%= fotoHtml %></div>
                            <div>
                                <strong class="d-block" style="font-size: 1rem; color: var(--text-main); font-weight: 600;"><%= u.getFullName() %></strong>
                                <small style="color: var(--text-subtle);"><%= u.getEmail() %></small>
                            </div>
                        </div>
                    </td>
                    <td style="color: var(--text-main); font-weight: 500;"><%= u.getDocumentId() %></td>
                    <td style="color: var(--text-subtle);"><%= cargoReal %></td>
                    <td>
                        <span class="<%= badgeClass %> d-block mb-1"><%= rolTexto %></span>
                        <% if("Inactivo".equalsIgnoreCase(u.getEstado())) { %>
                            <span class="badge bg-danger-subtle text-danger rounded-pill" style="font-size: 0.7rem;">Inactivo</span>
                        <% } %>
                    </td>
                    <td>
                        <div class="d-flex gap-1 justify-content-center">
                            
                            <button type="button" class="action-btn btn-qr" title="Descargar Gafete PDF"
                                onclick="verCarnet('<%= u.getFullName() %>', '<%= u.getDocumentId() %>', '<%= cargoReal %>', '<%= u.getTipoSangre() != null ? u.getTipoSangre() : "O+" %>', '<%= u.getArl() != null ? u.getArl() : "Positiva" %>', '<%= (u.getProfilePicture() != null && !u.getProfilePicture().isEmpty()) ? u.getProfilePicture().replace("\\", "/").replace("'", "\\'") : "" %>')">
                                <i class="bi bi-qr-code-scan"></i>
                            </button>

                            <button type="button" class="action-btn btn-view" title="Ver Perfil" 
                                onclick='abrirModalVer(<%= String.format("{\"nombre\":\"%s\", \"doc\":\"%s\", \"email\":\"%s\", \"rolTexto\":\"%s\", \"cargo\":\"%s\", \"salario\":\"%s\", \"tel\":\"%s\", \"eps\":\"%s\", \"foto\":\"%s\", \"inicial\":\"%s\"}", 
                                    u.getFullName(), u.getDocumentId(), u.getEmail(), rolTexto, 
                                    (u.getCargo()!=null?u.getCargo():"No asignado"), (u.getSalarioBase()), 
                                    (u.getTelefono()!=null?u.getTelefono():"No registrado"), (u.getEps()!=null?u.getEps():"No registrada"),
                                    (u.getProfilePicture()!=null?u.getProfilePicture():""), inicial) %>)'>
                                <i class="bi bi-eye"></i>
                            </button>

                            <button type="button" class="action-btn btn-edit" title="Editar Información" 
                                onclick='abrirModalEditar(<%= String.format("{\"id\":%d, \"nombre\":\"%s\", \"doc\":\"%s\", \"email\":\"%s\", \"rol\":\"%s\", \"cargo\":\"%s\", \"salario\":\"%s\", \"tel\":\"%s\", \"eps\":\"%s\", \"foto\":\"%s\", \"estado\":\"%s\", \"rh\":\"%s\", \"arl\":\"%s\"}", 
                                    u.getId(), u.getFullName(), u.getDocumentId(), u.getEmail(), r, 
                                    (u.getCargo()!=null?u.getCargo():""), (u.getSalarioBase()), 
                                    (u.getTelefono()!=null?u.getTelefono():""), (u.getEps()!=null?u.getEps():""),
                                    (u.getProfilePicture()!=null?u.getProfilePicture():""),
                                    (u.getEstado()!=null?u.getEstado():"Activo"),
                                    (u.getTipoSangre()!=null?u.getTipoSangre():""),
                                    (u.getArl()!=null?u.getArl():"")) %>)'>
                                <i class="bi bi-pencil"></i>
                            </button>

                            <form action="empleados" method="POST" class="d-inline" id="formDelete_<%= u.getId() %>">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= u.getId() %>">
                                <button type="button" class="action-btn btn-delete" title="Dar de baja" onclick="confirmarEliminacion('<%= u.getId() %>', '<%= u.getFullName() %>')">
                                    <i class="bi bi-trash3"></i>
                                </button>
                            </form>
                        </div>
                    </td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr><td colspan="5" class="text-center py-5 text-muted">No hay personal registrado en el sistema.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="modalViewEmpleado" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header d-flex justify-content-end" style="padding-bottom: 0;">
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body pt-0">
                <div class="profile-view-header">
                    <div class="profile-view-avatar" id="viewAvatar"></div>
                    <div class="profile-view-name" id="viewNombre">Nombre del Empleado</div>
                    <div class="profile-view-role" id="viewRol">ROLES</div>
                </div>

                <div class="form-section mt-4 mb-0" style="padding: 20px;">
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Cargo Oficial</span>
                            <span class="info-value" id="viewCargo">-</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Documento</span>
                            <span class="info-value" id="viewDoc">-</span>
                        </div>
                        <div class="info-item info-item-full">
                            <span class="info-label">Correo Electrónico</span>
                            <span class="info-value" id="viewEmail">-</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Teléfono</span>
                            <span class="info-value" id="viewTel">-</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Salario Base</span>
                            <span class="info-value" id="viewSalario">-</span>
                        </div>
                        <div class="info-item info-item-full" style="margin-bottom: 0;">
                            <span class="info-label">Entidad de Salud (EPS)</span>
                            <span class="info-value" id="viewEps">-</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer justify-content-center">
                <button type="button" class="btn btn-brand w-100 shadow-sm" data-bs-dismiss="modal">Cerrar Ficha</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalAddEmpleado" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title fw-bolder" style="color: var(--text-main); letter-spacing: -0.5px;" id="modalTitle">Nuevo Empleado</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            
            <form action="empleados" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="formId" value="">
                <input type="hidden" name="oldProfilePicture" id="inpOldPic" value="">
                
                <div class="modal-body" style="max-height: 70vh; overflow-y: auto;">
                    
                    <div class="preview-wrapper">
                        <div class="preview-circle" id="previewCircle">
                            <i class="bi bi-person" id="defaultIcon"></i>
                            <img id="imgPreview" src="" style="display:none;" alt="Preview">
                        </div>
                        <div class="file-upload-wrapper">
                            <div class="btn-upload" id="uploadLabel">Subir Fotografía</div>
                            <input type="file" name="profilePicture" id="inpFoto" accept="image/png, image/jpeg" onchange="actualizarPrevisualizacion(this)">
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="row g-3">
                            <div class="col-md-12">
                                <label class="form-label">Nombre Completo</label>
                                <input type="text" name="fullName" id="inpNombre" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Correo Electrónico</label>
                                <input type="email" name="email" id="inpEmail" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Nivel de Acceso</label>
                                <select name="rol" id="inpRol" class="form-select" onchange="autoCompletarCargo()" required>
                                    <option value="" disabled selected>Seleccionar...</option>
                                    <option value="1">Administrador Total</option>
                                    <option value="2">Veterinario</option>
                                    <option value="3">Operario</option>
                                    <option value="4">Vendedor</option>
                                </select>
                            </div>
                            <div class="col-md-12" id="passwordBox">
                                <label class="form-label">Contraseña Inicial</label>
                                <input type="text" name="password" class="form-control" value="123456" readonly>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Documento</label>
                                <input type="text" name="documentId" id="inpDoc" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Cargo Oficial</label>
                                <input type="text" name="cargo" id="inpCargo" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Teléfono</label>
                                <input type="text" name="telefono" id="inpTel" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Salario Base ($)</label>
                                <input type="number" name="salarioBase" id="inpSalario" class="form-control" step="0.01">
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Entidad de Salud (EPS)</label>
                                <input type="text" name="eps" id="inpEps" class="form-control" placeholder="Ej: Sanitas">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">ARL</label>
                                <input type="text" name="arl" id="inpArl" class="form-control" placeholder="Ej: Sura">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Tipo Sangre (RH)</label>
                                <input type="text" name="tipoSangre" id="inpRh" class="form-control" placeholder="Ej: O+">
                            </div>

                            <div class="col-md-12">
                                <label class="form-label">Estado del Empleado</label>
                                <select name="estado" id="inpEstado" class="form-select">
                                    <option value="Activo">Activo (Trabajando)</option>
                                    <option value="Inactivo">Inactivo (Suspendido/Retirado)</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                </div>
                <div class="modal-footer d-flex justify-content-between">
                    <button type="button" class="btn" data-bs-dismiss="modal" style="color: var(--text-subtle); font-weight: 600;" onclick="resetModal()">Cancelar</button>
                    <button type="submit" class="btn btn-brand shadow-sm" id="btnSubmit">Guardar Empleado</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="carnetModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 380px;">
        <div class="modal-content" style="border-radius: 20px; background-color: #FFFFFF; overflow: hidden; border: none;">
            
            <div style="display: flex; justify-content: center; background: #fafafa; padding: 15px;">
                <div id="carnetImprimible" style="width: 340px; height: 540px; background-color: #FFFFFF; border-radius: 20px; box-sizing: border-box; text-align: center; position: relative; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                    
                    <!-- Header Splash -->
                    <div style="background: linear-gradient(135deg, #464704, #272B22); padding: 25px 20px 60px 20px; text-align: center;">
                        <h5 style="margin: 0; color: #FFFFFF; font-weight: 800; font-size: 1.3rem; letter-spacing: 1px;"><i class="fa-solid fa-rose me-2" style="color: #e83e8c;"></i>FINCA LA ROSA</h5>
                        <p style="color: rgba(255,255,255,0.7); font-size: 0.75rem; letter-spacing: 2px; margin-top: 5px; margin-bottom: 0;">IDENTIFICACIÓN OFICIAL</p>
                    </div>

                    <!-- Avatar Floating -->
                    <div style="position: absolute; top: 75px; left: 0; right: 0; margin: 0 auto; width: 110px; height: 110px; border-radius: 50%; background: #fff; padding: 5px; box-shadow: 0 8px 16px rgba(0,0,0,0.15);">
                        <div id="carnetFotoContainer" style="width: 100%; height: 100%; border-radius: 50%; overflow: hidden; background: #f0f0f0;">
                            <!-- img or initial injected here -->
                        </div>
                    </div>

                    <!-- Body Content -->
                    <div style="padding: 65px 25px 20px 25px;">
                        <h4 id="carnetNombre" style="color: #1d1d1f; font-weight: 800; margin: 0 0 8px 0; font-size: 1.25rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">-</h4>
                        <span id="carnetCargo" style="background-color: rgba(156,168,137,0.15); color: #464704; font-weight: 800; font-size: 0.8rem; padding: 6px 16px; border-radius: 20px; text-transform: uppercase; letter-spacing: 0.5px; display: inline-block; margin-bottom: 20px; border: 1px solid rgba(156,168,137,0.3);">-</span>
                        
                        <!-- QR Code Area -->
                        <div style="background-color: #FFFFFF; padding: 10px; border-radius: 16px; border: 2px dashed #E2E4D5; width: 130px; height: 130px; margin: 0 auto 20px auto; display: flex; align-items: center; justify-content: center;">
                            <div id="qrContenedor" style="display: inline-block;"></div>
                        </div>

                        <!-- Footer Details -->
                        <div style="background: #fcfcfd; border-radius: 12px; padding: 12px; text-align: left; font-size: 0.85rem; color: #1d1d1f; display: flex; justify-content: space-between; border: 1px solid #f0f0f0;">
                            <div style="text-align: center;">
                                <div style="color: #86868b; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; margin-bottom: 2px;">C.C.</div>
                                <div id="carnetDoc" style="font-weight: 600;">-</div>
                            </div>
                            <div style="width: 1px; background: #e5e5e5;"></div>
                            <div style="text-align: center;">
                                <div style="color: #86868b; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; margin-bottom: 2px;">RH</div>
                                <div id="carnetRh" style="font-weight: 600;">-</div>
                            </div>
                            <div style="width: 1px; background: #e5e5e5;"></div>
                            <div style="text-align: center;">
                                <div style="color: #86868b; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; margin-bottom: 2px;">ARL</div>
                                <div id="carnetArl" style="font-weight: 600;">-</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="p-3 bg-light border-top text-center">
                <button class="btn btn-brand w-100 rounded-pill py-2 shadow-sm" onclick="descargarPDF()">
                    <i class="bi bi-file-earmark-pdf-fill me-1"></i> Descargar PDF Gafete
                </button>
            </div>
            
        </div>
    </div>
</div>

<script>
    // ==========================================
    // LÓGICA DE CÓDIGO QR SEGURO Y PDF NÍTIDO
    // ==========================================
    function verCarnet(nombre, documento, cargo, rh, arl, foto) {
        document.getElementById('carnetNombre').textContent = nombre;
        document.getElementById('carnetCargo').textContent = cargo || 'OPERARIO GANADERO';
        document.getElementById('carnetDoc').textContent = documento;
        document.getElementById('carnetRh').textContent = rh || 'O+';
        document.getElementById('carnetArl').textContent = arl || 'Positiva';

        const carnetFotoContainer = document.getElementById('carnetFotoContainer');
        const inicial = nombre.trim().charAt(0).toUpperCase();
        
        if (foto && foto.trim() !== '' && foto !== 'null') {
            const fotoLimpia = foto.trim().replace(/\\/g, '/');
            const timestamp = new Date().getTime();
            carnetFotoContainer.innerHTML = 
                '<img src="uploads/' + fotoLimpia + '?t=' + timestamp + '" alt="Foto" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;" ' +
                'onerror="this.style.display=\'none\'; this.nextElementSibling.style.display=\'flex\';">' +
                '<div style="width: 100%; height: 100%; border-radius: 50%; background: #9CA889; color: white; display: none; align-items: center; justify-content: center; font-size: 44px; line-height: 1; font-weight: bold; font-family: sans-serif;">' + inicial + '</div>';
        } else {
            carnetFotoContainer.innerHTML = '<div style="width: 100%; height: 100%; border-radius: 50%; background: #9CA889; color: white; display: flex; align-items: center; justify-content: center; font-size: 44px; line-height: 1; font-weight: bold; font-family: sans-serif;">' + inicial + '</div>';
        }

        var qrString = "FINCA-LAROSA-DOC-" + documento;
        
        // Limpiar códigos QR generados anteriormente
        document.getElementById('qrContenedor').innerHTML = "";
        
        // Dibujamos el QR nativo localmente
        new QRCode(document.getElementById("qrContenedor"), {
            text: qrString,
            width: 110,
            height: 110,
            colorDark : "#1d1d1f", 
            colorLight : "#ffffff",
            correctLevel : QRCode.CorrectLevel.H
        });
        
        var modal = new bootstrap.Modal(document.getElementById('carnetModal'));
        modal.show();
    }

    function descargarPDF() {
        const elemento = document.getElementById('carnetImprimible');
        const nombreEmpleado = document.getElementById('carnetNombre').textContent.replace(/\s+/g, '_');
        
        const currentTheme = document.documentElement.getAttribute('data-theme');
        document.documentElement.setAttribute('data-theme', 'light');

        // Eliminar bordes y sombras temporalmente para evitar recortes en html2canvas
        const oldShadow = elemento.style.boxShadow;
        const oldRadius = elemento.style.borderRadius;
        elemento.style.boxShadow = 'none';
        elemento.style.borderRadius = '0px';

        const btn = document.querySelector('.btn-brand i.bi-file-earmark-pdf-fill').parentElement;
        const originalText = btn.innerHTML;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Generando...';
        btn.disabled = true;

        setTimeout(() => {
            const opciones = {
                margin:       0,
                filename:     'Gafete_' + nombreEmpleado + '.pdf',
                image:        { type: 'jpeg', quality: 1.0 },
                html2canvas:  { 
                    scale: 4,
                    useCORS: true,
                    backgroundColor: '#ffffff'
                },
                jsPDF:        { unit: 'px', format: [340, 540], orientation: 'portrait' }
            };

            html2pdf().set(opciones).from(elemento).save().then(() => {
                btn.innerHTML = originalText;
                btn.disabled = false;
                document.documentElement.setAttribute('data-theme', currentTheme);
                elemento.style.boxShadow = oldShadow;
                elemento.style.borderRadius = oldRadius;
            }).catch(err => {
                console.error("Error generating PDF:", err);
                btn.innerHTML = originalText;
                btn.disabled = false;
                document.documentElement.setAttribute('data-theme', currentTheme);
                elemento.style.boxShadow = oldShadow;
                elemento.style.borderRadius = oldRadius;
            });
        }, 150);
    }

    // ==========================================
    // MODAL DE VISUALIZACIÓN LECTURA
    // ==========================================
    function abrirModalVer(empleado) {
        document.getElementById('viewNombre').innerText = empleado.nombre;
        document.getElementById('viewRol').innerText = empleado.rolTexto;
        document.getElementById('viewCargo').innerText = empleado.cargo;
        document.getElementById('viewDoc').innerText = empleado.doc;
        document.getElementById('viewEmail').innerText = empleado.email;
        document.getElementById('viewTel').innerText = empleado.tel;
        document.getElementById('viewEps').innerText = empleado.eps;
        
        let salarioVal = parseFloat(empleado.salario);
        document.getElementById('viewSalario').innerText = (!isNaN(salarioVal) && salarioVal > 0) ? "$" + salarioVal.toLocaleString('es-CO') : "No asignado";

        const avatarContainer = document.getElementById('viewAvatar');
        if (empleado.foto && empleado.foto.trim() !== '') {
            avatarContainer.innerHTML = '<img src="uploads/' + empleado.foto + '" alt="Avatar" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">';
        } else {
            avatarContainer.innerHTML = empleado.inicial;
        }

        var modal = new bootstrap.Modal(document.getElementById('modalViewEmpleado'));
        modal.show();
    }

    // ==========================================
    // PREVISUALIZACIÓN DE IMAGEN EN TIEMPO REAL
    // ==========================================
    function actualizarPrevisualizacion(input) {
        const label = document.getElementById('uploadLabel');
        const imgPreview = document.getElementById('imgPreview');
        const defaultIcon = document.getElementById('defaultIcon');

        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                imgPreview.src = e.target.result;
                imgPreview.style.display = 'block';
                defaultIcon.style.display = 'none';
            }
            reader.readAsDataURL(input.files[0]);
            label.innerHTML = 'Cambiar Foto';
        }
    }

    // ==========================================
    // AUTOCOMPLETADO DE CARGO
    // ==========================================
    function autoCompletarCargo() {
        const rol = document.getElementById('inpRol').value;
        const cargoInput = document.getElementById('inpCargo');
        const cargosSugeridos = { "1": "Administrador General", "2": "Médico Veterinario", "3": "Operario de Finca", "4": "Vendedor Externo", "5": "Cliente" };
        
        if (cargosSugeridos[rol]) {
            cargoInput.value = cargosSugeridos[rol];
            cargoInput.style.transition = 'background-color 0.3s';
            cargoInput.style.backgroundColor = '#eaf6ee';
            setTimeout(() => { cargoInput.style.backgroundColor = '#f5f5f7'; }, 400);
        }
    }

    // ==========================================
    // MANEJO DEL MODAL AÑADIR / EDITAR
    // ==========================================
    function resetModal() {
        document.getElementById('modalTitle').innerText = 'Nuevo Empleado';
        document.getElementById('formAction').value = 'add';
        document.getElementById('passwordBox').style.display = 'block';
        document.getElementById('btnSubmit').innerText = 'Guardar Empleado';
        
        document.getElementById('imgPreview').style.display = 'none';
        document.getElementById('imgPreview').src = '';
        document.getElementById('defaultIcon').style.display = 'block';
        document.getElementById('uploadLabel').innerText = 'Subir Fotografía';
        
        const fields = ['formId', 'inpOldPic', 'inpFoto', 'inpNombre', 'inpDoc', 'inpEmail', 'inpRol', 'inpCargo', 'inpSalario', 'inpTel', 'inpEps', 'inpArl', 'inpRh'];
        fields.forEach(id => document.getElementById(id).value = '');

        document.getElementById('inpEstado').value = 'Activo';
    }

    function abrirModalEditar(empleado) {
        resetModal();
        
        document.getElementById('modalTitle').innerText = 'Editar Ficha Técnica';
        document.getElementById('formAction').value = 'edit';
        document.getElementById('passwordBox').style.display = 'none'; 
        document.getElementById('btnSubmit').innerText = 'Actualizar Datos';
        
        document.getElementById('formId').value = empleado.id;
        document.getElementById('inpOldPic').value = empleado.foto;
        document.getElementById('inpNombre').value = empleado.nombre;
        document.getElementById('inpDoc').value = empleado.doc;
        document.getElementById('inpEmail').value = empleado.email;
        document.getElementById('inpCargo').value = empleado.cargo;
        document.getElementById('inpSalario').value = empleado.salario;
        document.getElementById('inpTel').value = empleado.tel;
        document.getElementById('inpEps').value = empleado.eps;
        
        document.getElementById('inpArl').value = empleado.arl;
        document.getElementById('inpRh').value = empleado.rh;
        document.getElementById('inpEstado').value = empleado.estado;
        
        if (empleado.foto && empleado.foto.trim() !== '') {
            document.getElementById('imgPreview').src = 'uploads/' + empleado.foto;
            document.getElementById('imgPreview').style.display = 'block';
            document.getElementById('defaultIcon').style.display = 'none';
            document.getElementById('uploadLabel').innerText = 'Cambiar Foto';
        }
        
        let optionValues = { "1": "1", "Administrador": "1", "2": "2", "Veterinario": "2", "3": "3", "Operario": "3", "4": "4", "Vendedor": "4", "5": "5", "Cliente": "5" };
        document.getElementById('inpRol').value = optionValues[empleado.rol] || "3";
        
        var modal = new bootstrap.Modal(document.getElementById('modalAddEmpleado'));
        modal.show();
    }

    function confirmarEliminacion(idForm, nombre) {
        Swal.fire({
            title: '¿Eliminar Empleado?',
            html: 'Se dará de baja a <b>' + nombre + '</b>. Esta acción restringirá su acceso al sistema.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#d2d2d7',
            confirmButtonText: 'Eliminar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('formDelete_' + idForm).submit();
            }
        });
    }
    
    document.getElementById('modalAddEmpleado').addEventListener('hidden.bs.modal', resetModal);

    // Inicialización de DataTables
    $(document).ready(function() {
        if (!$.fn.DataTable.isDataTable('#tablaEmpleados')) {
            $('#tablaEmpleados').DataTable({
                language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
                dom: '<"d-flex flex-wrap gap-2 justify-content-between align-items-center mb-3"Bf>rt<"d-flex flex-wrap justify-content-between align-items-center mt-3"ip>',
                buttons: [
                    { extend: 'excelHtml5', text: '<i class="bi bi-file-earmark-excel"></i> Excel', className: 'btn btn-success btn-sm shadow-sm rounded-pill px-3' },
                    { extend: 'pdfHtml5', text: '<i class="bi bi-file-earmark-pdf"></i> PDF', className: 'btn btn-danger btn-sm shadow-sm rounded-pill px-3' }
                ],
                pageLength: 10,
                ordering: true,
                responsive: true
            });
        }
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>