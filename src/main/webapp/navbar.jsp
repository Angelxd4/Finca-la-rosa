<%@ page import="com.finca.models.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 🔒 SEGURIDAD: Verificamos si el usuario realmente inició sesión
    Usuario usuarioActual = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuarioActual == null) {
        response.sendRedirect("login");
        return;
    }

    // =========================================================
    // TRADUCTOR DE ROL Y LÓGICA DE FOTO PARA EL NAVBAR
    // =========================================================
    String navRolTexto = "Desconocido";
    String rNav = usuarioActual.getRol() != null ? usuarioActual.getRol() : "";
    
    if(rNav.equals("1") || rNav.equalsIgnoreCase("Administrador")) navRolTexto = "Administrador";
    else if(rNav.equals("2") || rNav.equalsIgnoreCase("Veterinario")) navRolTexto = "Veterinario";
    else if(rNav.equals("3") || rNav.equalsIgnoreCase("Operario")) navRolTexto = "Operario (Vaquero)";
    else if(rNav.equals("4") || rNav.equalsIgnoreCase("Vendedor")) navRolTexto = "Vendedor";
    else if(rNav.equals("5") || rNav.equalsIgnoreCase("Cliente")) navRolTexto = "Cliente";
    else navRolTexto = rNav;

    String navInicial = usuarioActual.getFullName() != null && !usuarioActual.getFullName().isEmpty() 
                        ? usuarioActual.getFullName().substring(0, 1).toUpperCase() 
                        : "U";
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
        --text-subtle: #7A8068 !important;   /* Texto sutil agregado */
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
    
    /* ========================================= */
    /* ESTILOS PARA WIDGET DE CLIMA Y FECHA */
    /* ========================================= */
    .weather-widget { background: var(--ivory); border-radius: 14px; padding: 12px; border: 1px solid var(--border-subtle); display: flex; flex-direction: column; gap: 4px; }
    .weather-location { font-size: 0.7rem; font-weight: 800; color: var(--sage); text-transform: uppercase; letter-spacing: 0.5px; }
    .weather-date { font-size: 0.85rem; font-weight: 700; color: var(--drab); text-transform: capitalize; }
    .weather-temp { font-size: 0.95rem; font-weight: 800; color: var(--moss); display: flex; align-items: center; gap: 6px; margin-top: 2px; }
    .weather-temp i { font-size: 1.2rem; }

    .live-clock { background: #FFFFFF; color: var(--drab); padding: 8px 15px; border-radius: 12px; font-weight: 700; font-size: 0.8rem; display: flex; align-items: center; justify-content: center; gap: 8px; border: 1px dashed var(--border-subtle); margin-top: -2px; }
    
    .user-profile { display: flex; align-items: center; gap: 12px; padding: 10px; background: white; border-radius: 16px; border: 1px solid var(--border-subtle); }
    .user-avatar { background: var(--khaki); color: var(--drab); width: 38px; height: 38px; border-radius: 12px; display: flex; justify-content: center; align-items: center; font-size: 1.2rem; font-weight: bold; overflow: hidden; }
    .user-avatar img { width: 100%; height: 100%; object-fit: cover; }
    
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
    <div class="d-flex align-items-center gap-3">
        <div class="dropdown">
            <a href="#" class="text-decoration-none position-relative" id="notiDropdownMobile" data-bs-toggle="dropdown" aria-expanded="false" style="color: var(--moss); font-size: 1.25rem;">
                <i class="bi bi-bell-fill"></i>
                <span id="notiBadgeMobile" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.55rem; padding: 0.35em 0.5em; display: none; border: 2px solid #fff;">0</span>
            </a>
            <ul class="dropdown-menu dropdown-menu-end shadow border-0" aria-labelledby="notiDropdownMobile" style="width: 300px; max-height: 400px; overflow-y: auto; border-radius: 15px; padding: 0; margin-top: 10px; z-index: 9999;">
                <li class="p-3 border-bottom d-flex justify-content-between align-items-center" style="background: #fafafa; position: sticky; top: 0; z-index: 10; border-radius: 15px 15px 0 0;">
                    <span class="fw-bold" style="color: var(--moss); font-size: 0.95rem;"><i class="bi bi-bell me-1"></i> Notificaciones</span>
                    <button class="btn btn-sm btn-link text-decoration-none p-0 fw-bold" style="font-size: 0.8rem; color: var(--brand-info);" onclick="marcarNotificacionesLeidas()">Marcar Leídas</button>
                </li>
                <div id="notiListMobile">
                    <li class="p-4 text-center text-muted" style="font-size: 0.85rem;"><div class="spinner-border spinner-border-sm me-2"></div>Cargando...</li>
                </div>
            </ul>
        </div>
        <button class="btn border-0 p-0 fs-1 text-dark" onclick="toggleSidebar()"><i class="bi bi-list" style="color: var(--moss);"></i></button>
    </div>
</div>

<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<aside class="sidebar-finca" id="mainSidebar">
    <div class="sidebar-header align-items-center">
        <div class="sidebar-logo"><i class="bi bi-flower1"></i></div>
        <div>
            <span class="sidebar-brand-text d-block">Finca La Rosa</span>
            <span style="font-size: 10px; color: var(--drab); font-weight: 800; letter-spacing: 0.5px;">SISTEMA GANADERO</span>
        </div>
        
        <div class="dropdown ms-auto me-2 d-none d-lg-block">
            <a href="#" class="text-decoration-none position-relative" id="notiDropdown" data-bs-toggle="dropdown" aria-expanded="false" style="color: var(--moss); font-size: 1.25rem;">
                <i class="bi bi-bell-fill"></i>
                <span id="notiBadge" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.55rem; padding: 0.35em 0.5em; display: none; border: 2px solid #fff;">0</span>
            </a>
            <ul class="dropdown-menu dropdown-menu-end shadow border-0" aria-labelledby="notiDropdown" style="width: 320px; max-height: 400px; overflow-y: auto; border-radius: 15px; padding: 0; margin-top: 10px;">
                <li class="p-3 border-bottom d-flex justify-content-between align-items-center" style="background: #fafafa; position: sticky; top: 0; z-index: 10; border-radius: 15px 15px 0 0;">
                    <span class="fw-bold" style="color: var(--moss); font-size: 0.95rem;"><i class="bi bi-bell me-1"></i> Notificaciones</span>
                    <button class="btn btn-sm btn-link text-decoration-none p-0 fw-bold" style="font-size: 0.8rem; color: var(--brand-info);" onclick="marcarNotificacionesLeidas()">Marcar Leídas</button>
                </li>
                <div id="notiList">
                    <li class="p-4 text-center text-muted" style="font-size: 0.85rem;"><div class="spinner-border spinner-border-sm me-2"></div>Cargando...</li>
                </div>
            </ul>
        </div>
        
        <button class="btn border-0 p-0 fs-3 d-lg-none ms-auto" onclick="toggleSidebar()"><i class="bi bi-x" style="color: var(--moss);"></i></button>
    </div>

    <nav class="sidebar-nav">
        <a href="dashboard" class="sidebar-link nav-auto-active"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a>
        
        <div class="mt-3 mb-2 px-3 text-uppercase fw-bold" style="font-size: 10px; color: var(--moss); opacity: 0.6; letter-spacing: 1px;">Gestión Animal</div>
        <a href="inventario-ganado" class="sidebar-link nav-auto-active"><i class="bi bi-clipboard2-data-fill"></i> Inventario Bovino</a>
        
        <% if (!"2".equals(rNav) && !"Veterinario".equalsIgnoreCase(rNav)) { %>
        <div class="mt-3 mb-2 px-3 text-uppercase fw-bold" style="font-size: 10px; color: var(--moss); opacity: 0.6; letter-spacing: 1px;">Lechería y Fábrica</div>
        <a href="produccion" class="sidebar-link nav-auto-active"><i class="bi bi-droplet-half"></i> Producción / Ordeño</a>
        <a href="lacteos" class="sidebar-link nav-auto-active"><i class="bi bi-shop"></i> Fábrica de Lácteos</a>
        <% } %>
        
        <div class="mt-3 mb-2 px-3 text-uppercase fw-bold" style="font-size: 10px; color: var(--moss); opacity: 0.6; letter-spacing: 1px;">Administración</div>
        <a href="kanban" class="sidebar-link nav-auto-active"><i class="bi bi-kanban"></i> Tablero de Tareas</a>
        
        <%-- 🛡️ BLINDAJE ANTI-ESPACIOS: SOLAMENTE EL ADMINISTRADOR PUEDE VER EL BOTÓN DE PERSONAL --%>
        <% 
            String rolMenuSeguro = (rNav != null) ? rNav.trim().toLowerCase() : "";
            if (rolMenuSeguro.equals("1") || rolMenuSeguro.contains("admin")) { 
        %>
        <a href="empleados" class="sidebar-link nav-auto-active"><i class="bi bi-people-fill"></i> Personal</a>
        <a href="asistencias" class="sidebar-link nav-auto-active"><i class="bi bi-calendar2-check-fill"></i> Asistencias</a>
        <% } %>
    </nav>

    <div class="sidebar-footer">
        
        <div class="weather-widget" title="Clima en vivo por nombre de municipio">
            <div class="weather-location"><i class="bi bi-geo-alt-fill me-1"></i> Sta. Rosa de Viterbo, Boyacá</div>
            <div class="weather-date" id="systemDate">Cargando fecha...</div>
            <div class="weather-temp" id="systemWeather">
                <i class="bi bi-hourglass-split"></i> <span style="font-size:0.8rem; color:var(--text-subtle);">Buscando estación...</span>
            </div>
        </div>

        <div class="live-clock" title="Hora actual de la Finca (Colombia)"><i class="bi bi-clock"></i> <span id="systemClock">00:00:00 AM</span></div>
        
        <div class="user-profile">
            <a href="perfil" style="text-decoration: none;">
                <div class="user-avatar" title="Ir a mi perfil">
                    <% if(usuarioActual.getProfilePicture() != null && !usuarioActual.getProfilePicture().isEmpty()) { %>
                        <img src="uploads/<%= usuarioActual.getProfilePicture() %>" alt="Foto Perfil">
                    <% } else { %>
                        <%= navInicial %>
                    <% } %>
                </div>
            </a>
            
            <div class="user-info">
                <span class="user-name" title="<%= usuarioActual.getFullName() %>"><%= usuarioActual.getFullName() %></span>
                <span class="user-role"><%= navRolTexto %></span>
            </div>
            <a href="logout" class="btn-logout-side" title="Cerrar Sesión"><i class="bi bi-box-arrow-right"></i></a>
        </div>
    </div>
</aside>

<script>
    // 1. LÓGICA DE NAVEGACIÓN ACTIVA
    let currentPath = window.location.pathname;
    let navLinks = document.querySelectorAll('.nav-auto-active');
    navLinks.forEach(link => {
        let linkHref = link.getAttribute('href');
        if (linkHref && currentPath.includes(linkHref)) { link.classList.add('active-page'); }
    });

    // 2. LÓGICA DE RELOJ Y FECHA FORZADA A HORA DE COLOMBIA
    function updateDateTime() {
        const now = new Date();
        const optionsTime = { timeZone: 'America/Bogota', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true };
        const optionsDate = { timeZone: 'America/Bogota', weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        
        let clockEl = document.getElementById('systemClock');
        if (clockEl) {
            clockEl.textContent = now.toLocaleTimeString('es-CO', optionsTime).toUpperCase();
        }

        let dateEl = document.getElementById('systemDate');
        if (dateEl) {
            dateEl.textContent = now.toLocaleDateString('es-CO', optionsDate);
        }
    }
    
    // 3. NUEVA API DEL CLIMA (Open-Meteo con coordenadas exactas de Santa Rosa de Viterbo, Boyacá)
    function fetchWeather() {
        const url = 'https://api.open-meteo.com/v1/forecast?latitude=5.8852&longitude=-73.0134&current=temperature_2m,weather_code';
        fetch(url, { cache: 'no-store' })
        .then(function(response) {
            if (!response.ok) throw new Error("Estación meteorológica no respondió");
            return response.json();
        })
        .then(function(data) {
            if(data && data.current) {
                const temp = data.current.temperature_2m;
                const code = data.current.weather_code;
                
                let desc = "Despejado";
                let icon = "bi-sun-fill text-warning";

                if (code === 0) { desc = "Despejado"; icon = "bi-sun-fill text-warning"; }
                else if (code === 1 || code === 2) { desc = "Parc. Nublado"; icon = "bi-cloud-sun-fill text-warning"; }
                else if (code === 3) { desc = "Nublado"; icon = "bi-cloud-fill text-secondary"; }
                else if (code === 45 || code === 48) { desc = "Niebla"; icon = "bi-cloud-fog2-fill text-secondary"; }
                else if (code >= 51 && code <= 57) { desc = "Llovizna"; icon = "bi-cloud-drizzle-fill text-info"; }
                else if (code >= 61 && code <= 67) { desc = "Lluvia"; icon = "bi-cloud-rain-fill text-info"; }
                else if (code >= 80 && code <= 82) { desc = "Chubascos"; icon = "bi-cloud-rain-heavy-fill text-info"; }
                else if (code >= 95) { desc = "Tormenta"; icon = "bi-cloud-lightning-rain-fill text-danger"; }

                let weatherEl = document.getElementById('systemWeather');
                if (weatherEl) {
                    weatherEl.innerHTML = '<i class="bi ' + icon + '"></i> <span>' + temp + '°C - ' + desc + '</span>';
                }
            }
        })
        .catch(function(error) {
            console.error("⚠️ Error conectando con estación terrestre:", error);
            let weatherEl = document.getElementById('systemWeather');
            if (weatherEl) {
                weatherEl.innerHTML = '<i class="bi bi-cloud-slash text-secondary"></i> <span style="font-size:0.8rem;">Sin conexión</span>';
            }
        });
    }
    
    document.addEventListener("DOMContentLoaded", function() {
        // ACTUALIZAR FECHA Y HORA AL CARGAR Y CADA SEGUNDO
        updateDateTime();
        setInterval(updateDateTime, 1000);

        // OBTENER CLIMA AL CARGAR
        fetchWeather();
        
        // OBTENER NOTIFICACIONES AL CARGAR Y CADA 30 SEGUNDOS
        fetchNotificaciones();
        setInterval(fetchNotificaciones, 30000);
        
        setInterval(fetchWeather, 1800000); // 30 mins
    });

    // 4. LÓGICA DE NOTIFICACIONES
    function fetchNotificaciones() {
        const urlNoti = '<%= request.getContextPath() %>/NotificacionesServlet';
        fetch(urlNoti, { credentials: 'same-origin' })
            .then(res => {
                if(!res.ok) {
                    return res.text().then(text => { throw new Error(res.status + ": " + text); });
                }
                return res.json();
            })
            .then(data => {
                let badgeDesktop = document.getElementById('notiBadge');
                let badgeMobile = document.getElementById('notiBadgeMobile');
                
                if (data.noLeidas > 0) {
                    if (badgeDesktop) { badgeDesktop.textContent = data.noLeidas; badgeDesktop.style.display = 'inline-block'; }
                    if (badgeMobile) { badgeMobile.textContent = data.noLeidas; badgeMobile.style.display = 'inline-block'; }
                } else {
                    if (badgeDesktop) badgeDesktop.style.display = 'none';
                    if (badgeMobile) badgeMobile.style.display = 'none';
                }

                let listHTML = '';
                if (data.notificaciones && data.notificaciones.length > 0) {
                    data.notificaciones.forEach(n => {
                        let bgClass = n.leida ? 'bg-white' : 'bg-light';
                        let dot = n.leida ? '' : '<span class="position-absolute top-50 start-0 translate-middle p-1 bg-danger border border-light rounded-circle" style="margin-left: 15px;"></span>';
                        listHTML += `
                            <a href="<%= request.getContextPath() %>/\${n.link}" class="text-decoration-none border-bottom p-3 d-block text-dark \${bgClass} position-relative noti-item" style="transition: background 0.3s;">
                                \${dot}
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <strong style="font-size: 0.85rem; color: var(--brand-dark);">\${n.titulo}</strong>
                                    <small class="text-muted" style="font-size: 0.7rem;">\${n.tiempo}</small>
                                </div>
                                <div style="font-size: 0.8rem; color: #666; line-height: 1.3;">\${n.mensaje}</div>
                            </a>
                        `;
                    });
                } else {
                    listHTML = '<li class="p-4 text-center text-muted" style="font-size: 0.85rem;"><i class="bi bi-check2-circle d-block fs-3 mb-2 text-success"></i>Estás al día.<br>No tienes notificaciones.</li>';
                }
                
                let listDesktop = document.getElementById('notiList');
                let listMobile = document.getElementById('notiListMobile');
                if (listDesktop) listDesktop.innerHTML = listHTML;
                if (listMobile) listMobile.innerHTML = listHTML;
            })
            .catch(err => {
                console.error("Error al obtener notificaciones", err);
                let htmlErr = '<li class="p-4 text-center text-danger" style="font-size: 0.85rem;">No se pudieron cargar las notificaciones.</li>';
                let listDesktop = document.getElementById('notiList');
                let listMobile = document.getElementById('notiListMobile');
                if (listDesktop) listDesktop.innerHTML = htmlErr;
                if (listMobile) listMobile.innerHTML = htmlErr;
            });
    }

    function marcarNotificacionesLeidas() {
        fetch('<%= request.getContextPath() %>/NotificacionesServlet', {
            method: 'POST',
            credentials: 'same-origin',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=marcarLeidas'
        })
        .then(res => res.text())
        .then(data => {
            if(data === 'ok') {
                let badgeDesktop = document.getElementById('notiBadge');
                let badgeMobile = document.getElementById('notiBadgeMobile');
                if (badgeDesktop) badgeDesktop.style.display = 'none';
                if (badgeMobile) badgeMobile.style.display = 'none';
                fetchNotificaciones();
            }
        });
    }

    function toggleSidebar() {
        const sidebar = document.getElementById('mainSidebar');
        const overlay = document.getElementById('sidebarOverlay');
        sidebar.classList.toggle('show-mobile');
        overlay.classList.toggle('show');
    }
</script>