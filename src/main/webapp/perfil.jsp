<%@ page import="com.finca.models.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Usuario u = (Usuario) request.getAttribute("usuario");
    if(u == null) { response.sendRedirect("login"); return; }
    
    String r = u.getRol() != null ? u.getRol() : "";
    String rolTexto = "Desconocido";
    if(r.equals("1") || r.equalsIgnoreCase("Administrador")) rolTexto = "Administrador";
    else if(r.equals("2") || r.equalsIgnoreCase("Veterinario")) rolTexto = "Veterinario";
    else if(r.equals("3") || r.equalsIgnoreCase("Operario")) rolTexto = "Operario (Vaquero)";
    else if(r.equals("4") || r.equalsIgnoreCase("Vendedor")) rolTexto = "Vendedor";
    
    String inicial = u.getFullName().substring(0, 1).toUpperCase();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil | Finca La Rosa</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

    <style>
        :root {
            --bg-page: #F3F5E7 !important;     
            --bg-card: #FFFFFF !important;
            --brand-primary: #464704 !important; 
            --brand-info: #9CA889 !important;    
            --brand-dark: #423926 !important;    
            --text-main: #1d1d1f !important;
            --text-subtle: #86868b !important;
            --shadow-apple: 0 4px 6px rgba(0, 0, 0, 0.02), 0 10px 20px rgba(0, 0, 0, 0.04);
        }

        body { font-family: 'Inter', sans-serif; background-color: var(--bg-page) !important; color: var(--text-main); -webkit-font-smoothing: antialiased; }
        
        .card-apple { background: var(--bg-card); border-radius: 28px; border: none; box-shadow: var(--shadow-apple); padding: 30px; }
        
        .avatar-lg { width: 140px; height: 140px; border-radius: 50%; object-fit: cover; border: 4px solid var(--bg-page); box-shadow: var(--shadow-apple); background: var(--brand-info); display: flex; align-items: center; justify-content: center; color: white; font-size: 3rem; font-weight: bold; margin: 0 auto 20px auto; }
        
        .form-control { border-radius: 14px; background: #f5f5f7 !important; border: 1px solid transparent !important; padding: 14px 18px; color: var(--text-main); font-weight: 500; transition: 0.3s; }
        .form-control:focus { background: #fff !important; border-color: var(--brand-info) !important; box-shadow: 0 0 0 4px rgba(156, 168, 137, 0.2) !important; }
        .form-control:read-only { opacity: 0.7; cursor: not-allowed; }
        .form-label { font-size: 0.8rem; font-weight: 700; color: var(--text-subtle); text-transform: uppercase; letter-spacing: 0.5px; }

        .btn-brand { background-color: var(--brand-primary) !important; color: white !important; font-weight: 600; border-radius: 14px; padding: 12px 24px; transition: 0.3s; }
        .btn-brand:hover { background-color: var(--brand-dark) !important; transform: scale(1.02); }
        
        .qr-box { background: white; padding: 15px; border-radius: 20px; display: inline-block; border: 2px dashed #E2E4D5; margin-top: 15px;}
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container py-4">
    
    <div class="mb-4">
        <h2 class="fw-bolder mb-1" style="color: var(--text-main); letter-spacing: -0.5px;">Mi Perfil</h2>
        <span class="fw-medium text-subtle">Información de tu cuenta y código de acceso.</span>
    </div>

    <% if(request.getAttribute("successMessage") != null) { %>
        <script> document.addEventListener("DOMContentLoaded", () => Swal.fire({ icon: 'success', title: '¡Listo!', text: '<%= request.getAttribute("successMessage") %>', confirmButtonColor: '#464704' })); </script>
    <% } %>
    <% if(request.getAttribute("errorMessage") != null) { %>
        <script> document.addEventListener("DOMContentLoaded", () => Swal.fire({ icon: 'error', title: 'Error', text: '<%= request.getAttribute("errorMessage") %>', confirmButtonColor: '#dc3545' })); </script>
    <% } %>

    <div class="row g-4">
        
        <div class="col-lg-4">
            <div class="card-apple text-center h-100">
                <% if(u.getProfilePicture() != null && !u.getProfilePicture().isEmpty()) { %>
                    <img src="uploads/<%= u.getProfilePicture() %>" class="avatar-lg" alt="Foto">
                <% } else { %>
                    <div class="avatar-lg"><%= inicial %></div>
                <% } %>
                
                <h4 class="fw-bolder" style="color: var(--brand-dark);"><%= u.getFullName() %></h4>
                <p class="badge bg-light text-dark border px-3 py-2 rounded-pill fw-bold"><%= rolTexto %></p>
                <p class="text-muted small mt-2"><i class="bi bi-briefcase-fill me-1"></i> <%= u.getCargo() != null ? u.getCargo() : "Sin cargo oficial" %></p>
                
                <hr style="border-color: var(--border-subtle); margin: 25px 0;">
                
                <p class="fw-bold mb-2" style="color: var(--brand-primary); font-size: 0.9rem;">TU CÓDIGO DE INGRESO (QR)</p>
                <div class="qr-box">
                    <div id="miQrCode"></div>
                </div>
                <p class="small text-muted mt-2" style="font-size: 0.75rem;">Muestra este código en la entrada de la finca para registrar tu asistencia.</p>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="card-apple">
                <h5 class="fw-bolder mb-4" style="color: var(--brand-dark);">Ajustes de Cuenta</h5>
                
                <form action="perfil" method="post" enctype="multipart/form-data">
                    
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <label class="form-label">Documento de Identidad <i class="bi bi-lock-fill text-muted ms-1" title="Campo bloqueado"></i></label>
                            <input type="text" class="form-control" value="<%= u.getDocumentId() %>" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Correo Electrónico <i class="bi bi-lock-fill text-muted ms-1"></i></label>
                            <input type="email" class="form-control" value="<%= u.getEmail() %>" readonly>
                        </div>
                    </div>

                    <h6 class="fw-bold mt-4 mb-3" style="color: var(--brand-info); font-size: 0.85rem; text-transform: uppercase;">Datos Editables</h6>
                    
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label">Teléfono Celular</label>
                            <input type="text" name="telefono" class="form-control" value="<%= u.getTelefono() != null ? u.getTelefono() : "" %>" placeholder="Ej: 310...">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Dirección de Residencia</label>
                            <input type="text" name="direccion" class="form-control" value="<%= u.getDireccion() != null ? u.getDireccion() : "" %>" placeholder="Tu barrio o vereda">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Contacto de Emergencia</label>
                            <input type="text" name="contactoEmergencia" class="form-control" value="<%= u.getContactoEmergencia() != null ? u.getContactoEmergencia() : "" %>" placeholder="Nombre y celular">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Actualizar Foto de Perfil</label>
                            <input type="file" name="profilePicture" class="form-control bg-white" accept="image/*">
                        </div>
                    </div>
                    
                    <hr style="border-color: var(--border-subtle); margin: 30px 0;">

                    <div class="row">
                        <div class="col-md-4">
                            <label class="form-label">Tipo de Sangre</label>
                            <input type="text" class="form-control" value="<%= u.getTipoSangre() != null ? u.getTipoSangre() : "No registrado" %>" readonly>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">EPS</label>
                            <input type="text" class="form-control" value="<%= u.getEps() != null ? u.getEps() : "No registrada" %>" readonly>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">ARL</label>
                            <input type="text" class="form-control" value="<%= u.getArl() != null ? u.getArl() : "No registrada" %>" readonly>
                        </div>
                    </div>

                    <div class="text-end mt-4 pt-2">
                        <button type="submit" class="btn btn-brand shadow-sm">
                            <i class="bi bi-floppy-fill me-1"></i> Guardar Cambios
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Generar el código QR personal cuando cargue la página
    document.addEventListener("DOMContentLoaded", function() {
        var documento = "<%= u.getDocumentId() %>";
        var qrString = "FINCA-LAROSA-DOC-" + documento;
        
        new QRCode(document.getElementById("miQrCode"), {
            text: qrString,
            width: 140,
            height: 140,
            colorDark : "#464704", 
            colorLight : "#ffffff",
            correctLevel : QRCode.CorrectLevel.H
        });
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>