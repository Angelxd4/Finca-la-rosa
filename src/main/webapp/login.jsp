<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión | Finca La Rosa</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            /* PALETA FINCA LA ROSA (DARK MOSS GREEN & EARTH TONES) */
            --moss: #464704;       /* Dark Moss Green */
            --sage: #9CA889;       /* Sage */
            --khaki: #B7A78C;      /* Khaki */
            --drab: #423926;       /* Drab Dark Brown */
            --ivory: #F3F5E7;      /* Ivory */
            --border-subtle: #E2E4D5;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }

        body {
            background: linear-gradient(135deg, var(--ivory), var(--sage));
            display: flex; align-items: center; justify-content: center; flex-direction: column;
            height: 100vh; overflow: hidden;
        }

        .container {
            background-color: #fff; border-radius: 32px; border: 1px solid var(--border-subtle);
            box-shadow: 0 25px 50px rgba(66, 57, 38, 0.2); position: relative; overflow: hidden;
            width: 850px; max-width: 95%; min-height: 520px;
        }

        .container p { font-size: 14px; line-height: 22px; letter-spacing: 0.3px; margin: 15px 0 25px; color: var(--ivory); font-weight: 500; }
        .container span { font-size: 13px; color: var(--drab); font-weight: 600; margin-bottom: 15px; opacity: 0.8; }
        .container a { color: var(--drab); font-size: 13px; text-decoration: none; margin: 15px 0 10px; font-weight: 700; transition: color 0.3s; cursor: pointer; }
        .container a:hover { color: var(--moss); }

        .container button {
            background-color: var(--moss); color: #fff; font-size: 13px; padding: 14px 50px; border: none;
            border-radius: 14px; font-weight: 800; letter-spacing: 1px; text-transform: uppercase;
            margin-top: 10px; cursor: pointer; box-shadow: 0 8px 20px rgba(70, 71, 4, 0.25); transition: all 0.3s ease;
        }
        .container button:hover { transform: translateY(-2px); box-shadow: 0 12px 25px rgba(66, 57, 38, 0.35); background-color: var(--drab); }
        .container button.hidden { background-color: transparent; border: 2px solid var(--ivory); color: var(--ivory); box-shadow: none; }
        .container button.hidden:hover { background-color: rgba(243, 245, 231, 0.2); transform: translateY(-2px); }

        .container form { background-color: #fff; display: flex; align-items: center; justify-content: center; flex-direction: column; padding: 0 50px; height: 100%; text-align: center; }

        .container input {
            background-color: var(--ivory); border: 1px solid var(--border-subtle); margin: 8px 0; padding: 14px 20px;
            font-size: 14px; border-radius: 14px; width: 100%; outline: none; text-align: center; font-weight: 600; color: var(--drab); transition: all 0.3s ease;
        }
        .container input::placeholder { color: var(--sage); font-weight: 600; opacity: 1; }
        .container input:focus { border-color: var(--moss); background-color: #fff; box-shadow: 0 0 0 4px rgba(70, 71, 4, 0.15); }

        .password-container { position: relative; width: 100%; margin: 8px 0; }
        .container .password-container input { margin: 0; padding-right: 45px; }
        .toggle-password { position: absolute; right: 20px; top: 50%; transform: translateY(-50%); cursor: pointer; color: var(--sage); font-size: 16px; transition: color 0.3s ease; }
        .toggle-password:hover { color: var(--moss); }

        .brand-emblem {
            background-color: var(--ivory); color: var(--moss); width: 55px; height: 55px; border-radius: 16px;
            display: flex; align-items: center; justify-content: center; font-size: 24px; margin-bottom: 15px; box-shadow: 0 6px 15px rgba(70, 71, 4, 0.15);
        }
        .toggle-panel .brand-emblem { background-color: rgba(243, 245, 231, 0.2); color: var(--ivory); box-shadow: none; }

        .form-container { position: absolute; top: 0; height: 100%; transition: all 0.6s ease-in-out; }
        .sign-in { left: 0; width: 50%; z-index: 2; }
        .container.active .sign-in { transform: translateX(100%); }
        .sign-up { left: 0; width: 50%; opacity: 0; z-index: 1; }
        .container.active .sign-up { transform: translateX(100%); opacity: 1; z-index: 5; animation: move 0.6s; }

        @keyframes move { 0%, 49.99% { opacity: 0; z-index: 1; } 50%, 100% { opacity: 1; z-index: 5; } }

        .toggle-container {
            position: absolute; top: 0; left: 50%; width: 50%; height: 100%; overflow: hidden;
            transition: all 0.6s ease-in-out; border-radius: 150px 0 0 100px; z-index: 1000;
        }
        .container.active .toggle-container { transform: translateX(-100%); border-radius: 0 150px 100px 0; }

        .toggle { background: linear-gradient(135deg, var(--sage), var(--moss)); color: var(--ivory); position: relative; left: -100%; width: 200%; height: 100%; transform: translateX(0); transition: all 0.6s ease-in-out; }
        .container.active .toggle { transform: translateX(50%); }

        .toggle-panel { position: absolute; width: 50%; height: 100%; display: flex; align-items: center; justify-content: center; flex-direction: column; padding: 0 45px; text-align: center; top: 0; transform: translateX(0); transition: all 0.6s ease-in-out; }
        .toggle-left { transform: translateX(-200%); }
        .container.active .toggle-left { transform: translateX(0); }
        .toggle-right { right: 0; transform: translateX(0); }
        .container.active .toggle-right { transform: translateX(200%); }

        h1 { color: var(--moss); font-weight: 800; margin-bottom: 5px; letter-spacing: -0.5px; font-size: 2rem; }
        .toggle h1 { color: var(--ivory); }

        div:where(.swal2-container) div:where(.swal2-popup) { border-radius: 24px; font-family: 'Inter', sans-serif; box-shadow: 0 25px 50px rgba(66,57,38,0.2); border: 1px solid var(--border-subtle); }
        div:where(.swal2-container) button:where(.swal2-styled) { border-radius: 14px; font-weight: 700; padding: 10px 30px; }
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
                    confirmButtonColor: '#464704',
                    confirmButtonText: 'Reintentar'
                });
            });
        </script>
    <% } %>

    <div class="container" id="container">
        
        <div class="form-container sign-up">
            <form action="registro" method="POST">
                <div class="brand-emblem"><i class="fa-solid fa-seedling"></i></div>
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
                <div class="brand-emblem"><i class="fa-solid fa-droplet"></i></div>
                <h1>Finca La Rosa</h1>
                <span>Módulo de Gestión Ganadera y Lácteos</span>
                <input type="email" name="email" placeholder="Correo Electrónico" required>
                <div class="password-container">
                    <input type="password" name="password" id="pass_signin" placeholder="Contraseña" required>
                    <i class="fa-solid fa-eye toggle-password" onclick="togglePasswordVisibility('pass_signin', this)"></i>
                </div>
                <a onclick="iniciarRecuperacionOTP()">¿Olvidaste tu contraseña?</a>
                <button type="submit">INGRESAR</button>
            </form>
        </div>
        
        <div class="toggle-container">
            <div class="toggle">
                <div class="toggle-panel toggle-left">
                    <div class="brand-emblem"><i class="fa-solid fa-cow"></i></div>
                    <h1>¡Bienvenido!</h1>
                    <p>Si ya posees un usuario asignado en la finca, inicia sesión para continuar con los registros.</p>
                    <button class="hidden" id="login">Volver</button>
                </div>
                <div class="toggle-panel toggle-right">
                    <div class="brand-emblem"><i class="fa-solid fa-shield-halved"></i></div>
                    <h1>Portal Interno</h1>
                    <p>¿Eres un nuevo operario o veterinario de la finca? Consulta las opciones de registro del sistema.</p>
                    <button class="hidden" id="register">Solicitar</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const container = document.getElementById('container');
        document.getElementById('register').addEventListener('click', () => { container.classList.add("active"); });
        document.getElementById('login').addEventListener('click', () => { container.classList.remove("active"); });

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

        // =========================================================
        // FLUJO DE RECUPERACIÓN DE CONTRASEÑA (OTP)
        // =========================================================
        async function iniciarRecuperacionOTP() {
            const { value: email } = await Swal.fire({
                title: 'Recuperar Contraseña',
                input: 'email',
                inputLabel: 'Ingresa tu correo institucional de la finca',
                inputPlaceholder: 'juan@fincalarosa.com',
                showCancelButton: true,
                confirmButtonColor: '#464704',
                confirmButtonText: 'Enviar Código',
                cancelButtonText: 'Cancelar',
                validationMessage: 'Por favor ingresa un correo válido.'
            });

            if (email) {
                Swal.fire({ title: 'Generando código...', allowOutsideClick: false, didOpen: () => { Swal.showLoading(); } });
                
                let formData = new URLSearchParams();
                formData.append('action', 'request_otp');
                formData.append('email', email);

                try {
                    let response = await fetch('login', { method: 'POST', body: formData });
                    let data = await response.json();

                    if (data.success) {
                        // Simulamos que el operario revisó su correo electrónico
                        await Swal.fire({
                            icon: 'info',
                            title: 'Bandeja de Entrada 📧',
                            html: `Para efectos de esta prueba, simularemos la llegada del correo.<br><br>Tu código de seguridad temporal es: <strong style="font-size: 24px; color: #464704; display: block; margin-top: 10px;">${data.dev_otp}</strong>`,
                            confirmButtonColor: '#464704',
                            confirmButtonText: 'Ya copié mi código'
                        });

                        pedirCodigoDeVerificacion(data.idUsuario);
                    } else {
                        Swal.fire('Atención', data.message, 'warning');
                    }
                } catch (e) {
                    Swal.fire('Error', 'No se pudo comunicar con el servidor.', 'error');
                }
            }
        }

        async function pedirCodigoDeVerificacion(idUsuario) {
            const { value: otp } = await Swal.fire({
                title: 'Verificación de Identidad',
                input: 'text',
                inputLabel: 'Ingresa el código de 6 dígitos que te enviamos',
                inputPlaceholder: '123456',
                inputAttributes: { maxlength: 6 },
                showCancelButton: true,
                confirmButtonColor: '#464704',
                confirmButtonText: 'Validar'
            });

            if (otp) {
                Swal.fire({ title: 'Verificando...', allowOutsideClick: false, didOpen: () => { Swal.showLoading(); } });
                
                let formData = new URLSearchParams();
                formData.append('action', 'verify_otp');
                formData.append('idUsuario', idUsuario);
                formData.append('otp', otp);

                let response = await fetch('login', { method: 'POST', body: formData });
                let data = await response.json();

                if (data.success) {
                    pedirNuevaClave(idUsuario);
                } else {
                    Swal.fire('Código Incorrecto', data.message, 'error').then(() => pedirCodigoDeVerificacion(idUsuario));
                }
            }
        }

        async function pedirNuevaClave(idUsuario) {
            const { value: newPassword } = await Swal.fire({
                title: 'Seguridad Verificada',
                input: 'password',
                inputLabel: 'Por favor, digita tu nueva clave de acceso',
                showCancelButton: true,
                confirmButtonColor: '#464704',
                confirmButtonText: 'Guardar Contraseña'
            });

            if (newPassword) {
                Swal.fire({ title: 'Actualizando sistema...', allowOutsideClick: false, didOpen: () => { Swal.showLoading(); } });
                
                let formData = new URLSearchParams();
                formData.append('action', 'reset_password');
                formData.append('idUsuario', idUsuario);
                formData.append('newPassword', newPassword);

                let response = await fetch('login', { method: 'POST', body: formData });
                let data = await response.json();

                if (data.success) {
                    Swal.fire('¡Contraseña Actualizada!', 'Tu clave ha sido cambiada en la base de datos exitosamente. Ya puedes iniciar sesión.', 'success');
                } else {
                    Swal.fire('Error', data.message, 'error');
                }
            }
        }
    </script>
</body>
</html>