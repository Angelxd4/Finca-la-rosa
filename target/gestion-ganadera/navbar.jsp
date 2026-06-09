<%@ page import="com.finca.models.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 🔒 SEGURIDAD: Verificamos si el usuario realmente inició sesión
    Usuario usuarioActual = (Usuario) session.getAttribute("usuarioLogueado");
    
    // Si es nulo, significa que intentó saltarse el login. ¡Lo pateamos de vuelta!
    if (usuarioActual == null) {
        response.sendRedirect("login");
        return; // Detiene la carga de la página
    }
%>

<style>
    /* --- ESTILOS APPLE GLASSMORPHISM PARA LA NAVBAR --- */
    .apple-navbar {
        background: rgba(255, 255, 255, 0.75);
        backdrop-filter: blur(24px) saturate(180%);
        -webkit-backdrop-filter: blur(24px) saturate(180%);
        border: 1px solid rgba(255, 255, 255, 0.6);
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
        padding: 12px 24px;
        margin: 20px auto 30px auto;
        width: 96%;
        z-index: 1000;
    }
    
    .apple-navbar .navbar-brand {
        color: #2F855A !important;
        font-weight: 800;
        font-size: 1.3rem;
        letter-spacing: -0.5px;
    }

    .apple-navbar .nav-link {
        color: #1d1d1f !important;
        font-weight: 600;
        border-radius: 12px;
        padding: 8px 16px !important;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        margin: 0 4px;
    }

    /* Efecto al pasar el mouse */
    .apple-navbar .nav-link:hover {
        background: rgba(47, 133, 90, 0.08);
        color: #2F855A !important;
        transform: translateY(-1px);
    }

    /* Efecto cuando la página está activa */
    .apple-navbar .nav-link.active-page {
        background: rgba(47, 133, 90, 0.15);
        color: #2F855A !important;
        font-weight: 700;
    }

    .apple-navbar .navbar-toggler {
        border: none;
        box-shadow: none;
        padding: 5px;
    }
    
    .apple-navbar .navbar-toggler:focus {
        box-shadow: 0 0 0 3px rgba(47, 133, 90, 0.2);
    }

    .user-pill {
        background: rgba(47, 133, 90, 0.1);
        color: #2F855A;
        padding: 8px 20px;
        border-radius: 20px;
        font-weight: 700;
        font-size: 0.9rem;
        border: 1px solid rgba(47, 133, 90, 0.2);
    }

    /* --- NUEVO: ESTILO PARA EL RELOJ --- */
    .live-clock {
        background: rgba(0, 0, 0, 0.05);
        color: #495057;
        padding: 8px 20px;
        border-radius: 20px;
        font-weight: 700;
        font-size: 0.9rem;
        border: 1px solid rgba(0, 0, 0, 0.1);
        display: flex;
        align-items: center;
        gap: 8px;
        font-variant-numeric: tabular-nums; /* Evita que el reloj brinque al cambiar los números */
    }

    .btn-logout {
        background: #2F855A;
        color: white;
        border-radius: 20px;
        padding: 8px 20px;
        font-weight: 600;
        transition: all 0.3s ease;
        border: none;
        text-decoration: none;
        font-size: 0.9rem;
    }

    .btn-logout:hover {
        background: #246b48;
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(47, 133, 90, 0.25);
    }

    /* Adaptación elegante para celulares */
    @media (max-width: 991px) {
        .apple-navbar .navbar-collapse {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            padding: 15px;
            margin-top: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            border: 1px solid rgba(0,0,0,0.05);
        }
        .apple-navbar .nav-link { margin-bottom: 5px; }
        .user-pill, .live-clock { justify-content: center; }
        .btn-logout { display: block; text-align: center; margin-top: 10px; }
    }
</style>

<nav class="navbar navbar-expand-lg navbar-light apple-navbar">
    <div class="container-fluid px-0">
        <a class="navbar-brand d-flex align-items-center" href="inventario-ganado">
            <i class="bi bi-house-door-fill me-2"></i> Finca La Rosa
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto ms-lg-4">
                <li class="nav-item">
                    <a class="nav-link nav-auto-active" href="inventario-ganado">
                        <i class="bi bi-clipboard2-data-fill me-1"></i> Inventario Bovino
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-auto-active" href="produccion">
                        <i class="bi bi-droplet-half me-1"></i> Producción y Ordeño
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-auto-active" href="lacteos">
                        <i class="bi bi-basket-fill me-1"></i> Lácteos y Quesos
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-auto-active" href="lotes-produccion">
                        <i class="bi bi-gear-wide-connected me-1"></i> Fábrica / Procesos
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-auto-active" href="empleados">
                        <i class="bi bi-people-fill me-1"></i> Empleados
                    </a>
                </li>
            </ul>
            
            <div class="d-flex flex-column flex-lg-row align-items-lg-center gap-3 mt-3 mt-lg-0 pb-2 pb-lg-0">
                
                <!-- NUEVO: RELOJ EN VIVO -->
                <div class="live-clock" title="Hora actual del sistema">
                    <i class="bi bi-clock-history"></i>
                    <span id="systemClock">00:00:00 AM</span>
                </div>

                <div class="user-pill d-flex align-items-center gap-2">
                    <i class="bi bi-person-circle fs-5"></i>
                    <span><%= usuarioActual.getFullName() %></span>
                </div>
                <a href="logout" class="btn-logout">
                    <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión
                </a>
            </div>
        </div>
    </div>
</nav>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // --- 1. LÓGICA DE PÁGINA ACTIVA ---
        let currentPath = window.location.pathname;
        let navLinks = document.querySelectorAll('.nav-auto-active');
        
        navLinks.forEach(link => {
            let linkHref = link.getAttribute('href');
            if (linkHref && currentPath.includes(linkHref)) {
                link.classList.add('active-page');
            }
        });

        // --- 2. LÓGICA DEL RELOJ EN VIVO ---
        function updateClock() {
            const now = new Date();
            let hours = now.getHours();
            let minutes = now.getMinutes();
            let seconds = now.getSeconds();
            let ampm = hours >= 12 ? 'PM' : 'AM';

            // Formato de 12 horas
            hours = hours % 12;
            hours = hours ? hours : 12; // La hora '0' debe ser '12'

            // Añadir ceros a la izquierda si es necesario (ej: 09 en vez de 9)
            hours = hours < 10 ? '0' + hours : hours;
            minutes = minutes < 10 ? '0' + minutes : minutes;
            seconds = seconds < 10 ? '0' + seconds : seconds;

            const timeString = hours + ':' + minutes + ':' + seconds + ' ' + ampm;
            document.getElementById('systemClock').textContent = timeString;
        }

        // Ejecutar el reloj inmediatamente y luego cada 1000ms (1 segundo)
        updateClock();
        setInterval(updateClock, 1000);
    });
</script>