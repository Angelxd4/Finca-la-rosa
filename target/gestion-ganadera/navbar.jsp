<%@ page import="com.finca.models.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 🔒 SEGURIDAD: Verificamos si el usuario realmente inició sesión
    Usuario usuarioActual = (Usuario) session.getAttribute("usuarioLogueado");
    
    // Si es nulo, significa que intentó saltarse el login. ¡Lo pateamos de vuelta!
    if (usuarioActual == null) {
        response.sendRedirect("login");
        return; 
    }
%>

<style>
    :root {
        --brand-main: #1C7345;
        --brand-hover: #165c37;
        --brand-light: #eaf6ee;
        --sidebar-width: 270px;
    }

    /* =======================================================
       MAGIA CSS: Hacemos espacio en el body para la Sidebar 
       ======================================================= */
    @media (min-width: 992px) {
        body {
            padding-left: calc(var(--sidebar-width) + 40px) !important;
            padding-top: 20px !important;
            padding-right: 20px !important;
        }
    }

    /* --- ESTILOS DE LA SIDEBAR FLOTANTE --- */
    .sidebar-finca {
        position: fixed;
        top: 20px;
        left: 20px;
        width: var(--sidebar-width);
        height: calc(100vh - 40px);
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(24px) saturate(180%);
        -webkit-backdrop-filter: blur(24px) saturate(180%);
        border: 1px solid rgba(255, 255, 255, 0.8);
        border-radius: 28px;
        box-shadow: 0 15px 35px rgba(28, 115, 69, 0.08);
        display: flex;
        flex-direction: column;
        padding: 24px 20px;
        z-index: 1040;
        transition: transform 0.3s ease;
    }

    /* Cabecera / Logo */
    .sidebar-header {
        display: flex;
        align-items: center;
        gap: 12px;
        padding-bottom: 20px;
        border-bottom: 1px solid rgba(0,0,0,0.05);
        margin-bottom: 15px;
    }

    .sidebar-logo {
        background: linear-gradient(135deg, var(--brand-main), #00A859);
        color: white;
        width: 40px;
        height: 40px;
        border-radius: 12px;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 1.2rem;
        box-shadow: 0 5px 15px rgba(28, 115, 69, 0.3);
    }

    .sidebar-brand-text {
        font-weight: 800;
        color: #1d1d1f;
        font-size: 1.15rem;
        letter-spacing: -0.5px;
        line-height: 1.2;
    }

    /* Enlaces de Navegación */
    .sidebar-nav {
        flex: 1;
        overflow-y: auto;
        /* Ocultar scrollbar pero permitir scroll */
        scrollbar-width: none;
    }
    .sidebar-nav::-webkit-scrollbar { display: none; }

    .sidebar-link {
        display: flex;
        align-items: center;
        gap: 12px;
        color: #637068;
        text-decoration: none;
        padding: 12px 16px;
        border-radius: 14px;
        font-weight: 600;
        font-size: 0.95rem;
        margin-bottom: 5px;
        transition: all 0.3s ease;
    }

    .sidebar-link i {
        font-size: 1.2rem;
        transition: transform 0.3s ease;
    }

    .sidebar-link:hover {
        background-color: rgba(28, 115, 69, 0.05);
        color: var(--brand-main);
    }

    .sidebar-link:hover i {
        transform: scale(1.1);
    }

    /* Página Activa */
    .sidebar-link.active-page {
        background-color: var(--brand-light);
        color: var(--brand-main);
        font-weight: 700;
    }

    /* --- ZONA INFERIOR (RELOJ Y PERFIL) --- */
    .sidebar-footer {
        padding-top: 15px;
        border-top: 1px solid rgba(0,0,0,0.05);
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .live-clock {
        background: #f4f7f5;
        color: #4a5550;
        padding: 10px 15px;
        border-radius: 14px;
        font-weight: 700;
        font-size: 0.85rem;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        font-variant-numeric: tabular-nums;
        border: 1px solid #e2e8e4;
    }

    .user-profile {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 10px;
        background: white;
        border-radius: 16px;
        border: 1px solid #e2e8e4;
    }

    .user-avatar {
        background: var(--brand-light);
        color: var(--brand-main);
        width: 38px;
        height: 38px;
        border-radius: 12px;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 1.2rem;
        font-weight: bold;
    }

    .user-info {
        flex: 1;
        overflow: hidden;
    }
    
    .user-name {
        font-weight: 700;
        font-size: 0.85rem;
        color: #1d1d1f;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        display: block;
    }

    .user-role {
        font-size: 0.7rem;
        color: #848f9a;
        font-weight: 600;
    }

    .btn-logout-side {
        color: #dc3545;
        background: rgba(220, 53, 69, 0.1);
        width: 35px;
        height: 35px;
        border-radius: 10px;
        display: flex;
        justify-content: center;
        align-items: center;
        text-decoration: none;
        transition: all 0.3s ease;
    }

    .btn-logout-side:hover {
        background: #dc3545;
        color: white;
        transform: scale(1.05);
    }

    /* --- RESPONSIVIDAD PARA CELULARES --- */
    .mobile-header {
        display: none;
    }

    @media (max-width: 991px) {
        /* Ocultar barra lateral por defecto en móvil */
        .sidebar-finca {
            transform: translateX(-120%);
            border-radius: 0 28px 28px 0;
            top: 0;
            left: 0;
            height: 100vh;
            box-shadow: 20px 0 50px rgba(0,0,0,0.5);
        }

        /* Clase para mostrarla vía JS */
        .sidebar-finca.show-mobile {
            transform: translateX(0);
        }

        /* Mostrar cabecera móvil superior */
        .mobile-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 15px 20px;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1030;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        /* Espacio para que el contenido no quede debajo de la cabecera móvil */
        body {
            padding-top: 80px !important;
            padding-left: 15px !important;
            padding-right: 15px !important;
        }

        /* Fondo oscuro al abrir el menú en celular */
        .sidebar-overlay {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.4);
            backdrop-filter: blur(3px);
            z-index: 1035;
            display: none;
        }
        .sidebar-overlay.show { display: block; }
    }
</style>

<div class="mobile-header">
    <div class="d-flex align-items-center gap-2">
        <div class="sidebar-logo" style="width: 35px; height: 35px; font-size: 1rem;">
            <i class="bi bi-moisture"></i>
        </div>
        <span class="sidebar-brand-text fs-5">La Rosa</span>
    </div>
    <button class="btn border-0 p-0 fs-1 text-dark" onclick="toggleSidebar()">
        <i class="bi bi-list"></i>
    </button>
</div>

<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<aside class="sidebar-finca" id="mainSidebar">
    
    <div class="sidebar-header">
        <div class="sidebar-logo">
            <i class="bi bi-moisture"></i>
        </div>
        <div>
            <span class="sidebar-brand-text d-block">Finca La Rosa</span>
            <span style="font-size: 10px; color: #848f9a; font-weight: 700; letter-spacing: 0.5px;">SISTEMA GANADERO</span>
        </div>
        <button class="btn border-0 p-0 fs-3 text-secondary d-lg-none ms-auto" onclick="toggleSidebar()">
            <i class="bi bi-x"></i>
        </button>
    </div>

    <nav class="sidebar-nav">
        <a href="dashboard" class="sidebar-link nav-auto-active">
            <i class="bi bi-grid-1x2-fill"></i> Dashboard
        </a>
        
        <div class="mt-3 mb-2 px-3 text-uppercase fw-bold" style="font-size: 10px; color: #a0aba5; letter-spacing: 1px;">Gestión Animal</div>
        
        <a href="inventario-ganado" class="sidebar-link nav-auto-active">
            <i class="bi bi-clipboard2-data-fill"></i> Inventario Bovino
        </a>
        
        <div class="mt-3 mb-2 px-3 text-uppercase fw-bold" style="font-size: 10px; color: #a0aba5; letter-spacing: 1px;">Lechería y Fábrica</div>
        
        <a href="produccion" class="sidebar-link nav-auto-active">
            <i class="bi bi-droplet-half"></i> Producción / Ordeño
        </a>
        <a href="lacteos" class="sidebar-link nav-auto-active">
            <i class="bi bi-basket-fill"></i> Catálogo Lácteos
        </a>
        <a href="lotes-produccion" class="sidebar-link nav-auto-active">
            <i class="bi bi-gear-wide-connected"></i> Lotes de Fábrica
        </a>
        
        <div class="mt-3 mb-2 px-3 text-uppercase fw-bold" style="font-size: 10px; color: #a0aba5; letter-spacing: 1px;">Administración</div>
        
        <a href="kanban" class="sidebar-link nav-auto-active">
            <i class="bi bi-kanban"></i> Tablero de Tareas
        </a>
        <a href="empleados" class="sidebar-link nav-auto-active">
            <i class="bi bi-people-fill"></i> Personal
        </a>
    </nav>

    <div class="sidebar-footer">
        <div class="live-clock" title="Hora actual de la Finca">
            <i class="bi bi-clock-history"></i>
            <span id="systemClock">00:00:00 AM</span>
        </div>

        <div class="user-profile">
            <div class="user-avatar">
                <%= usuarioActual.getFullName().substring(0, 1).toUpperCase() %>
            </div>
            <div class="user-info">
                <span class="user-name" title="<%= usuarioActual.getFullName() %>"><%= usuarioActual.getFullName() %></span>
                <span class="user-role"><%= usuarioActual.getRol() %></span>
            </div>
            <a href="logout" class="btn-logout-side" title="Cerrar Sesión">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </div>
</aside>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // --- 1. LÓGICA DE PÁGINA ACTIVA INTACTA ---
        let currentPath = window.location.pathname;
        let navLinks = document.querySelectorAll('.nav-auto-active');
        
        navLinks.forEach(link => {
            let linkHref = link.getAttribute('href');
            if (linkHref && currentPath.includes(linkHref)) {
                link.classList.add('active-page');
            }
        });

        // --- 2. LÓGICA DEL RELOJ EN VIVO INTACTA ---
        function updateClock() {
            const now = new Date();
            let hours = now.getHours();
            let minutes = now.getMinutes();
            let seconds = now.getSeconds();
            let ampm = hours >= 12 ? 'PM' : 'AM';

            hours = hours % 12;
            hours = hours ? hours : 12; 

            hours = hours < 10 ? '0' + hours : hours;
            minutes = minutes < 10 ? '0' + minutes : minutes;
            seconds = seconds < 10 ? '0' + seconds : seconds;

            const timeString = hours + ':' + minutes + ':' + seconds + ' ' + ampm;
            document.getElementById('systemClock').textContent = timeString;
        }
        updateClock();
        setInterval(updateClock, 1000);
    });

    // --- 3. LÓGICA PARA EL MENÚ EN CELULARES ---
    function toggleSidebar() {
        const sidebar = document.getElementById('mainSidebar');
        const overlay = document.getElementById('sidebarOverlay');
        sidebar.classList.toggle('show-mobile');
        overlay.classList.toggle('show');
    }
</script>