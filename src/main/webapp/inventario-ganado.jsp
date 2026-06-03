<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.Bovino" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Inventario Ganadero | Finca</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Se agrega Bootstrap Icons para mejorar el diseño de botones y detalles -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8f9fa; }
        .table-container { background: #fff; border-radius: 0 0 12px 12px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .nav-tabs .nav-link { color: #495057; font-weight: 600; }
        .nav-tabs .nav-link.active { color: #198754; font-weight: bold; border-top: 3px solid #198754; background-color: #fff; }
        .table th { white-space: nowrap; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container py-4">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-success mb-3 mb-md-0"><i class="bi bi-list-check"></i> Inventario General</h2>
        <button class="btn btn-success fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#modalBovino">
            <i class="bi bi-plus-circle"></i> Registrar Animal
        </button>
    </div>

    <% if(request.getAttribute("successMessage") != null) { %>
        <div class="alert alert-success alert-dismissible fade show shadow-sm">
            <i class="bi bi-check-circle-fill me-2"></i> <%= request.getAttribute("successMessage") %>
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>
    
    <% if(request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show shadow-sm">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= request.getAttribute("errorMessage") %>
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <ul class="nav nav-tabs" id="inventarioTabs">
        <li class="nav-item"><button class="nav-link active" data-bs-toggle="tab" data-bs-target="#produccion"><i class="bi bi-droplet-half"></i> Hato Lechero</button></li>
        <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#ventas"><i class="bi bi-tags"></i> Lote para Venta</button></li>
    </ul>

    <div class="tab-content table-container">
        <!-- PESTAÑA: HATO LECHERO -->
        <div class="tab-pane fade show active" id="produccion">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-success">
                        <tr>
                            <th>Arete</th>
                            <th>Raza</th>
                            <th>Edad</th>
                            <th>Litros/Día</th>
                            <th>N° Partos</th>
                            <th>Estado Salud</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Bovino> listaProd = (List<Bovino>) request.getAttribute("listaProduccion");
                            if(listaProd != null && !listaProd.isEmpty()) {
                                for(Bovino b : listaProd) {
                        %>
                        <tr>
                            <td class="fw-bold text-success"><%= b.getNumeroArete() %></td>
                            <td><%= b.getRaza() %></td>
                            <td><%= b.getEdadAnios() %> años</td>
                            <td class="fw-bold"><%= b.getLitrosDiariosPromedio() %> L</td>
                            <td><%= b.getNumeroPartos() %></td>
                            <td>
                                <span class="badge <%= b.getEstadoSalud().equals("Sano") || b.getEstadoSalud().equals("Sana") ? "bg-success" : "bg-warning text-dark" %>">
                                    <%= b.getEstadoSalud() %>
                                </span>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-info text-white fw-bold btn-resumen shadow-sm" 
                                    data-id="<%= b.getIdBovino() %>"
                                    data-arete="<%= b.getNumeroArete() %>"
                                    data-raza="<%= b.getRaza() %>"
                                    data-salud="<%= b.getEstadoSalud() %>"
                                    data-leche="<%= b.getLitrosDiariosPromedio() %>"
                                    data-edad="<%= b.getEdadAnios() %>"
                                    data-peso="<%= b.getPesoKg() %>"
                                    data-partos="<%= b.getNumeroPartos() %>"
                                    data-proposito="<%= b.getProposito() %>"
                                    data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>"
                                    data-bs-toggle="modal" data-bs-target="#modalResumen">
                                    <i class="bi bi-eye"></i> Resumen
                                </button>
                                <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-sm btn-outline-success shadow-sm">
                                    <i class="bi bi-folder2-open"></i> Perfil
                                </a>
                                <form action="inventario-ganado" method="POST" class="d-inline">
                                    <input type="hidden" name="action" value="mover">
                                    <input type="hidden" name="id" value="<%= b.getIdBovino() %>">
                                    <input type="hidden" name="destino" value="Venta">
                                    <button type="submit" class="btn btn-sm btn-outline-warning shadow-sm" title="Mover a Lote de Venta" onclick="return confirm('¿Seguro que deseas mover este animal al lote de venta?');">
                                        <i class="bi bi-arrow-right-circle"></i> Vender
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <% 
                                } 
                            } else { 
                        %>
                        <tr><td colspan="7" class="text-center text-muted py-4">No hay animales registrados en producción.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- PESTAÑA: LOTE PARA VENTA -->
        <div class="tab-pane fade" id="ventas">
            <div class="table-responsive">
                <table class="table table-hover align-middle mt-3 mb-0">
                    <thead class="table-warning">
                        <tr>
                            <th>Arete</th>
                            <th>Raza</th>
                            <th>Peso (Kg)</th>
                            <th>Edad</th>
                            <th>Precio Estimado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Bovino> listaVenta = (List<Bovino>) request.getAttribute("listaVenta");
                            if(listaVenta != null && !listaVenta.isEmpty()) {
                                for(Bovino b : listaVenta) {
                        %>
                        <tr>
                            <td class="fw-bold"><%= b.getNumeroArete() %></td>
                            <td><%= b.getRaza() %></td>
                            <td><%= b.getPesoKg() %> Kg</td>
                            <td><%= b.getEdadAnios() %> años</td>
                            <td class="text-success fw-bold">$<%= String.format("%,.2f", b.getPrecioEstimado()) %></td>
                            <td>
                                <!-- Se agrega el botón Resumen también en la pestaña de ventas -->
                                <button class="btn btn-sm btn-info text-white fw-bold btn-resumen shadow-sm" 
                                    data-id="<%= b.getIdBovino() %>"
                                    data-arete="<%= b.getNumeroArete() %>"
                                    data-raza="<%= b.getRaza() %>"
                                    data-salud="<%= b.getEstadoSalud() %>"
                                    data-leche="<%= b.getLitrosDiariosPromedio() %>"
                                    data-edad="<%= b.getEdadAnios() %>"
                                    data-peso="<%= b.getPesoKg() %>"
                                    data-partos="<%= b.getNumeroPartos() %>"
                                    data-proposito="<%= b.getProposito() %>"
                                    data-foto="<%= b.getImageUrl() != null ? b.getImageUrl() : "" %>"
                                    data-bs-toggle="modal" data-bs-target="#modalResumen">
                                    <i class="bi bi-eye"></i> Resumen
                                </button>
                                <a href="perfil-bovino?id=<%= b.getIdBovino() %>" class="btn btn-sm btn-outline-dark shadow-sm">
                                    <i class="bi bi-folder2-open"></i> Ver Perfil
                                </a>
                                <form action="inventario-ganado" method="POST" class="d-inline">
                                    <input type="hidden" name="action" value="mover">
                                    <input type="hidden" name="id" value="<%= b.getIdBovino() %>">
                                    <input type="hidden" name="destino" value="Producción">
                                    <button type="submit" class="btn btn-sm btn-outline-success shadow-sm" title="Regresar a Hato Lechero" onclick="return confirm('¿Seguro que deseas regresar este animal a producción?');">
                                        <i class="bi bi-arrow-left-circle"></i> A Producción
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <% 
                                } 
                            } else { 
                        %>
                        <tr><td colspan="6" class="text-center text-muted py-4">No hay animales clasificados para venta.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: RESUMEN RÁPIDO (VENTANA FLOTANTE MEJORADA) -->
<div class="modal fade" id="modalResumen" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-info-circle"></i> Resumen de Vaca: <span id="resArete"></span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body py-4">
                <div class="text-center mb-4">
                    <img id="resFoto" src="" class="rounded-circle mb-3 border border-4 border-info shadow-sm" style="width: 140px; height: 140px; object-fit: cover; display: none;">
                    <h4 class="fw-bold text-dark mb-1" id="resRaza"></h4>
                    <span id="resSalud" class="badge fs-6"></span>
                </div>
                
                <!-- Cuadrícula de información detallada -->
                <div class="row px-3 text-start">
                    <div class="col-6 mb-3">
                        <span class="text-muted small d-block"><i class="bi bi-calendar"></i> Edad</span>
                        <strong class="fs-6"><span id="resEdad"></span> años</strong>
                    </div>
                    <div class="col-6 mb-3">
                        <span class="text-muted small d-block"><i class="bi bi-speedometer"></i> Peso Actual</span>
                        <strong class="fs-6"><span id="resPeso"></span> Kg</strong>
                    </div>
                    <div class="col-6 mb-3">
                        <span class="text-muted small d-block"><i class="bi bi-bullseye"></i> Propósito</span>
                        <strong class="fs-6" id="resProposito"></strong>
                    </div>
                    <div class="col-6 mb-3">
                        <span class="text-muted small d-block"><i class="bi bi-clipboard2-plus"></i> N° de Partos</span>
                        <strong class="fs-6" id="resPartos"></strong>
                    </div>
                </div>

                <div class="mt-3 pt-3 border-top text-center">
                    <p class="mb-0 text-muted">Producción Promedio</p>
                    <h4 class="text-primary fw-bold mb-0"><span id="resLeche"></span> L/día</h4>
                </div>
            </div>
            <div class="modal-footer bg-light">
                <a href="#" id="btnInfoCompleta" class="btn btn-primary fw-bold w-100"><i class="bi bi-clipboard2-data"></i> Ver Perfil Completo y Médico</a>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: REGISTRAR NUEVO ANIMAL -->
<div class="modal fade" id="modalBovino" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-success text-white">
                <h5 class="fw-bold mb-0"><i class="bi bi-plus-circle"></i> Registro de Nuevo Animal</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="inventario-ganado" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Número de Arete</label>
                            <input type="text" name="numeroArete" class="form-control" placeholder="Ej: V-001" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Raza</label>
                            <input type="text" name="raza" class="form-control" placeholder="Ej: Holstein, Brahman" required>
                        </div>
                        
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Fecha de Nacimiento</label>
                            <input type="date" name="fechaNacimiento" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Género</label>
                            <select name="genero" class="form-select" required>
                                <option value="Hembra">Hembra</option>
                                <option value="Macho">Macho</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Peso (Kg)</label>
                            <input type="number" step="0.01" name="pesoKg" class="form-control" placeholder="0.00" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Clasificación</label>
                            <select name="clasificacion" class="form-select" required>
                                <option value="Producción">Producción (Hato Lechero)</option>
                                <option value="Venta">Para Venta</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Propósito</label>
                            <select name="proposito" class="form-select" required>
                                <option value="Leche">Leche</option>
                                <option value="Carne">Carne</option>
                                <option value="Doble Propósito">Doble Propósito</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Estado de Salud</label>
                            <select name="estadoSalud" class="form-select" required>
                                <option value="Sano">Sano / Sana</option>
                                <option value="Enfermo">Enfermo / Enferma</option>
                                <option value="En Tratamiento">En Tratamiento</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Litros Diarios (Promedio)</label>
                            <input type="number" step="0.01" name="litrosDiarios" class="form-control" placeholder="0.0" value="0">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Número de Partos</label>
                            <input type="number" name="numeroPartos" class="form-control" placeholder="0" value="0">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Precio Estimado ($)</label>
                            <input type="number" step="0.01" name="precioEstimado" class="form-control" placeholder="Valor comercial" required>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-bold">URL de Fotografía (Opcional)</label>
                            <input type="url" name="imageUrl" class="form-control" placeholder="https://ejemplo.com/foto_vaca.jpg">
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-success fw-bold"><i class="bi bi-save"></i> Guardar Registro</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.querySelectorAll('.btn-resumen').forEach(button => {
        button.addEventListener('click', function() {
            // Llenar datos básicos
            document.getElementById('resArete').innerText = this.dataset.arete;
            document.getElementById('resRaza').innerText = this.dataset.raza;
            document.getElementById('resLeche').innerText = this.dataset.leche;
            
            // Llenar nuevos datos agregados
            document.getElementById('resEdad').innerText = this.dataset.edad;
            document.getElementById('resPeso').innerText = this.dataset.peso;
            document.getElementById('resProposito').innerText = this.dataset.proposito;
            document.getElementById('resPartos').innerText = this.dataset.partos;
            
            // Estilizar el badge de salud dinámicamente
            let saludBadge = document.getElementById('resSalud');
            saludBadge.innerText = this.dataset.salud;
            if (this.dataset.salud === "Sano" || this.dataset.salud === "Sana") {
                saludBadge.className = "badge bg-success fs-6";
            } else {
                saludBadge.className = "badge bg-warning text-dark fs-6";
            }
            
            // Manejar la imagen
            let img = document.getElementById('resFoto');
            if(this.dataset.foto && this.dataset.foto !== "null" && this.dataset.foto !== "") { 
                img.src = this.dataset.foto; 
                img.style.display = "inline-block"; 
            } else { 
                img.style.display = "none"; 
            }

            // Actualizar enlace al perfil completo
            document.getElementById('btnInfoCompleta').href = "perfil-bovino?id=" + this.dataset.id;
        });
    });
</script>
</body>
</html>