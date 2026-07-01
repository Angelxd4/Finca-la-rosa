<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.Cliente" %>
<%@ page import="com.finca.models.Venta" %>
<%@ page import="com.finca.models.Bovino" %>
<%@ page import="com.finca.models.ProductoLacteo" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
    List<Venta> historial = (List<Venta>) request.getAttribute("historialVentas");
    List<Bovino> ganado = (List<Bovino>) request.getAttribute("ganadoParaVenta");
    List<ProductoLacteo> lacteos = (List<ProductoLacteo>) request.getAttribute("catalogoLacteos");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="includes/header.jsp" />
    <title>Punto de Venta | Finca La Rosa</title>
    <style>
        .pos-container { display: flex; gap: 24px; min-height: calc(100vh - 120px); align-items: stretch; }
        
        /* CATÁLOGO DE PRODUCTOS (Izquierda) */
        .pos-catalog { 
            flex: 2; 
            display: flex; 
            flex-direction: column; 
            background: var(--bg-card); 
            border-radius: 28px; 
            border: 1px solid var(--border-subtle); 
            padding: 24px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.03);
        }
        
        /* Pills modernos para categorías */
        .nav-pills { gap: 10px; border-bottom: 2px solid var(--border-subtle); padding-bottom: 15px; margin-bottom: 20px !important; }
        .nav-pills .nav-link { 
            color: var(--text-subtle) !important; 
            font-weight: 700; 
            border-radius: 50px; 
            padding: 10px 24px;
            transition: all 0.3s ease;
            background: var(--bg-page);
            border: 1px solid transparent;
        }
        .nav-pills .nav-link:hover { background: rgba(156, 168, 137, 0.1); color: var(--brand-dark) !important; }
        .nav-pills .nav-link.active { 
            background: linear-gradient(135deg, var(--brand-primary), var(--brand-dark)) !important; 
            color: white !important; 
            box-shadow: 0 8px 20px rgba(70, 71, 4, 0.25);
            border: 1px solid var(--brand-dark);
        }
        
        /* Grid y Tarjetas */
        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 20px; overflow-y: auto; padding-right: 5px; padding-bottom: 20px;}
        .product-grid::-webkit-scrollbar { width: 6px; }
        .product-grid::-webkit-scrollbar-thumb { background: var(--border-subtle); border-radius: 10px; }
        
        .product-card { 
            background: #FFFFFF; 
            border: 1px solid var(--border-subtle); 
            border-radius: 20px; 
            padding: 20px 15px; 
            text-align: center; 
            cursor: pointer; 
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); 
            box-shadow: 0 4px 15px rgba(0,0,0,0.02); 
            display: flex; flex-direction: column; align-items: center; justify-content: space-between;
            position: relative;
            overflow: hidden;
        }
        
        html[data-theme="dark"] .product-card { background: #1e221c; } /* Moss muy oscuro */
        
        .product-card::before {
            content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 4px;
            background: var(--brand-primary); transform: scaleX(0); transition: transform 0.3s ease; transform-origin: left;
        }
        .product-card:hover { 
            transform: translateY(-8px); 
            box-shadow: 0 15px 35px rgba(70,71,4,0.15); 
            border-color: transparent;
        }
        .product-card:hover::before { transform: scaleX(1); }
        .product-card:active { transform: scale(0.96); }
        
        .product-icon { 
            font-size: 38px; color: var(--brand-primary); margin-bottom: 12px; 
            background: rgba(156, 168, 137, 0.15); width: 70px; height: 70px; 
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            transition: all 0.3s ease;
        }
        .product-card:hover .product-icon { transform: rotate(-10deg) scale(1.1); }
        
        .product-card h6 { font-weight: 800; font-size: 15px; margin-bottom: 5px; color: var(--text-main); }
        .product-stock { font-size: 12px; font-weight: 600; color: var(--text-subtle); background: var(--bg-page); padding: 4px 10px; border-radius: 20px; margin-bottom: 12px; }
        .product-price { font-weight: 900; color: var(--brand-dark); font-size: 18px; }

        /* FACTURA / CARRITO (Derecha) */
        .pos-cart { 
            flex: 1; 
            background: #FAFAFA; 
            border-radius: 28px; 
            border: 1px solid var(--border-subtle); 
            display: flex; flex-direction: column; 
            padding: 30px; 
            min-width: 350px; 
            box-shadow: -5px 0 30px rgba(0,0,0,0.02);
            position: relative;
        }
        html[data-theme="dark"] .pos-cart { background: #121410; }
        
        /* Efecto ticket de compra */
        .pos-cart::before, .pos-cart::after {
            content: ''; position: absolute; left: 0; right: 0; height: 10px; background-size: 20px 20px;
        }
        .pos-cart::before { top: -5px; background-image: radial-gradient(circle at 10px 0, transparent 10px, var(--border-subtle) 11px); }
        
        .cart-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-bottom: 2px dashed var(--border-subtle); padding-bottom: 15px; }
        .cart-header h4 { font-weight: 900; color: var(--brand-dark); margin: 0; font-size: 1.4rem; letter-spacing: -0.5px; }
        
        .client-selector { background: #FFFFFF; border-radius: 16px; padding: 15px; border: 1px solid var(--border-subtle); margin-bottom: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.02); }
        html[data-theme="dark"] .client-selector { background: var(--bg-card); }
        .client-selector .form-label { font-size: 11px; font-weight: 800; letter-spacing: 1px; color: var(--text-subtle); text-transform: uppercase; margin-bottom: 8px;}
        .client-selector .form-select { border: none; background: var(--bg-page); border-radius: 10px; font-weight: 600; font-size: 14px; padding: 10px 15px;}
        .client-selector .form-select:focus { box-shadow: 0 0 0 3px rgba(156,168,137,0.3); }

        .cart-items { flex-grow: 1; overflow-y: auto; margin-bottom: 20px; padding: 5px 10px 5px 0; }
        .cart-items::-webkit-scrollbar { width: 4px; }
        .cart-items::-webkit-scrollbar-thumb { background: var(--border-subtle); border-radius: 10px; }
        
        .cart-item { 
            display: flex; justify-content: space-between; align-items: center; 
            padding: 15px; background: #FFFFFF; border-radius: 16px; margin-bottom: 12px; 
            border: 1px solid var(--border-subtle);
            box-shadow: 0 4px 10px rgba(0,0,0,0.02);
            transition: all 0.2s ease;
        }
        html[data-theme="dark"] .cart-item { background: var(--bg-card); }
        .cart-item:hover { border-color: rgba(220,53,69,0.5); }
        
        .cart-item-info strong { font-size: 15px; font-weight: 800; color: var(--text-main); }
        .cart-item-info small { font-size: 12px; font-weight: 600; color: var(--text-subtle); display: block; margin-top: 3px; }
        .cart-item-qty { font-weight: 800; background: var(--bg-page); color: var(--brand-dark); padding: 5px 12px; border-radius: 10px; font-size: 14px; border: 1px solid var(--border-subtle);}
        .cart-item-remove { color: #dc3545; background: rgba(220,53,69,0.1); border: none; border-radius: 10px; width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; transition: all 0.2s; cursor: pointer;}
        .cart-item-remove:hover { background: #dc3545; color: white; transform: scale(1.1); }
        
        .cart-footer { border-top: 2px dashed var(--border-subtle); padding-top: 25px; margin-top: auto; }
        
        .total-row { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 20px; background: #FFFFFF; padding: 20px; border-radius: 20px; border: 1px solid var(--border-subtle); box-shadow: 0 4px 15px rgba(0,0,0,0.03);}
        html[data-theme="dark"] .total-row { background: var(--bg-card); }
        .total-label { font-size: 14px; font-weight: 800; color: var(--text-subtle); letter-spacing: 1px; text-transform: uppercase; }
        .cart-total { font-size: 32px; font-weight: 900; color: var(--brand-dark); letter-spacing: -1px; line-height: 1;}
        
        .payment-method { margin-bottom: 20px; }
        .payment-method select { border: 2px solid var(--border-subtle); border-radius: 16px; padding: 15px; font-weight: 700; font-size: 15px; color: var(--text-main); background-color: #FFFFFF; cursor: pointer;}
        html[data-theme="dark"] .payment-method select { background-color: var(--bg-card); }
        
        .btn-procesar {
            background: linear-gradient(135deg, var(--brand-primary), var(--brand-dark));
            color: white; border-radius: 20px; padding: 20px; font-weight: 900; font-size: 18px;
            border: none; width: 100%; box-shadow: 0 10px 25px rgba(70, 71, 4, 0.3);
            text-transform: uppercase; letter-spacing: 1px; transition: all 0.3s ease;
        }
        .btn-procesar:hover:not(:disabled) { transform: translateY(-3px); box-shadow: 0 15px 35px rgba(70, 71, 4, 0.4); }
        .btn-procesar:disabled { background: var(--border-subtle); color: var(--text-subtle); box-shadow: none; cursor: not-allowed; transform: none; }

        @media (max-width: 991px) {
            .pos-container { flex-direction: column; min-height: auto; gap: 15px; }
            .pos-catalog { height: 500px; padding: 15px; }
            .pos-cart { width: 100%; min-height: auto; padding: 20px 15px; }
            .product-grid { grid-template-columns: repeat(auto-fill, minmax(130px, 1fr)); gap: 10px; }
            .product-card { padding: 15px 10px; }
            .product-icon { width: 50px; height: 50px; font-size: 24px; margin-bottom: 8px; }
            .nav-pills { flex-wrap: nowrap; overflow-x: auto; padding-bottom: 5px; white-space: nowrap; margin-bottom: 15px !important; }
            .nav-pills::-webkit-scrollbar { height: 4px; }
            .nav-pills::-webkit-scrollbar-thumb { background: var(--border-subtle); border-radius: 10px; }
            .cart-header h4 { font-size: 1.2rem; }
            .cart-total { font-size: 24px; }
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container-fluid py-4 px-xl-5">
    
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
        <div>
            <h2 class="fw-bold mb-1 text-brand fs-3" style="letter-spacing: -1px;"><i class="bi bi-shop me-2"></i> Punto de Venta</h2>
            <p class="text-subtle mb-0 fw-semibold" style="font-size: 0.9rem;">Facturación rápida de Ganado y Lácteos</p>
        </div>
        <button class="btn btn-outline-brand rounded-pill px-4 fw-bold shadow-sm w-100 w-md-auto" data-bs-toggle="modal" data-bs-target="#modalHistorial">
            <i class="bi bi-clock-history me-2"></i> Historial
        </button>
    </div>

    <div class="pos-container">
        
        <!-- ================= CATÁLOGO DE PRODUCTOS ================= -->
        <div class="pos-catalog">
            <ul class="nav nav-pills" id="pills-tab" role="tablist">
              <li class="nav-item" role="presentation">
                <button class="nav-link active" id="pills-lacteos-tab" data-bs-toggle="pill" data-bs-target="#pills-lacteos" type="button" role="tab">
                    <i class="bi bi-box-seam me-2"></i> Productos Lácteos
                </button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link" id="pills-ganado-tab" data-bs-toggle="pill" data-bs-target="#pills-ganado" type="button" role="tab">
                    <i class="bi bi-bug me-2"></i> Ganado de Venta
                </button>
              </li>
            </ul>
            
            <div class="tab-content flex-grow-1" id="pills-tabContent" style="overflow-y: auto;">
              
              <!-- Tab Lácteos -->
              <div class="tab-pane fade show active h-100" id="pills-lacteos" role="tabpanel">
                  <div class="product-grid">
                      <% if(lacteos != null) { for(ProductoLacteo p : lacteos) { 
                          double precioFinal = "LAC-001".equals(p.getCodigo()) ? 1700.0 : p.getPrecioUnitario();
                      %>
                      <div class="product-card" onclick="addToCart('<%= p.getIdProducto() %>', 'Lacteo', '<%= p.getNombre() %>', <%= precioFinal %>, true, <%= p.getStock() %>)">
                          <div class="product-icon"><i class="bi bi-droplet-half"></i></div>
                          <h6><%= p.getNombre() %></h6>
                          <div class="product-stock"><%= p.getStock() %> uds disp.</div>
                          <div class="product-price">$ <%= String.format("%,.2f", precioFinal) %></div>
                      </div>
                      <% }} %>
                  </div>
              </div>
              
              <!-- Tab Ganado -->
              <div class="tab-pane fade h-100" id="pills-ganado" role="tabpanel">
                  <div class="product-grid">
                      <% if(ganado != null && !ganado.isEmpty()) { for(Bovino b : ganado) { %>
                      <div class="product-card" onclick="addToCart('<%= b.getIdBovino() %>', 'Ganado', 'Vaca <%= b.getNumeroArete() %>', <%= b.getPrecioEstimado() %>, false, 1)">
                          <div class="product-icon"><i class="bi bi-tags-fill"></i></div>
                          <h6>Arete: <%= b.getNumeroArete() %></h6>
                          <div class="product-stock"><%= b.getClasificacion() %></div>
                          <div class="product-price">$ <%= String.format("%,.2f", b.getPrecioEstimado()) %></div>
                      </div>
                      <% }} else { %>
                        <div class="w-100 d-flex flex-column align-items-center justify-content-center text-muted" style="grid-column: 1 / -1; min-height: 200px;">
                            <i class="bi bi-info-circle fs-1 mb-3 opacity-50"></i>
                            <h5 class="fw-bold">Sin animales para la venta</h5>
                            <p>Marca animales como "Venta" en el Inventario para que aparezcan aquí.</p>
                        </div>
                      <% } %>
                  </div>
              </div>
            </div>
        </div>

        <!-- ================= CARRITO / FACTURA ================= -->
        <div class="pos-cart">
            <div class="cart-header">
                <h4><i class="bi bi-receipt me-2"></i> Detalle Factura</h4>
                <span class="badge bg-dark rounded-pill px-3 py-2">Caja #1</span>
            </div>
            
            <form id="formVenta" action="<%= request.getContextPath() %>/ventas" method="POST" class="d-flex flex-column h-100">
                <input type="hidden" name="action" value="registrar_venta">
                
                <div class="client-selector">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <label class="form-label">Cliente Asociado</label>
                        <button type="button" class="btn btn-sm btn-link text-brand p-0 fw-bold text-decoration-none" data-bs-toggle="modal" data-bs-target="#modalNuevoCliente">
                            <i class="bi bi-person-plus-fill"></i> Nuevo
                        </button>
                    </div>
                    <select class="form-select w-100" name="nombreCliente">
                        <option value="">Consumidor Final (Sin registrar)</option>
                        <% if(clientes != null) { for(Cliente c : clientes) { %>
                            <option value="<%= c.getNombreCompleto() %>"><%= c.getNombreCompleto() %> (<%= c.getDocumentoIdentidad() %>)</option>
                        <% }} %>
                    </select>
                </div>
                
                <div class="cart-items" id="cartContainer">
                    <div class="h-100 d-flex flex-column align-items-center justify-content-center text-muted opacity-50" id="emptyCartMsg">
                        <i class="bi bi-cart-x" style="font-size: 3rem; margin-bottom: 10px;"></i>
                        <h6 class="fw-bold">El carrito está vacío</h6>
                        <small>Selecciona productos a la izquierda</small>
                    </div>
                </div>
                
                <div class="cart-footer">
                    <div class="total-row">
                        <span class="total-label">Importe Total</span>
                        <span class="cart-total" id="cartTotalDisplay">$ 0.00</span>
                    </div>
                    
                    <div class="payment-method">
                        <label class="form-label fw-bold mb-2"><i class="bi bi-wallet2 me-2"></i>Método de Pago</label>
                        <select class="form-select w-100 shadow-sm" name="metodoPago" required>
                            <option value="Efectivo" selected>Pago en Efectivo</option>
                            <option value="Transferencia">Transferencia Bancaria</option>
                            <option value="Tarjeta">Tarjeta Débito / Crédito</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn-procesar" id="btnProcesar" disabled>
                        <i class="bi bi-check2-all fs-5 me-2"></i> Procesar Pago
                    </button>
                </div>
                
                <!-- Contenedor oculto para inputs del form -->
                <div id="hiddenInputs"></div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Historial -->
<div class="modal fade" id="modalHistorial" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold text-brand"><i class="bi bi-clock-history"></i> Historial de Ventas</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="table-responsive">
                    <table class="table table-hover table-clean" id="tableVentas">
                    <thead>
                        <tr>
                            <th># Venta</th>
                            <th>Fecha</th>
                            <th>Cliente</th>
                            <th>Método</th>
                            <th>Estado</th>
                            <th>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(historial != null) { for(Venta v : historial) { %>
                        <tr>
                            <td class="fw-bold">V-<%= String.format("%04d", v.getIdVenta()) %></td>
                            <td><%= v.getFechaVenta() %></td>
                            <td><%= v.getNombreCliente() != null ? v.getNombreCliente() : "Desconocido" %></td>
                            <td><%= v.getMetodoPago() %></td>
                            <td><span class="badge bg-success rounded-pill px-3"><%= v.getEstado() %></span></td>
                            <td class="fw-bold text-brand">$ <%= String.format("%,.2f", v.getTotal()) %></td>
                        </tr>
                        <% }} %>
                    </tbody>
                </table>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

<div class="modal fade" id="modalNuevoCliente" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold text-brand"><i class="bi bi-person-plus"></i> Nuevo Cliente</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <form action="<%= request.getContextPath() %>/ventas" method="POST">
                    <input type="hidden" name="action" value="nuevo_cliente">
                    <div class="mb-3">
                        <label class="form-label">Nombre Completo</label>
                        <input type="text" class="form-control" name="nombreCompleto" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Documento Identidad (DNI/NIT)</label>
                        <input type="text" class="form-control" name="documentoIdentidad" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Teléfono</label>
                        <input type="text" class="form-control" name="telefono">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Correo</label>
                        <input type="email" class="form-control" name="correo">
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Dirección</label>
                        <input type="text" class="form-control" name="direccion">
                    </div>
                    <button type="submit" class="btn btn-brand w-100 py-2"><i class="bi bi-save"></i> Guardar Cliente</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    let cart = [];

    function addToCart(id, tipo, desc, precio, permiteCantidad, maxStock) {
        if (permiteCantidad) {
            Swal.fire({
                title: 'Cantidad deseada',
                input: 'number',
                inputLabel: `Stock disponible: ${maxStock}`,
                inputValue: 1,
                showCancelButton: true,
                confirmButtonText: 'Agregar',
                confirmButtonColor: '#464704', 
                inputValidator: (value) => {
                    if (!value || value <= 0) return 'Debes ingresar una cantidad válida';
                    if (value > maxStock) return 'No hay suficiente stock disponible';
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    processAddToCart(id, tipo, desc, precio, parseInt(result.value), permiteCantidad, maxStock);
                }
            });
        } else {
            processAddToCart(id, tipo, desc, precio, 1, permiteCantidad, maxStock);
        }
    }

    function processAddToCart(id, tipo, desc, precio, cantidadAgregada, permiteCantidad, maxStock) {
        let exist = cart.find(i => i.id === id && i.tipo === tipo);
        
        if(exist && permiteCantidad) {
            if (exist.cantidad + cantidadAgregada > maxStock) {
                Swal.fire({icon: 'warning', title: 'Sin Stock', text: 'No puedes agregar más que el stock disponible.', confirmButtonColor: '#464704'});
                return;
            }
            exist.cantidad += cantidadAgregada;
        } else if (!exist) {
            if (cantidadAgregada > maxStock && maxStock !== 1) { // Para ganado maxStock es 1 simulado
                Swal.fire({icon: 'warning', title: 'Sin Stock', text: 'No hay stock disponible.', confirmButtonColor: '#464704'});
                return;
            }
            cart.push({
                id: id,
                tipo: tipo,
                desc: desc,
                precio: precio,
                cantidad: cantidadAgregada,
                permiteCantidad: permiteCantidad
            });
        } else {
            Swal.fire({icon: 'warning', title: 'Ya agregado', text: 'El ganado solo se puede vender por unidad.', confirmButtonColor: '#464704'});
            return;
        }
        renderCart();
    }

    function removeFromCart(index) {
        cart.splice(index, 1);
        renderCart();
    }

    function renderCart() {
        const container = document.getElementById('cartContainer');
        const emptyMsg = document.getElementById('emptyCartMsg');
        const hiddenInputs = document.getElementById('hiddenInputs');
        const totalDisplay = document.getElementById('cartTotalDisplay');
        const btnProcesar = document.getElementById('btnProcesar');
        
        container.innerHTML = '';
        hiddenInputs.innerHTML = '';
        let total = 0;

        if (cart.length === 0) {
            container.appendChild(emptyMsg);
            totalDisplay.innerText = '$ 0.00';
            btnProcesar.disabled = true;
            return;
        }

        cart.forEach((item, index) => {
            let sub = item.precio * item.cantidad;
            total += sub;

            // Render UI
            let div = document.createElement('div');
            div.className = 'cart-item';
            div.innerHTML = `
                <div class="cart-item-info">
                    <strong>\${item.desc}</strong>
                    <small>\${item.tipo} | $ \${item.precio.toLocaleString()} c/u</small>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="cart-item-qty">x\${item.cantidad}</span>
                    <button type="button" class="cart-item-remove" onclick="removeFromCart(\${index})">
                        <i class="bi bi-x-lg"></i>
                    </button>
                </div>
            `;
            container.appendChild(div);

            // Create Hidden Input for Form Submission: id|tipo|precio|cantidad|desc
            let input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'itemVenta';
            input.value = `\${item.id}|\${item.tipo}|\${item.precio}|\${item.cantidad}|\${item.desc}`;
            hiddenInputs.appendChild(input);
        });

        totalDisplay.innerText = '$ ' + total.toLocaleString();
        btnProcesar.disabled = false;
    }

    $(document).ready(function() {
        if (!$.fn.DataTable.isDataTable('#tableVentas')) {
            $('#tableVentas').DataTable({
                language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
                order: [[0, 'desc']]
            });
        }
        
        const urlParams = new URLSearchParams(window.location.search);
        if(urlParams.get('success') === '1') {
            Swal.fire({icon: 'success', title: '¡Venta Registrada!', text: 'La factura se guardó correctamente en el sistema.', confirmButtonColor: '#464704'});
        } else if (urlParams.get('error') === 'db') {
            Swal.fire({icon: 'error', title: 'Error', text: 'Ocurrió un problema al guardar la factura en la base de datos.', confirmButtonColor: '#464704'});
        } else if (urlParams.get('success') === 'cliente') {
            Swal.fire({icon: 'success', title: 'Cliente Creado', text: 'El cliente se guardó y ya está disponible para facturar.', confirmButtonColor: '#464704'});
        } else if (urlParams.get('error') === 'db_cliente') {
            Swal.fire({icon: 'error', title: 'Error', text: 'No se pudo guardar el cliente.', confirmButtonColor: '#464704'});
        }
    });
</script>

<jsp:include page="includes/footer.jsp" />
</body>
</html>
