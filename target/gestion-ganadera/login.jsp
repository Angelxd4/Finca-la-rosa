<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión | Finca La Rosa</title>
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            --moss: #464704;
            --sage: #9CA889;
            --khaki: #B7A78C;
            --drab: #423926;
            --ivory: #F3F5E7;
            --blanco-puro: #FFFFFF;
            --texto-suave: #7F8C8D;
            --btn-bg: var(--moss);
            --btn-text: var(--blanco-puro);
            --bg-body: var(--ivory);
            --bg-card: var(--blanco-puro);
            --text-main: var(--drab);
            --border-color: rgba(255, 255, 255, 0.5);
            --input-bg: #F8F9F3;
            --input-border: rgba(156, 168, 137, 0.2);
            --shadow-color: rgba(70, 71, 4, 0.15);
        }

        /* DARK MODE PALETTE - Sincronizado con Premium UI */
        html[data-theme="dark"] {
            --bg-body: #09090b;
            --bg-card: #18181b;
            --text-main: #f4f4f5;
            --texto-suave: #a1a1aa;
            --ivory: #09090b;
            --blanco-puro: #18181b;
            --border-color: #27272a;
            --input-bg: #09090b;
            --input-border: #27272a;
            --shadow-color: rgba(0, 0, 0, 0.8);
            --drab: #f4f4f5;
            --moss: #a3b889; /* Bright Sage for dark mode */
            --btn-text: #09090b; /* Dark text on bright button in dark mode */
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }

        body {
            background: var(--bg-body);
            display: flex; align-items: center; justify-content: center; flex-direction: column;
            min-height: 100vh; overflow: hidden;
            transition: background 0.3s ease;
        }

        /* ================= ANIMACIONES ================= */
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes cardScale { from { transform: scale(0.95); opacity: 0; } to { transform: scale(1); opacity: 1; } }
        @keyframes pulseAlert { 0% { transform: scale(1); } 50% { transform: scale(1.05); } 100% { transform: scale(1); } }

        /* ================= CONTENEDOR PRINCIPAL ================= */
        .container {
            background-color: var(--bg-card);
            border-radius: 40px; 
            border: 1px solid var(--border-color);
            box-shadow: 0 20px 60px var(--shadow-color);
            position: relative; overflow: hidden;
            width: 1000px; max-width: 95%; height: 650px;
            animation: cardScale 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
        }

        /* ================= FORMULARIOS ================= */
        .form-container { position: absolute; top: 0; height: 100%; transition: all 0.6s ease-in-out; }
        .sign-in { left: 0; width: 50%; z-index: 2; }
        .sign-up { left: 0; width: 50%; opacity: 0; z-index: 1; }
        
        .container.active .sign-in { transform: translateX(100%); }
        .container.active .sign-up { transform: translateX(100%); opacity: 1; z-index: 5; animation: move 0.6s; }
        @keyframes move { 0%, 49.99% { opacity: 0; z-index: 1; } 50%, 100% { opacity: 1; z-index: 5; } }

        form {
            background-color: var(--bg-card); display: flex; align-items: center; justify-content: center;
            flex-direction: column; padding: 0 60px; height: 100%; text-align: center;
        }

        .brand-emblem {
            background-color: var(--ivory); color: var(--moss); width: 68px; height: 68px; border-radius: 20px;
            display: flex; align-items: center; justify-content: center; margin-bottom: 20px;
            box-shadow: 0 6px 15px rgba(70, 71, 4, 0.1);
        }

        h1 { color: var(--drab); font-weight: 800; margin-bottom: 5px; font-size: 2.2rem; letter-spacing: -0.5px; }
        span.subtitle { font-size: 14px; color: var(--texto-suave); font-weight: 500; margin-bottom: 30px; }

        /* ================= INPUTS ================= */
        .input-group { width: 100%; position: relative; margin-bottom: 15px; }
        input {
            width: 100%; padding: 18px 25px; font-size: 15px; border-radius: 18px;
            border: 2px solid var(--input-border); background: var(--input-bg);
            color: var(--text-main); font-weight: 600; text-align: center; transition: all 0.3s;
        }
        input::placeholder { color: var(--texto-suave); opacity: 0.8; font-weight: 500; }
        input:focus { border-color: var(--moss); background: var(--bg-card); outline: none; box-shadow: 0 0 0 5px rgba(70, 71, 4, 0.1); }
        .toggle-password { position: absolute; right: 25px; top: 50%; transform: translateY(-50%); cursor: pointer; color: var(--sage); transition: 0.3s; }
        .toggle-password:hover { color: var(--moss); }

        /* ================= BOTONES ================= */
        button {
            background: var(--moss); color: var(--btn-text); border-radius: 18px; padding: 18px; font-weight: 800;
            border: none; width: 100%; margin-top: 15px; letter-spacing: 1px; font-size: 14px; cursor: pointer;
            transition: all 0.3s; box-shadow: 0 10px 25px rgba(70, 71, 4, 0.25); text-transform: uppercase;
        }
        button:hover:not(:disabled) { background: var(--text-main); color: var(--bg-body); transform: translateY(-3px); box-shadow: 0 15px 30px rgba(0, 0, 0, 0.35); }
        button:disabled { background: var(--texto-suave); cursor: not-allowed; box-shadow: none; transform: none; }

        .btn-ghost { background: transparent; border: 2px solid var(--ivory); color: var(--ivory); box-shadow: none; }
        .btn-ghost:hover { background: rgba(243, 245, 231, 0.15); box-shadow: none; }

        /* ================= PANEL DESLIZANTE ================= */
        .toggle-container { position: absolute; top: 0; left: 50%; width: 50%; height: 100%; overflow: hidden; transition: all 0.6s ease-in-out; border-radius: 150px 0 0 150px; z-index: 1000; }
        .container.active .toggle-container { transform: translateX(-100%); border-radius: 0 150px 150px 0; }
        .toggle { background: linear-gradient(135deg, var(--moss) 0%, var(--sage) 100%); color: var(--ivory); position: relative; left: -100%; width: 200%; height: 100%; transform: translateX(0); transition: all 0.6s ease-in-out; }
        .container.active .toggle { transform: translateX(50%); }
        .toggle-panel { position: absolute; width: 50%; height: 100%; display: flex; align-items: center; justify-content: center; flex-direction: column; padding: 0 50px; text-align: center; top: 0; transform: translateX(0); transition: all 0.6s ease-in-out; }
        .toggle-left { transform: translateX(-200%); }
        .container.active .toggle-left { transform: translateX(0); }
        .toggle-right { right: 0; transform: translateX(0); }
        .container.active .toggle-right { transform: translateX(200%); }
        .toggle-panel h2 { font-size: 38px; font-weight: 800; color: #ffffff; margin-bottom: 15px; }
        .toggle-panel p { font-size: 16px; line-height: 1.6; font-weight: 500; margin-bottom: 30px; color: rgba(255,255,255,0.9); }
        .toggle-panel .brand-emblem { background: rgba(255,255,255,0.2); color: #ffffff; box-shadow: none; border: 1px solid rgba(255,255,255,0.3); }

        /* ================= DISEÑO MEJORADO DE SWEETALERT (VENTANAS OTP) ================= */
        div:where(.swal2-container) div:where(.swal2-popup) {
            border-radius: 35px !important;
            padding: 2.5em 2em !important;
            box-shadow: 0 25px 60px var(--shadow-color) !important;
            background: var(--bg-card) !important;
            border: 1px solid var(--border-color);
        }
        
        .swal-custom-header { margin-bottom: 15px; }
        .swal-custom-icon {
            background: var(--ivory); color: var(--moss); width: 65px; height: 65px;
            border-radius: 20px; display: flex; justify-content: center; align-items: center;
            margin: 0 auto 15px; box-shadow: 0 6px 15px rgba(70, 71, 4, 0.1);
        }
        .swal-custom-title { color: var(--drab); font-weight: 800; font-size: 1.6rem; margin: 0; }
        .swal-custom-text { color: var(--texto-suave); font-size: 0.95rem; line-height: 1.5; margin-top: 10px; }
        .swal-custom-email { color: var(--moss); font-weight: 700; display: block; margin-top: 5px; }

        /* Etiqueta del temporizador OTP */
        .otp-timer-badge {
            display: inline-flex; align-items: center; gap: 8px;
            background: rgba(156, 168, 137, 0.15); color: var(--moss);
            padding: 8px 18px; border-radius: 50px; font-weight: 700; font-size: 14px;
            margin-top: 15px; border: 1px solid rgba(156, 168, 137, 0.3);
            transition: all 0.3s ease;
        }
        .otp-timer-badge.danger {
            background: rgba(220, 53, 69, 0.1); color: #dc3545; border-color: rgba(220, 53, 69, 0.3);
            animation: pulseAlert 1s infinite;
        }

        div:where(.swal2-container) button:where(.swal2-styled) {
            border-radius: 16px !important; font-weight: 700 !important;
            text-transform: uppercase; letter-spacing: 1px; padding: 14px 35px !important; transition: all 0.3s ease !important;
        }
        
        .swal2-input.otp-input {
            border-radius: 20px !important; text-align: center !important; font-size: 2.5rem !important;
            font-weight: 800 !important; letter-spacing: 15px !important; color: var(--text-main) !important;
            border: 2px solid var(--input-border) !important; background: var(--input-bg) !important;
            margin: 1em auto 0 !important; max-width: 80% !important; transition: all 0.3s !important;
        }
        .swal2-input.otp-input:focus { border-color: var(--moss) !important; box-shadow: 0 0 0 5px rgba(70, 71, 4, 0.1) !important; }

        @media (max-width: 850px) {
            .container { height: 100vh; max-width: 100%; border-radius: 0; border: none; }
            .toggle-container { display: none; }
            .form-container { width: 100%; }
            .sign-up { display: none; }
        }

        .dark-mode-fab {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--bg-card);
            color: var(--text-main);
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 15px var(--shadow-color);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 1001;
            transition: all 0.3s ease;
        }
        .dark-mode-fab:hover {
            transform: translateY(-3px);
        }

        .back-home-btn {
            position: fixed;
            top: 30px;
            left: 30px;
            background: var(--bg-card);
            color: var(--text-main);
            padding: 12px 20px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 13px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 15px var(--shadow-color);
            z-index: 1001;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .back-home-btn:hover {
            transform: translateX(-5px);
            color: var(--moss);
            border-color: var(--moss);
        }
    </style>
    <script>
        if (localStorage.getItem('darkMode') === 'true') {
            document.documentElement.setAttribute('data-theme', 'dark');
        }
    </script>
</head>

<body>

    <a href="index.jsp" class="back-home-btn">
        <i class="fa-solid fa-arrow-left"></i> Volver al Inicio
    </a>

    <div class="container" id="container">
        
        <div class="form-container sign-up">
            <form action="registro" method="POST">
                <div class="brand-emblem" style="animation: fadeInUp 0.6s;">
                    <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 16v6" />
                        <path d="M12 20a4 4 0 0 1-3-3" />
                        <path d="M12 18a4 4 0 0 0 3-3" />
                        <path d="M12 16c-4.5 0-7-3.5-7-7 0-3 3-5 7-5s7 2 7 5c0 3.5-2.5 7-7 7z" />
                        <path d="M12 4c-2 2-2 5 0 7s4 2 5 1" />
                        <path d="M12 11c-1.5-1-1.5-3 0-4" />
                    </svg>
                </div>
                <h1 style="animation: fadeInUp 0.6s 0.1s backwards;">Crear Cuenta</h1>
                <span class="subtitle" style="animation: fadeInUp 0.6s 0.2s backwards;">Uso exclusivo de la administración</span>
                
                <div class="input-group" style="animation: fadeInUp 0.6s 0.3s backwards;">
                    <input type="text" name="nombre" placeholder="Nombre Completo" required>
                </div>
                <div class="input-group" style="animation: fadeInUp 0.6s 0.4s backwards;">
                    <input type="email" name="email" placeholder="Correo Electrónico" required>
                </div>
                <div class="input-group" style="animation: fadeInUp 0.6s 0.5s backwards;">
                    <input type="password" name="password" id="pass_signup" placeholder="Contraseña" required>
                    <i class="fa-solid fa-eye toggle-password" onclick="togglePasswordVisibility('pass_signup', this)"></i>
                </div>
                <button type="button" style="animation: fadeInUp 0.6s 0.6s backwards;" onclick="mostrarAlertaRegistro()">Solicitar Acceso</button>
            </form>
        </div>
        
        <div class="form-container sign-in">
            <form id="loginForm" onsubmit="return iniciarLogin2FA(event)">
                <div class="brand-emblem" style="animation: fadeInUp 0.6s;">
                    <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 16v6" />
                        <path d="M12 20a4 4 0 0 1-3-3" />
                        <path d="M12 18a4 4 0 0 0 3-3" />
                        <path d="M12 16c-4.5 0-7-3.5-7-7 0-3 3-5 7-5s7 2 7 5c0 3.5-2.5 7-7 7z" />
                        <path d="M12 4c-2 2-2 5 0 7s4 2 5 1" />
                        <path d="M12 11c-1.5-1-1.5-3 0-4" />
                    </svg>
                </div>
                <h1 style="animation: fadeInUp 0.6s 0.1s backwards;">Finca La Rosa</h1>
                <span class="subtitle" style="animation: fadeInUp 0.6s 0.2s backwards;">Módulo de Gestión Ganadera y Lácteos</span>
                
                <div class="input-group" style="animation: fadeInUp 0.6s 0.3s backwards;">
                    <input type="email" name="email" id="email" placeholder="Correo Electrónico" required>
                </div>
                <div class="input-group" style="animation: fadeInUp 0.6s 0.4s backwards;">
                    <input type="password" name="password" id="password" placeholder="Contraseña" required>
                    <i class="fa-solid fa-eye toggle-password" onclick="togglePasswordVisibility('password', this)"></i>
                </div>
                <button type="submit" style="animation: fadeInUp 0.6s 0.5s backwards;">INGRESAR</button>
            </form>
        </div>
        
        <div class="toggle-container">
            <div class="toggle">
                <div class="toggle-panel toggle-left">
                    <div class="brand-emblem">
                        <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 16v6" />
                            <path d="M12 20a4 4 0 0 1-3-3" />
                            <path d="M12 18a4 4 0 0 0 3-3" />
                            <path d="M12 16c-4.5 0-7-3.5-7-7 0-3 3-5 7-5s7 2 7 5c0 3.5-2.5 7-7 7z" />
                            <path d="M12 4c-2 2-2 5 0 7s4 2 5 1" />
                            <path d="M12 11c-1.5-1-1.5-3 0-4" />
                        </svg>
                    </div>
                    <h2>¡Bienvenido!</h2>
                    <p>Si ya posees un usuario asignado en la finca, inicia sesión para continuar con tus registros.</p>
                    <button class="btn-ghost" id="login" style="max-width: 250px;">Volver al Login</button>
                </div>
                <div class="toggle-panel toggle-right">
                    <div class="brand-emblem">
                        <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 16v6" />
                            <path d="M12 20a4 4 0 0 1-3-3" />
                            <path d="M12 18a4 4 0 0 0 3-3" />
                            <path d="M12 16c-4.5 0-7-3.5-7-7 0-3 3-5 7-5s7 2 7 5c0 3.5-2.5 7-7 7z" />
                            <path d="M12 4c-2 2-2 5 0 7s4 2 5 1" />
                            <path d="M12 11c-1.5-1-1.5-3 0-4" />
                        </svg>
                    </div>
                    <h2>Portal Interno</h2>
                    <p>¿Eres un nuevo operario o veterinario de la finca? Consulta las opciones de registro del sistema.</p>
                    <button class="btn-ghost" id="register" style="max-width: 250px;">Registrarse</button>
                </div>
            </div>
        </div>
    </div>

    <button class="dark-mode-fab" id="loginThemeToggle" title="Cambiar Tema" onclick="toggleLoginTheme()">
        <i class="fa-solid fa-moon" id="loginThemeIcon"></i>
    </button>

    <script>
        const container = document.getElementById('container');
        document.getElementById('register').addEventListener('click', () => container.classList.add("active"));
        document.getElementById('login').addEventListener('click', () => container.classList.remove("active"));

        function toggleLoginTheme() {
            const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
            if (isDark) {
                document.documentElement.removeAttribute('data-theme');
                localStorage.setItem('darkMode', 'false');
                document.getElementById('loginThemeIcon').className = 'fa-solid fa-moon';
            } else {
                document.documentElement.setAttribute('data-theme', 'dark');
                localStorage.setItem('darkMode', 'true');
                document.getElementById('loginThemeIcon').className = 'fa-solid fa-sun';
            }
        }
        
        window.addEventListener('DOMContentLoaded', () => {
            if (localStorage.getItem('darkMode') === 'true') {
                document.getElementById('loginThemeIcon').className = 'fa-solid fa-sun';
            }
        });

        function togglePasswordVisibility(inputId, iconElement) {
            const passwordInput = document.getElementById(inputId);
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                iconElement.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                iconElement.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }

        function mostrarAlertaRegistro() {
            Swal.fire({
                icon: 'warning',
                title: 'Registro Restringido',
                text: 'No se permiten registros externos autónomos. Las credenciales deben ser creadas desde el panel de Empleados por el administrador.',
                confirmButtonColor: '#464704'
            });
        }

        async function iniciarLogin2FA(event) {
            event.preventDefault();
            
            const btn = event.target.querySelector('button[type="submit"]');
            const originalText = btn.innerText;
            btn.innerText = 'PROCESANDO...';
            btn.disabled = true;

            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;

            let formData = new URLSearchParams();
            formData.append('action', 'verify_credentials');
            formData.append('email', email);
            formData.append('password', password);

            try {
                let response = await fetch('login', { method: 'POST', body: formData });
                let data = await response.json();

                btn.innerText = originalText;
                btn.disabled = false;

                if (data.success) {
                    pedirCodigoDeVerificacion(data.idUsuario, data.email);
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Acceso Denegado',
                        text: data.message,
                        confirmButtonColor: '#464704',
                        confirmButtonText: 'Reintentar'
                    });
                }
            } catch (e) {
                btn.innerText = originalText;
                btn.disabled = false;
                Swal.fire('Error', 'No se pudo comunicar con el servidor.', 'error');
            }
        }

        let otpTimerInterval;

        async function pedirCodigoDeVerificacion(idUsuario, email) {
            
            // HTML Personalizado para la cabecera del SweetAlert
            const customHtml = `
                <div class="swal-custom-header">
                    <div class="swal-custom-icon">
                        <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 16v6" />
                            <path d="M12 20a4 4 0 0 1-3-3" />
                            <path d="M12 18a4 4 0 0 0 3-3" />
                            <path d="M12 16c-4.5 0-7-3.5-7-7 0-3 3-5 7-5s7 2 7 5c0 3.5-2.5 7-7 7z" />
                            <path d="M12 4c-2 2-2 5 0 7s4 2 5 1" />
                            <path d="M12 11c-1.5-1-1.5-3 0-4" />
                        </svg>
                    </div>
                    <h2 class="swal-custom-title">Protección de Seguridad</h2>
                    <p class="swal-custom-text">Ingresa el código de 6 dígitos que acabamos de enviar a: <span class="swal-custom-email">` + email + `</span></p>
                    <div class="otp-timer-badge" id="otpTimerBadge">
                        <i class="fa-regular fa-clock"></i> <span id="otpTimerText">15:00</span>
                    </div>
                </div>
            `;

            const { value: otp } = await Swal.fire({
                html: customHtml,
                input: 'text',
                inputPlaceholder: '000000',
                inputAttributes: { 
                    maxlength: 6,
                    pattern: '[0-9]*',
                    inputmode: 'numeric'
                },
                customClass: { input: 'otp-input' },
                showCancelButton: true,
                confirmButtonColor: '#464704',
                cancelButtonColor: '#9CA889',
                confirmButtonText: 'Validar y Entrar',
                cancelButtonText: 'Cancelar',
                allowOutsideClick: false,
                didOpen: () => {
                    // Lógica del Cronómetro de 15 Minutos (900 Segundos)
                    let timeLeft = 900; 
                    const timerText = document.getElementById('otpTimerText');
                    const timerBadge = document.getElementById('otpTimerBadge');
                    
                    otpTimerInterval = setInterval(() => {
                        timeLeft--;
                        let minutes = Math.floor(timeLeft / 60);
                        let seconds = timeLeft % 60;
                        
                        timerText.textContent = minutes + ":" + (seconds < 10 ? "0" : "") + seconds;

                        // Efecto de peligro cuando queda menos de 1 minuto
                        if (timeLeft <= 60 && !timerBadge.classList.contains('danger')) {
                            timerBadge.classList.add('danger');
                        }

                        // Si el tiempo expira, bloqueamos todo
                        if (timeLeft <= 0) {
                            clearInterval(otpTimerInterval);
                            timerText.textContent = "Expirado";
                            Swal.disableInput();
                            Swal.disableButtons();
                        }
                    }, 1000);

                    // Filtro para solo permitir números en el campo OTP
                    const inputEl = Swal.getInput();
                    inputEl.addEventListener('input', function() {
                        this.value = this.value.replace(/[^0-9]/g, '');
                    });
                },
                willClose: () => {
                    clearInterval(otpTimerInterval); // Limpiar memoria al cerrar
                }
            });

            if (otp) {
                let formData = new URLSearchParams();
                formData.append('action', 'login_with_otp');
                formData.append('idUsuario', idUsuario);
                formData.append('email', email);
                formData.append('otp', otp);

                try {
                    let response = await fetch('login', { method: 'POST', body: formData });
                    let data = await response.json();

                    if (data.success) {
                        window.location.href = 'dashboard';
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Código Incorrecto',
                            text: data.message,
                            confirmButtonColor: '#464704',
                            confirmButtonText: 'Intentar de nuevo'
                        }).then(() => pedirCodigoDeVerificacion(idUsuario, email));
                    }
                } catch (e) {
                    Swal.fire('Error', 'No se pudo verificar el código.', 'error');
                }
            }
        }
    </script>
</body>
</html>