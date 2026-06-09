<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Iniciar Sesión | Finca La Rosa</title>
    
    <!-- Fuentes y Estilos -->
    <link rel="preconnect" href="https://fonts.gstatic.com" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- SweetAlert2 para Notificaciones -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            /* Colores inspirados en la referencia y tu marca */
            --brand-main: #1C7345; /* Verde corporativo oscuro */
            --brand-light: #D9EFE0; /* Verde muy claro para inputs */
            --brand-accent: #00A859; /* Verde vibrante para botón */
            --text-dark: #2d3436;
            --text-muted: #848f9a;
        }

        body {
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            background-color: #EAEAEA; /* Fondo gris muy claro para resaltar la tarjeta */
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* --- CONTENEDOR PRINCIPAL --- */
        .login-wrapper {
            background-color: #ffffff;
            width: 1000px;
            max-width: 95%;
            min-height: 550px;
            border-radius: 30px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
            display: flex;
            overflow: hidden;
            position: relative;
        }

        /* --- PANEL IZQUIERDO (VERDE) --- */
        .sidebar {
            background-color: var(--brand-main);
            width: 45%;
            padding: 40px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }

        /* Formas circulares con CSS puro */
        .sidebar::before {
            content: '';
            position: absolute;
            top: -100px;
            left: -100px;
            width: 350px;
            height: 350px;
            background-color: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
            z-index: -1;
        }
        
        .sidebar::after {
            content: '';
            position: absolute;
            bottom: -150px;
            right: -100px;
            width: 450px;
            height: 450px;
            background-color: rgba(0, 0, 0, 0.08);
            border-radius: 50%;
            z-index: -1;
        }

        .sidebar-logo {
            background: white;
            color: var(--brand-main);
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            margin-bottom: 10px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }

        .sidebar h2 {
            font-weight: 700;
            font-size: 2rem;
            margin-bottom: 15px;
            letter-spacing: -0.5px;
        }

        .sidebar p {
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 40px;
            padding: 0 20px;
            opacity: 0.9;
        }

        .btn-outline-white {
            background: transparent;
            border: 2px solid white;
            color: white;
            padding: 10px 40px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-outline-white:hover {
            background: white;
            color: var(--brand-main);
        }

        /* --- PANEL DERECHO (FORMULARIO) --- */
        .form-container {
            width: 55%;
            padding: 50px 80px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            text-align: center;
        }

        .form-container h1 {
            color: var(--brand-main);
            font-weight: 800;
            font-size: 2.2rem;
            margin-bottom: 5px;
            letter-spacing: -0.5px;
        }

        .form-container p.subtitle {
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-bottom: 40px;
        }

        /* Inputs Píldora (Referencia Imagen) */
        .input-pill {
            margin-bottom: 20px;
        }

        .input-pill input {
            width: 100%;
            background-color: var(--brand-light);
            border: none;
            padding: 15px 25px;
            border-radius: 50px;
            font-family: 'Montserrat', sans-serif;
            font-size: 0.95rem;
            font-weight: 500;
            color: var(--text-dark);
            text-align: center; /* Texto centrado como en la imagen */
            transition: all 0.3s ease;
        }

        .input-pill input::placeholder {
            color: #92b8a0;
            font-weight: 500;
        }

        .input-pill input:focus {
            outline: none;
            background-color: #c8e6d2;
            box-shadow: inset 0 0 0 2px var(--brand-main);
        }

        .forgot-pass {
            display: block;
            text-align: center;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 30px;
            transition: color 0.3s ease;
        }

        .forgot-pass:hover {
            color: var(--brand-main);
        }

        .btn-solid-green {
            background-color: var(--brand-accent);
            color: white;
            border: none;
            width: 180px;
            padding: 12px 0;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 10px 20px rgba(0, 168, 89, 0.3);
            transition: all 0.3s ease;
        }

        .btn-solid-green:hover {
            background-color: var(--brand-main);
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(28, 115, 69, 0.4);
        }

        .register-text {
            margin-top: 30px;
            font-size: 0.85rem;
            color: var(--text-muted);
            font-weight: 500;
        }

        /* --- RESPONSIVIDAD PARA MÓVILES --- */
        @media (max-width: 900px) {
            .login-wrapper {
                flex-direction: column;
                width: 90%;
                min-height: auto;
            }
            .sidebar {
                width: 100%;
                padding: 40px 20px;
                border-radius: 30px 30px 0 0;
            }
            .sidebar::before, .sidebar::after {
                display: none;
            }
            .form-container {
                width: 100%;
                padding: 40px 30px;
            }
        }
    </style>
</head>
<body>

    <!-- LÓGICA INTACTA: NOTIFICACIONES SWEET ALERT -->
    <% if(request.getParameter("error") != null) { %>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                Swal.fire({
                    icon: 'error',
                    title: 'Acceso Denegado',
                    text: 'El correo electrónico o la contraseña son incorrectos. Por favor, verifica tus datos e inténtalo nuevamente.',
                    confirmButtonColor: '#1C7345',
                    confirmButtonText: 'Reintentar'
                });
            });
        </script>
    <% } %>
    
    <% if(request.getParameter("logout") != null) { %>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                Swal.fire({
                    icon: 'success',
                    title: 'Sesión Cerrada',
                    text: 'Has cerrado sesión exitosamente.',
                    confirmButtonColor: '#1C7345',
                    timer: 3000,
                    showConfirmButton: false
                });
            });
        </script>
    <% } %>

    <div class="login-wrapper">
        <!-- PANEL IZQUIERDO -->
        <div class="sidebar">
            <div class="sidebar-logo">
                <i class="bi bi-moisture"></i>
            </div>
            <h5 class="mb-3 fw-bold" style="letter-spacing: 1px;">FINCA LA ROSA</h5>
            <h2>¡Bienvenido!</h2>
            <p>Para mantenerte conectado con nosotros, por favor inicia sesión con tu información personal.</p>
            <a href="#" class="btn-outline-white">PORTAL</a>
            
            <div class="mt-4" style="font-size: 10px; opacity: 0.7; letter-spacing: 1px;">
                SISTEMA  | PRODUCCIÓN
            </div>
        </div>

        <!-- PANEL DERECHO -->
        <div class="form-container">
            <h1>bienvenido</h1>
            <p class="subtitle">Inicia sesión en tu cuenta para continuar</p>
            
            <!-- LÓGICA INTACTA: FORMULARIO POST -->
            <form action="login" method="POST">
                
                <div class="input-pill">
                    <input type="email" name="email" id="email" placeholder="Email ............................" required />
                </div>
                
                <div class="input-pill">
                    <input type="password" name="password" id="password" placeholder="Password ............................" required />
                </div>
                
                <a href="#" class="forgot-pass" onclick="recuperarPass()">¿Olvidaste tu contraseña?</a>
                
                <button type="submit" class="btn-solid-green">LOG IN</button>
                
                <p class="register-text">¿No tienes una cuenta? <a href="#" class="text-success fw-bold text-decoration-none">Regístrate</a></p>
            </form>
        </div>
    </div>

    <script>
        // Función intacta para recuperar contraseña
        function recuperarPass() {
            Swal.fire({
                icon: 'info',
                title: 'Recuperar Cuenta',
                text: 'Por favor, contacta al Administrador Principal del sistema para restablecer tus credenciales.',
                confirmButtonColor: '#1C7345'
            });
        }
    </script>
</body>
</html>