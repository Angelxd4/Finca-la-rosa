<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión | Finca La Rosa</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Montserrat', sans-serif;
        }

        body {
            background-color: #f3f7f4;
            background: linear-gradient(135deg, #e2e8e4, #d1e8d8);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            height: 100vh;
            overflow: hidden;
        }

        /* --- CONTENEDOR PRINCIPAL SINO DE CALIDAD --- */
        .container {
            background-color: #fff;
            border-radius: 32px;
            box-shadow: 0 20px 50px rgba(28, 115, 69, 0.12);
            position: relative;
            overflow: hidden;
            width: 850px;
            max-width: 100%;
            min-height: 520px;
        }

        .container p {
            font-size: 14px;
            line-height: 22px;
            letter-spacing: 0.3px;
            margin: 15px 0 25px;
            color: #555; 
            font-weight: 500;
        }

        .container span {
            font-size: 13px;
            color: #637068; 
            font-weight: 600;
            margin-bottom: 15px;
        }

        .container a {
            color: #4a5550; 
            font-size: 13px;
            text-decoration: none;
            margin: 15px 0 10px;
            font-weight: 600;
            transition: color 0.3s;
        }

        .container a:hover {
            color: #1C7345;
        }

        /* --- BOTONES PRINCIPALES --- */
        .container button {
            background-color: #1C7345;
            color: #fff;
            font-size: 13px;
            padding: 14px 50px;
            border: 1px solid transparent;
            border-radius: 50px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-top: 10px;
            cursor: pointer;
            box-shadow: 0 8px 20px rgba(28, 115, 69, 0.2);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .container button:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(28, 115, 69, 0.35);
            background-color: #165c37;
        }

        /* --- BOTONES SECUNDARIOS (En el panel verde) --- */
        .container button.hidden {
            background-color: transparent;
            border: 2px solid #ffffff; 
            color: #ffffff;
            box-shadow: none;
        }

        .container button.hidden:hover {
            background-color: rgba(255, 255, 255, 0.2); 
            transform: translateY(-2px);
        }

        .container form {
            background-color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 0 50px;
            height: 100%;
            text-align: center;
        }

        /* --- INPUTS Y PLACEHOLDERS MEJORADOS --- */
        .container input {
            background-color: #f0f4f1; 
            border: 1px solid #e0e8e3;
            margin: 8px 0;
            padding: 14px 20px;
            font-size: 14px;
            border-radius: 50px;
            width: 100%;
            outline: none;
            text-align: center;
            font-weight: 600;
            color: #1d1d1f; 
            transition: all 0.3s ease;
        }

        .container input::placeholder {
            color: #7b8a81; 
            font-weight: 500;
            opacity: 1; 
        }

        .container input:focus {
            border-color: #1C7345;
            background-color: #fff;
            box-shadow: 0 0 0 4px rgba(28, 115, 69, 0.1);
        }

        /* --- CONTENEDOR DE CONTRASEÑA Y BOTÓN DE OJO --- */
        .password-container {
            position: relative;
            width: 100%;
            margin: 8px 0;
        }
        
        .container .password-container input {
            margin: 0; /* El margen ya lo tiene el contenedor padre */
            padding-right: 45px; /* Deja espacio para que el texto no se monte sobre el ojo */
        }

        .toggle-password {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #7b8a81;
            font-size: 16px;
            transition: color 0.3s ease;
        }

        .toggle-password:hover {
            color: #1C7345;
        }

        /* --- LOGOTIPO / EMBLEMA RELACIONADO --- */
        .brand-emblem {
            background-color: #eaf6ee;
            color: #1C7345;
            width: 55px;
            height: 55px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 15px;
            box-shadow: 0 6px 15px rgba(28, 115, 69, 0.1);
        }
        
        .toggle-panel .brand-emblem {
            background-color: rgba(255,255,255,0.2);
            color: #ffffff;
            box-shadow: none;
        }

        /* --- ANIMACIONES DE PANELES --- */
        .form-container {
            position: absolute;
            top: 0;
            height: 100%;
            transition: all 0.6s ease-in-out;
        }

        .sign-in {
            left: 0;
            width: 50%;
            z-index: 2;
        }

        .container.active .sign-in {
            transform: translateX(100%);
        }

        .sign-up {
            left: 0;
            width: 50%;
            opacity: 0;
            z-index: 1;
        }

        .container.active .sign-up {
            transform: translateX(100%);
            opacity: 1;
            z-index: 5;
            animation: move 0.6s;
        }

        @keyframes move {
            0%, 49.99% { opacity: 0; z-index: 1; }
            50%, 100% { opacity: 1; z-index: 5; }
        }

        /* --- CAPA DESLIZANTE GESTIÓN VISUAL --- */
        .toggle-container {
            position: absolute;
            top: 0;
            left: 50%;
            width: 50%;
            height: 100%;
            overflow: hidden;
            transition: all 0.6s ease-in-out;
            border-radius: 150px 0 0 100px;
            z-index: 1000;
        }

        .container.active .toggle-container {
            transform: translateX(-100%);
            border-radius: 0 150px 100px 0;
        }

        .toggle {
            height: 100%;
            background: linear-gradient(135deg, #2F855A, #1C7345);
            color: #fff;
            position: relative;
            left: -100%;
            width: 200%;
            transform: translateX(0);
            transition: all 0.6s ease-in-out;
        }

        .container.active .toggle {
            transform: translateX(50%);
        }

        .toggle-panel {
            position: absolute;
            width: 50%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 0 45px;
            text-align: center;
            top: 0;
            transform: translateX(0);
            transition: all 0.6s ease-in-out;
        }

        .toggle-left {
            transform: translateX(-200%);
        }

        .container.active .toggle-left {
            transform: translateX(0);
        }

        .toggle-right {
            right: 0;
            transform: translateX(0);
        }

        .container.active .toggle-right {
            transform: translateX(200%);
        }
        
        .toggle-panel p {
            color: #f0f7f3; 
            font-weight: 500;
        }

        h1 {
            color: #1C7345;
            font-weight: 800;
            margin-bottom: 5px;
            letter-spacing: -0.5px;
            font-size: 2rem;
        }
        
        .toggle h1 {
            color: #ffffff;
        }

        /* Ventanas SweetAlert Apple Style */
        div:where(.swal2-container) div:where(.swal2-popup) { border-radius: 24px; font-family: 'Montserrat', sans-serif; box-shadow: 0 25px 50px rgba(0,0,0,0.15); }
        div:where(.swal2-container) button:where(.swal2-styled) { border-radius: 50px; font-weight: 600; padding: 10px 30px; }
    </style>
</head>

<body>

    <% if(request.getParameter("error") != null) { %>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                Swal.fire({
                    icon: 'error',
                    title: 'Acceso Denegado',
                    text: 'El correo electrónico o la contraseña son incorrectos. Por favor, verifica tus datos.',
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
                    text: 'Has salido del sistema de forma segura.',
                    confirmButtonColor: '#1C7345',
                    timer: 3000,
                    showConfirmButton: false
                });
            });
        </script>
    <% } %>

    <div class="container" id="container">
        
        <div class="form-container sign-up">
            <form action="registro" method="POST">
                <div class="brand-emblem">
                    <i class="fa-solid fa-seedling"></i>
                </div>
                <h1>Crear Cuenta</h1>
                <span>Usa el correo autorizado por la administración</span>
                <input type="text" name="nombre" placeholder="Nombre Completo" required>
                <input type="email" name="email" placeholder="Correo Electrónico" required>
                
                <div class="password-container">
                    <input type="password" name="password" id="pass_signup" placeholder="Contraseña" required>
                    <i class="fa-solid fa-eye toggle-password" onclick="togglePasswordVisibility('pass_signup', this)"></i>
                </div>
                
                <button type="button" onclick="mostrarAlertaRegistro()">Registrarse</button>
            </form>
        </div>
        
        <div class="form-container sign-in">
            <form action="login" method="POST">
                <div class="brand-emblem">
                    <i class="fa-solid fa-droplet"></i>
                </div>
                <h1>Finca La Rosa</h1>
                <span>Módulo de Gestión Ganadera y Lácteos</span>
                
                <input type="email" name="email" placeholder="Correo Electrónico" required>
                
                <div class="password-container">
                    <input type="password" name="password" id="pass_signin" placeholder="Contraseña" required>
                    <i class="fa-solid fa-eye toggle-password" onclick="togglePasswordVisibility('pass_signin', this)"></i>
                </div>
                
                <a href="#" onclick="recuperarPass()">¿Olvidaste tu contraseña?</a>
                <button type="submit">LOG IN</button>
            </form>
        </div>
        
        <div class="toggle-container">
            <div class="toggle">
                <div class="toggle-panel toggle-left">
                    <div class="brand-emblem">
                        <i class="fa-solid fa-cow"></i>
                    </div>
                    <h1>¡Bienvenido!</h1>
                    <p>Si ya posees un usuario asignado en la finca, inicia sesión para continuar con los registros.</p>
                    <button class="hidden" id="login">Volver</button>
                </div>
                <div class="toggle-panel toggle-right">
                    <div class="brand-emblem">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <h1>Portal Interno</h1>
                    <p>¿Eres un nuevo operario o veterinario de la finca? Consulta las opciones de registro del sistema.</p>
                    <button class="hidden" id="register">Solicitar</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Manejador de la animación de deslizamiento
        const container = document.getElementById('container');
        const registerBtn = document.getElementById('register');
        const loginBtn = document.getElementById('login');

        registerBtn.addEventListener('click', () => {
            container.classList.add("active");
        });

        loginBtn.addEventListener('click', () => {
            container.classList.remove("active");
        });

        // NUEVO: Función para alternar la visibilidad de la contraseña
        function togglePasswordVisibility(inputId, iconElement) {
            const passwordInput = document.getElementById(inputId);
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                iconElement.classList.remove('fa-eye');
                iconElement.classList.add('fa-eye-slash'); // Cambia al ícono de ojo tachado
            } else {
                passwordInput.type = 'password';
                iconElement.classList.remove('fa-eye-slash');
                iconElement.classList.add('fa-eye'); // Vuelve al ícono normal
            }
        }

        // Alertas estilizadas tipo iOS/Apple con SweetAlert2
        function recuperarPass() {
            Swal.fire({
                icon: 'info',
                title: 'Recuperación de Acceso',
                text: 'Por motivos de seguridad, por favor solicita el restablecimiento de tu clave directamente al Administrador.',
                confirmButtonColor: '#1C7345'
            });
        }

        function mostrarAlertaRegistro() {
            Swal.fire({
                icon: 'warning',
                title: 'Registro Restringido',
                text: 'No se permiten registros externos autónomos. Las credenciales deben ser dadas de alta por el departamento administrativo.',
                confirmButtonColor: '#1C7345'
            });
        }
    </script>
</body>
</html>