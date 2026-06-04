<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión | Gestión Ganadera</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --brand-main: #198754; /* Verde principal Finca */
            --brand-main-hover: #146c43;
            --apple-bg: #f4f7f6;
            --card-bg: rgba(255, 255, 255, 0.80);
            --text-main: #121212;
            --input-bg: rgba(0, 0, 0, 0.03);
            --input-placeholder: rgba(0, 0, 0, 0.4);
            --glass-border: rgba(125, 125, 125, 0.2);
        }

        /* --- SOPORTE MODO OSCURO --- */
        body.dark-mode {
            --apple-bg: #0f1712; /* Fondo oscuro verdoso */
            --card-bg: rgba(20, 26, 22, 0.85);
            --text-main: #f8f9fa;
            --input-bg: rgba(255, 255, 255, 0.05);
            --input-placeholder: rgba(255, 255, 255, 0.5);
            --glass-border: rgba(255, 255, 255, 0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--apple-bg);
            color: var(--text-main);
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            transition: background 0.5s ease;
            overflow: hidden;
        }

        /* --- ANIMACIONES --- */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes cardScale {
            from { transform: scale(0.95); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }

        .login-card {
            display: flex;
            width: 100%;
            max-width: 1000px;
            height: 650px;
            background: var(--card-bg);
            backdrop-filter: saturate(180%) blur(25px);
            -webkit-backdrop-filter: saturate(180%) blur(25px);
            border: 1px solid var(--glass-border);
            border-radius: 40px;
            overflow: hidden;
            box-shadow: 0 40px 100px rgba(0, 0, 0, 0.1);
            animation: cardScale 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
        }

        .left-panel {
            flex: 1.3;
            position: relative;
            /* Imagen de la Finca/Vaca */
            background: url('https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80') center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .left-panel::before {
            content: '';
            position: absolute;
            inset: 0;
            /* Degradado verde a oscuro */
            background: linear-gradient(135deg, rgba(25, 135, 84, 0.8) 0%, rgba(10, 26, 15, 0.95) 100%);
            z-index: 1;
        }

        .left-content {
            position: relative;
            z-index: 2;
            color: white;
            text-align: center;
            padding: 40px;
        }
        .left-content h2 {
            font-size: 55px;
            font-weight: 800;
            letter-spacing: -0.04em;
            animation: fadeInUp 1s ease 0.2s forwards;
            opacity: 0;
            color: white !important;
            line-height: 1.1;
        }
        .left-content p {
            font-size: 18px;
            opacity: 0.9;
            animation: fadeInUp 1s ease 0.4s forwards;
            opacity: 0;
            color: white !important;
            margin-top: 15px;
        }

        .right-panel {
            flex: 1;
            padding: 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
        }

        #theme-toggle {
            position: absolute;
            top: 30px;
            right: 30px;
            cursor: pointer;
            font-size: 1.4rem;
            opacity: 0.6;
            transition: 0.3s;
            color: var(--text-main);
        }
        #theme-toggle:hover { opacity: 1; transform: rotate(15deg); }

        .login-box { width: 100%; max-width: 340px; margin: 0 auto; }
        .login-box h3 { font-size: 34px; font-weight: 700; margin-bottom: 10px; color: var(--text-main); }

        .form-group-apple { position: relative; margin-bottom: 20px; }
        .form-group-apple input {
            width: 100%;
            padding: 16px 50px;
            border-radius: 18px;
            border: 1px solid var(--glass-border);
            background: var(--input-bg);
            color: var(--text-main);
            font-size: 16px;
            transition: all 0.3s;
        }

        .form-group-apple input::placeholder { color: var(--input-placeholder); }
        .form-group-apple input:focus {
            background: var(--card-bg);
            border-color: var(--brand-main);
            box-shadow: 0 0 0 4px rgba(25, 135, 84, 0.15);
            outline: none;
        }
        .form-group-apple i.bi-main {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--brand-main);
            font-size: 20px;
        }

        .toggle-password {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: transparent;
            border: none;
            color: #86868b;
            cursor: pointer;
        }

        .btn-custom {
            background: var(--brand-main);
            color: #ffffff;
            border-radius: 18px;
            padding: 16px;
            font-weight: 700;
            border: none;
            width: 100%;
            margin-top: 15px;
            transition: 0.3s;
            box-shadow: 0 10px 25px rgba(25, 135, 84, 0.25);
        }
        .btn-custom:hover {
            background: var(--brand-main-hover);
            transform: translateY(-2px);
            box-shadow: 0 15px 30px rgba(25, 135, 84, 0.35);
            color: #ffffff;
        }

        .text-main-custom { color: var(--brand-main) !important; }

        .animate-item { opacity: 0; animation: fadeInUp 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) forwards; }
        .delay-1 { animation-delay: 0.4s; }
        .delay-2 { animation-delay: 0.5s; }
        .delay-3 { animation-delay: 0.6s; }

        @media (max-width: 850px) {
            .login-card { flex-direction: column; height: auto; max-width: 450px; margin: 20px; }
            .left-panel { padding: 80px 20px; }
            .right-panel { padding: 40px 30px; }
        }
    </style>
</head>
<body>

    <div class="login-card">
        <div class="left-panel">
            <div class="left-content">
                <h2>Finca<br>La Rosa 🐄</h2>
                <p>Sistema de Gestión Ganadera Avanzado.</p>
            </div>
        </div>

        <div class="right-panel">
            <div id="theme-toggle"><i class="bi bi-moon-stars-fill" id="theme-icon"></i></div>

            <div class="login-box">
                <h3 class="animate-item">Acceso</h3>
                <p class="text-muted small mb-4 animate-item delay-1">Ingresa tus credenciales administrativas.</p>

                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger border-0 py-2 small animate-item" style="border-radius:15px; background: rgba(220, 53, 69, 0.1); color: #dc3545;">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= request.getAttribute("error") %>
                </div>
                <% } %>

                <form action="login" method="POST" class="needs-validation" novalidate>
                    
                    <div class="form-group-apple animate-item delay-2">
                        <input type="email" name="email" placeholder="admin@finca.com" required>
                        <i class="bi bi-envelope-fill bi-main"></i>
                    </div>

                    <div class="form-group-apple animate-item delay-3">
                        <input type="password" name="password" id="passwordField" placeholder="••••••••" required>
                        <i class="bi bi-lock-fill bi-main"></i>
                        <button type="button" class="toggle-password" onclick="togglePassword()">
                            <i class="bi bi-eye" id="eyeIcon"></i>
                        </button>
                    </div>

                    <div class="d-flex justify-content-between mb-4 animate-item delay-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="rem">
                            <label class="form-check-label small text-muted" for="rem" style="color: var(--text-main) !important; opacity: 0.7;">Recordar sesión</label>
                        </div>
                        <a href="#" class="small text-main-custom text-decoration-none fw-bold">¿Olvidaste tu clave?</a>
                    </div>

                    <button type="submit" class="btn-custom animate-item delay-3">Ingresar al Sistema</button>
                </form>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const body = document.body;
        const themeIcon = document.getElementById('theme-icon');
        const themeToggle = document.getElementById('theme-toggle');

        // Inicializar Tema desde LocalStorage
        if (localStorage.getItem('theme') === 'dark') {
            body.classList.add('dark-mode');
            themeIcon.classList.replace('bi-moon-stars-fill', 'bi-sun-fill');
        }

        // Toggle del Modo Oscuro
        themeToggle.addEventListener('click', () => {
            body.classList.toggle('dark-mode');
            if (body.classList.contains('dark-mode')) {
                themeIcon.classList.replace('bi-moon-stars-fill', 'bi-sun-fill');
                localStorage.setItem('theme', 'dark');
            } else {
                themeIcon.classList.replace('bi-sun-fill', 'bi-moon-stars-fill');
                localStorage.setItem('theme', 'light');
            }
        });

        // Toggle para mostrar/ocultar contraseña
        function togglePassword() {
            const field = document.getElementById('passwordField');
            const icon = document.getElementById('eyeIcon');
            if (field.type === 'password') {
                field.type = 'text';
                icon.classList.replace('bi-eye', 'bi-eye-slash');
            } else {
                field.type = 'password';
                icon.classList.replace('bi-eye-slash', 'bi-eye');
            }
        }
    </script>
</body>
</html>