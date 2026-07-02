<%@ page import="java.util.List" %>
<%@ page import="com.finca.models.ProductoLacteo" %>
<%@ page import="com.finca.models.Bovino" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<ProductoLacteo> productos = (List<ProductoLacteo>) request.getAttribute("productos");
    List<Bovino> bovinosVenta = (List<Bovino>) request.getAttribute("bovinosVenta");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="includes/header.jsp" />
    <title>Catálogo de Productos | Finca La Rosa</title>
    <style>
        body { background: linear-gradient(135deg, #F3F5E7 0%, #e0e5d1 100%) !important; }
        html[data-theme="dark"] body { background: linear-gradient(135deg, #09090b 0%, #18181b 100%) !important; }
        
        .product-card {
            background: var(--bg-card); border-radius: 20px; padding: 20px;
            border: 1px solid var(--border-subtle); box-shadow: 0 10px 25px rgba(66, 57, 38, 0.05);
            transition: transform 0.3s, border-color 0.3s;
            display: flex; flex-direction: column; align-items: center; text-align: center; height: 100%;
        }
        .product-card:hover { transform: translateY(-5px); border-color: var(--brand-accent); }
        html[data-theme="dark"] .product-card { background: rgba(24, 24, 27, 0.7); backdrop-filter: blur(12px); border-color: rgba(255, 255, 255, 0.1); }
        
        .product-icon { width: 80px; height: 80px; border-radius: 50%; background: var(--sage); color: var(--moss); display: flex; justify-content: center; align-items: center; font-size: 2.5rem; margin-bottom: 15px; }
        
        .btn-brand { background-color: var(--brand-primary) !important; color: white !important; border: none; font-weight: 700; border-radius: 12px; transition: all 0.2s ease; width: 100%; }
        .btn-brand:hover { background-color: var(--brand-dark) !important; transform: translateY(-2px); box-shadow: 0 8px 15px rgba(66, 57, 38, 0.2); }
        
        .cart-sidebar { position: fixed; top: 0; right: -400px; width: 350px; height: 100vh; background: var(--bg-card); box-shadow: -5px 0 25px rgba(0,0,0,0.1); transition: right 0.3s ease; z-index: 1050; padding: 20px; display: flex; flex-direction: column; }
        .cart-sidebar.open { right: 0; }
        html[data-theme="dark"] .cart-sidebar { background: #18181b; }
        
        .cart-overlay { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); z-index: 1040; display: none; }
        .cart-overlay.show { display: block; }
        
        .cart-item { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-subtle); padding-bottom: 10px; margin-bottom: 10px; }
        .cart-item h6 { margin: 0; font-weight: 700; color: var(--text-heading); }
        .cart-item span { color: var(--brand-primary); font-weight: 700; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container-fluid px-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom" style="border-color: var(--border-subtle) !important;">
        <div>
            <h3 class="fw-bolder mb-0" style="color: var(--brand-dark);">Catálogo Exclusivo</h3>
            <span class="fw-bold" style="font-size: 0.9rem; color: var(--text-subtle);">Haz tu pedido de los mejores productos lácteos</span>
        </div>
        <div>
            <button class="btn btn-outline-brand fw-bold px-4" onclick="toggleCart()" style="border: 2px solid var(--brand-accent); border-radius: 12px; color: var(--brand-dark); background: transparent;">
                <i class="bi bi-cart3 me-2"></i> Mi Carrito <span id="cartCount" class="badge bg-brand ms-1" style="background: var(--brand-primary);">0</span>
            </button>
        </div>
    </div>

    <div class="row g-4">
        <% 
            if (productos != null && !productos.isEmpty()) {
                for (ProductoLacteo p : productos) {
                    if ("LAC-001".equals(p.getCodigo()) || p.getStock() <= 0) continue; // Saltar materia prima y sin stock
        %>
        <div class="col-md-4 col-lg-3">
            <div class="product-card">
                <div class="product-icon"><i class="bi bi-box-seam"></i></div>
                <h5 class="fw-bolder mb-1" style="color: var(--text-heading);"><%= p.getNombre() %></h5>
                <p class="mb-3 text-muted" style="font-size: 0.85rem;"><%= p.getDescripcion() %></p>
                <h4 class="fw-bolder mb-3" style="color: var(--brand-primary);">$<%= String.format("%,.0f", p.getPrecioUnitario()) %></h4>
                <div class="mt-auto w-100">
                    <button class="btn btn-brand" onclick="addToCart(<%= p.getIdProducto() %>, '<%= p.getNombre() %>', <%= p.getPrecioUnitario() %>, 'Lacteo')">
                        <i class="bi bi-cart-plus me-1"></i> Agregar
                    </button>
                </div>
            </div>
        </div>
        <% 
                }
            } else { 
        %>
        <div class="col-12 text-center py-5">
            <h5 class="text-muted">No hay productos lácteos disponibles en este momento.</h5>
        </div>
        <% } %>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-4 mt-5 pb-2 border-bottom" style="border-color: var(--border-subtle) !important;">
        <div>
            <h3 class="fw-bolder mb-0" style="color: var(--brand-dark);">Ganado en Venta</h3>
            <span class="fw-bold" style="font-size: 0.9rem; color: var(--text-subtle);">Explora nuestros mejores ejemplares disponibles</span>
        </div>
    </div>

    <div class="row g-4">
        <% 
            if (bovinosVenta != null && !bovinosVenta.isEmpty()) {
                for (Bovino b : bovinosVenta) {
        %>
        <div class="col-md-4 col-lg-3">
            <div class="product-card">
                <% if (b.getImageUrl() != null && !b.getImageUrl().isEmpty()) { %>
                <div style="width: 100%; height: 140px; border-radius: 12px; background-image: url('<%= b.getImageUrl() %>'); background-size: cover; background-position: center; margin-bottom: 15px;"></div>
                <% } else { %>
                <div class="product-icon" style="background: rgba(181, 101, 29, 0.2); color: #B5651D;"><i class="bi bi-github"></i></div>
                <% } %>
                <h5 class="fw-bolder mb-1" style="color: var(--text-heading);">Arete: <%= b.getNumeroArete() %></h5>
                <p class="mb-3 text-muted" style="font-size: 0.85rem;">
                    Raza: <%= b.getRaza() %><br>
                    Peso: <%= b.getPesoKg() %> kg<br>
                    Propósito: <%= b.getProposito() %>
                </p>
                <h4 class="fw-bolder mb-3" style="color: var(--brand-primary);">$<%= String.format("%,.0f", b.getPrecioEstimado()) %></h4>
                <div class="mt-auto w-100">
                    <button class="btn btn-brand" style="background-color: #B5651D !important;" onclick="addToCart(<%= b.getIdBovino() %>, 'Bovino <%= b.getNumeroArete() %>', <%= b.getPrecioEstimado() %>, 'Ganado')">
                        <i class="bi bi-cart-plus me-1"></i> Comprar
                    </button>
                </div>
            </div>
        </div>
        <% 
                }
            } else { 
        %>
        <div class="col-12 text-center py-5">
            <h5 class="text-muted">No hay ganado en venta en este momento.</h5>
        </div>
        <% } %>
    </div>
</div>

<!-- Sidebar del Carrito -->
<div class="cart-overlay" id="cartOverlay" onclick="toggleCart()"></div>
<div class="cart-sidebar" id="cartSidebar">
    <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
        <h4 class="fw-bolder m-0" style="color: var(--brand-dark);">Tu Pedido</h4>
        <button class="btn border-0 p-0 fs-4" onclick="toggleCart()"><i class="bi bi-x" style="color: var(--text-main);"></i></button>
    </div>
    
    <div id="cartItems" class="flex-grow-1" style="overflow-y: auto;">
        <p class="text-muted text-center mt-5" id="emptyCartMsg">Tu carrito está vacío.</p>
    </div>
    
    <div class="border-top pt-3 mt-3">
        <div class="d-flex justify-content-between mb-3">
            <h5 class="fw-bold m-0" style="color: var(--text-main);">Total:</h5>
            <h5 class="fw-bolder m-0" style="color: var(--brand-primary);" id="cartTotal">$0</h5>
        </div>
        <button class="btn btn-brand w-100 fs-5" id="btnCheckout" onclick="checkout()" disabled>
            Confirmar Pedido <i class="bi bi-check2-circle ms-1"></i>
        </button>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    let cart = [];

    function toggleCart() {
        document.getElementById('cartSidebar').classList.toggle('open');
        document.getElementById('cartOverlay').classList.toggle('show');
    }

    function addToCart(id, name, price, tipo) {
        let item = cart.find(i => i.idProducto === id && i.tipo === tipo);
        if (item) {
            item.cantidad++;
            item.subtotal = item.cantidad * item.precio;
        } else {
            cart.push({ idProducto: id, nombre: name, precio: price, cantidad: 1, subtotal: price, tipo: tipo });
        }
        updateCartUI();
        Swal.fire({ toast: true, position: 'top-end', icon: 'success', title: 'Añadido al carrito', showConfirmButton: false, timer: 1500 });
    }

    function updateCartUI() {
        const container = document.getElementById('cartItems');
        const emptyMsg = document.getElementById('emptyCartMsg');
        const btnCheckout = document.getElementById('btnCheckout');
        let total = 0;
        
        container.innerHTML = '';
        
        if (cart.length === 0) {
            container.innerHTML = '<p class="text-muted text-center mt-5">Tu carrito está vacío.</p>';
            document.getElementById('cartTotal').innerText = '$0';
            document.getElementById('cartCount').innerText = '0';
            btnCheckout.disabled = true;
            return;
        }

        btnCheckout.disabled = false;
        
        cart.forEach((item, index) => {
            total += item.subtotal;
            
            let qtyControls = '';
            if (item.tipo === 'Ganado') {
                qtyControls = '<span class="fw-bold">' + item.cantidad + '</span> (Único)';
            } else {
                qtyControls = 
                    '<button class="btn btn-sm btn-outline-secondary py-0 px-2" onclick="changeQty(' + index + ', -1)">-</button> ' +
                    '<span class="fw-bold px-2">' + item.cantidad + '</span> ' +
                    '<button class="btn btn-sm btn-outline-secondary py-0 px-2" onclick="changeQty(' + index + ', 1)">+</button>';
            }

            container.innerHTML += 
                '<div class="cart-item">' +
                    '<div>' +
                        '<h6>' + item.nombre + '</h6>' +
                        '<div class="d-flex align-items-center gap-2 mt-1">' +
                            qtyControls +
                            '<small class="text-muted ms-2">x $' + item.precio.toLocaleString() + '</small>' +
                        '</div>' +
                    '</div>' +
                    '<div class="d-flex align-items-center gap-2">' +
                        '<span class="fw-bolder" style="color: var(--brand-primary);">$' + item.subtotal.toLocaleString() + '</span>' +
                        '<button class="btn btn-sm btn-outline-danger border-0 p-1" onclick="removeFromCart(' + index + ')"><i class="bi bi-trash"></i></button>' +
                    '</div>' +
                '</div>';
        });
        
        document.getElementById('cartTotal').innerText = '$' + total.toLocaleString();
        document.getElementById('cartCount').innerText = cart.length;
    }

    function changeQty(index, delta) {
        let item = cart[index];
        if (item.tipo === 'Ganado') return; // Ganado solo 1

        item.cantidad += delta;
        if (item.cantidad < 1) {
            item.cantidad = 1;
        }
        item.subtotal = item.cantidad * item.precio;
        updateCartUI();
    }

    function removeFromCart(index) {
        cart.splice(index, 1);
        updateCartUI();
    }

    function checkout() {
        if (cart.length === 0) return;
        
        const btnCheck = document.getElementById('btnCheckout');
        btnCheck.disabled = true;
        btnCheck.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Procesando...';
        
        const total = cart.reduce((acc, item) => acc + item.subtotal, 0);
        
        fetch('catalogo?action=checkout', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ items: cart, total: total })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                Swal.fire('¡Pedido Recibido!', 'Tu orden está en estado pendiente y será procesada pronto.', 'success').then(() => {
                    cart = [];
                    updateCartUI();
                    toggleCart();
                });
            } else {
                Swal.fire('Error', data.message, 'error');
            }
        })
        .catch(err => {
            Swal.fire('Error', 'Fallo de conexión.', 'error');
        })
        .finally(() => {
            btnCheck.disabled = false;
            btnCheck.innerHTML = 'Confirmar Pedido <i class="bi bi-check2-circle ms-1"></i>';
        });
    }
</script>
</body>
</html>
