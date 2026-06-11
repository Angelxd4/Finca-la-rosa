<%@ page import="com.finca.models.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 🔒 SEGURIDAD: Verificamos si el usuario realmente inició sesión
    Usuario usuarioActual = (Usuario) session.getAttribute("usuarioLogueado");
    
    if (usuarioActual == null) {
        response.sendRedirect("login");
        return; 
    }
%>

<style>
    :root {
        /* PALETA FINCA LA ROSA (DARK MOSS GREEN & EARTH TONES) */
        --moss: #464704 !important;       /* Dark Moss Green */
        --sage: #9CA889 !important;       /* Sage */
        --khaki: #B7A78C !important;      /* Khaki */
        --drab: #423926 !important;       /* Drab Dark Brown */
        --ivory: #F3F5E7 !important;      /* Ivory */
        --border-subtle: #E2E4D5 !important; /* Borde muy sutil para limpiar el diseño */
        --sidebar-width: 270px;
    }

    @media (min-width: 992px) {
        body {
            padding-left: calc(var(--sidebar-width) + 40px) !important;
            padding-top: 20px !important;
            padding-right: 20px !important;
            background-color: var(--ivory) !important;
        }
    }

    .sidebar-finca {
        position: fixed; top: 20px; left: 20px; width: var(--sidebar-width); height: calc(100vh - 40px);
        background: #FFFFFF; border: 1px solid var(--border-subtle); border-radius: 28px;
        box-shadow: 0 15px 35px rgba(70, 71, 4, 0.08); display: flex; flex-direction: column; padding: 24px 20px; z-index: 1040; transition: transform 0.3s ease;
    }

    .sidebar-header { display: flex; align-items: center; gap: 12px; padding-bottom: 20px; border-bottom: 1px solid var(--border-subtle); margin-bottom: 15px; }
    
    .sidebar-logo { 
        background: var(--moss); 
        color: var(--ivory); width: 40px; height: 40px; border-radius: 12px; 
        display: flex; justify-content: center; align-items: center; font-size: 1.2rem; box-shadow: 0 5px 15px rgba(70, 71, 4, 0.2); 
    }
    
    .sidebar-brand-text { font-weight: 800; color: var(--moss); font-size: 1.15rem; letter-spacing: -0.5px; line-height: 1.2; }

    .sidebar-nav { flex: 1; overflow-y: auto; scrollbar-width: none; }
    .sidebar-nav::-webkit-scrollbar { display: none; }
    
    .sidebar-link { 
        display: flex; align-items: center; gap: 12px; color: var(--drab); text-decoration: none; 
        padding: 12px 16px; border-radius: 14px; font-weight: 700; font-size: 0.95rem; margin-bottom: 5px; transition: all 0.3s ease; 
    }
    .sidebar-link i { font-size: 1.2rem; transition: transform 0.3s ease; color: var(--sage); }
    
    .sidebar-link:hover { background-color: var(--ivory); color: var(--moss); }
    .sidebar-link:hover i { transform: scale(1.1); color: var(--moss); }
    
    .sidebar-link.active-page { background-color: var(--sage); color: var(--moss); font-weight: 800; border: none; box-shadow: 0 4px 10px rgba(156, 168, 137, 0.3); }
    .sidebar-link.active-page i { color: var(--moss); }

    .sidebar-footer { padding-top: 15px; border-top: 1px solid var(--border-subtle); display: flex; flex-direction: column; gap: 10px; }
    .live-clock { background: var(--ivory); color: var(--moss); padding: 10px 15px; border-radius: 14px; font-weight: 800; font-size: 0.85rem; display: flex; align-items: center; justify-content: center; gap: 8px; border: 1px solid var(--border-subtle); }
    .user-profile { display: flex; align-items: center; gap: 12px; padding: 10px; background: white; border-radius: 16px; border: 1px solid var(--border-subtle); }
    .user-avatar { background: var(--khaki); color: var(--drab); width: 38px; height: 38px; border-radius: 12px; display: flex; justify-content: center; align-items: center; font-size: 1.2rem; font-weight: bold; }
    .user-info { flex: 1; overflow: hidden; }
    .user-name { font-weight: 800; font-size: 0.85rem; color: var(--moss); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: block; }
    .user-role { font-size: 0.7rem; color: var(--drab); font-weight: 700; }
    .btn-logout-side { color: #dc3545; background: rgba(220, 53, 69, 0.1); width: 35px; height: 35px; border-radius: 10px; display: flex; justify-content: center; align-items: center; text-decoration: none; transition: all 0.3s ease; }
    .btn-logout-side:hover { background: #dc3545; color: white; transform: scale(1.05); }

    .mobile-header { display: none; }
    @media (max-width: 991px) {
        .sidebar-finca { transform: translateX(-120%); border-radius: 0 28px 28px 0; top: 0; left: 0; height: 100vh; box-shadow: 20px 0 50px rgba(70, 71, 4, 0.3); }
        .sidebar-finca.show-mobile { transform: translateX(0); }
        .mobile-header { display: flex; justify-content: space-between; align-items: center; background: #FFFFFF; border-bottom: 1px solid var(--border-subtle); padding: 15px 20px; position: fixed; top: 0; left: 0; width: 100%; z-index: 1030; box-shadow: 0 4px 15px rgba(70, 71, 4, 0.05); }
        body { padding-top: 80px !important; padding-left: 15px !important; padding-right: 15px !important; }
        .sidebar-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(66, 57, 38, 0.6); backdrop-filter: blur(3px); z-index: 1035; display: none; }
        .sidebar-overlay.show { display: block; }
    }
</style>

<div class="mobile-header">
    <div class="d-flex align-items-center gap-2">
        <div class="sidebar-logo" style="width: 35px; height: 35px; font-size: 1rem;"><i class="bi bi-moisture"></i></div>
        <span class="sidebar-brand-text fs-5">La Rosa</span>
    </div>
    <button class="btn border-0 p-0 fs-1 text-dark" onclick="toggleSidebar()"><i class="bi bi-list" style="color: var(--moss);"></i></button>
</div>

<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<aside class="sidebar-finca" id="mainSidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo"><i class="bi bi-moisture"></i></div>
        <div>
            <span class="sidebar-brand-text d-block">Finca La Rosa</span>
            <span style="font-size: 10px; color: var(--drab); font-weight: 800; letter-spacing: 0.5px;">SISTEMA GANADERO</span>
        </div>
        <button class="btn border-0 p-0 fs-3 d-lg-none ms-auto" onclick="toggleSidebar()"><i class="bi bi-x" style="color: var(--moss);"></i></button>
    </div>

    <nav class="sidebar-nav">
        <a href="dashboard" class="sidebar-link nav-auto-active"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a>
        
        <div class="mt-3 mb-2 px-3 text-uppercase fw-bold" style="font-size: 10px; color: var(--moss); opacity: 0.6; letter-spacing: 1px;">Gestión Animal</div>
        <a href="inventario-ganado" class="sidebar-link nav-auto-active"><i class="bi bi-clipboard2-data-fill"></i> Inventario Bovino</a>
        
        <div class="mt-3 mb-2 px-3 text-uppercase fw-bold" style="font-size: 10px; color: var(--moss); opacity: 0.6; letter-spacing: 1px;">Lechería y Fábrica</div>
        <a href="produccion" class="sidebar-link nav-auto-active"><i class="bi bi-droplet-half"></i> Producción / Ordeño</a>
        <a href="lacteos" class="sidebar-link nav-auto-active"><i class="bi bi-shop"></i> Fábrica de Lácteos</a>
        
        <div class="mt-3 mb-2 px-3 text-uppercase fw-bold" style="font-size: 10px; color: var(--moss); opacity: 0.6; letter-spacing: 1px;">Administración</div>
        <a href="kanban" class="sidebar-link nav-auto-active"><i class="bi bi-kanban"></i> Tablero de Tareas</a>
        <a href="empleados" class="sidebar-link nav-auto-active"><i class="bi bi-people-fill"></i> Personal</a>
    </nav>

    <div class="sidebar-footer">
        <div class="live-clock" title="Hora actual de la Finca"><i class="bi bi-clock-history"></i> <span id="systemClock">00:00:00 AM</span></div>
        <div class="user-profile">
            <div class="user-avatar"><%= usuarioActual.getFullName().substring(0, 1).toUpperCase() %></div>
            <div class="user-info">
                <span class="user-name" title="<%= usuarioActual.getFullName() %>"><%= usuarioActual.getFullName() %></span>
                <span class="user-role"><%= usuarioActual.getRol() %></span>
            </div>
            <a href="logout" class="btn-logout-side" title="Cerrar Sesión"><i class="bi bi-box-arrow-right"></i></a>
        </div>
    </div>
</aside>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        let currentPath = window.location.pathname;
        let navLinks = document.querySelectorAll('.nav-auto-active');
        navLinks.forEach(link => {
            let linkHref = link.getAttribute('href');
            if (linkHref && currentPath.includes(linkHref)) { link.classList.add('active-page'); }
        });

        function updateClock() {
            const now = new Date();
            let hours = now.getHours(); let minutes = now.getMinutes(); let seconds = now.getSeconds();
            let ampm = hours >= 12 ? 'PM' : 'AM';
            hours = hours % 12; hours = hours ? hours : 12; 
            hours = hours < 10 ? '0' + hours : hours; minutes = minutes < 10 ? '0' + minutes : minutes; seconds = seconds < 10 ? '0' + seconds : seconds;
            const timeString = hours + ':' + minutes + ':' + seconds + ' ' + ampm;
            document.getElementById('systemClock').textContent = timeString;
        }
        updateClock(); setInterval(updateClock, 1000);
    });

    function toggleSidebar() {
        const sidebar = document.getElementById('mainSidebar');
        const overlay = document.getElementById('sidebarOverlay');
        sidebar.classList.toggle('show-mobile');
        overlay.classList.toggle('show');
    }
</script>