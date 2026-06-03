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

<nav class="navbar navbar-expand-lg navbar-dark bg-success mb-4 shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="inventario-ganado">🐄 Finca La Rosa</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="inventario-ganado">Inventario Bovino</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="produccion">🥛 Producción y Ordeño</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="lacteos">🧀 Lácteos y Quesos</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-warning fw-bold" href="lotes-produccion">⚙️ Fábrica / Procesos</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="empleados">👥 Empleados</a>
                </li>
            </ul>
            <div class="d-flex align-items-center">
                <span class="text-white me-3 small fw-bold">
                    👤 Hola, <%= usuarioActual.getFullName() %>
                </span>
                <a href="logout" class="btn btn-outline-light btn-sm fw-bold">Cerrar Sesión</a>
            </div>
        </div>
    </div>
</nav>