<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar Contraseña | Finca La Rosa</title>
    
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
            --moss: #a3b889;
            --btn-text: #09090b;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }

        body {
            background: var(--bg-body);
            display: flex; align-items: center; justify-content: center; flex-direction: column;
            min-height: 100vh; overflow: hidden;
            transition: background 0.3s ease;
        }

        .container {
            background-color: var(--bg-card);
            border-radius: 40px; 
            border: 1px solid var(--border-color);
            box-shadow: 0 20px 60px var(--shadow-color);
            position: relative; overflow: hidden;
            width: 500px; max-width: 95%; padding: 50px 40px;
            animation: cardScale 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
            text-align: center;
        }

        @keyframes cardScale { from { transform: scale(0.95); opacity: 0; } to { transform: scale(1); opacity: 1; } }

        .brand-emblem {
            background-color: var(--ivory); color: var(--moss); width: 68px; height: 68px; border-radius: 20px;
            display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;
            box-shadow: 0 6px 15px rgba(70, 71, 4, 0.1);
        }

        h1 { color: var(--drab); font-weight: 800; margin-bottom: 5px; font-size: 2rem; letter-spacing: -0.5px; }
        span.subtitle { display: block; font-size: 14px; color: var(--texto-suave); font-weight: 500; margin-bottom: 30px; line-height: 1.5; }

        .input-group { width: 100%; position: relative; margin-bottom: 15px; }
        input {
            width: 100%; padding: 18px 25px; font-size: 15px; border-radius: 18px;
            border: 2px solid var(--input-border); background: var(--input-bg);
            color: var(--text-main); font-weight: 600; text-align: center; transition: all 0.3s;
        }
        input::placeholder { color: var(--texto-suave); opacity: 0.8; font-weight: 500; }
        input:focus { border-color: var(--moss); background: var(--bg-card); outline: none; box-shadow: 0 0 0 5px rgba(70, 71, 4, 0.1); }
        
        button {
            background: var(--moss); color: var(--btn-text); border-radius: 18px; padding: 18px; font-weight: 800;
            border: none; width: 100%; margin-top: 15px; letter-spacing: 1px; font-size: 14px; cursor: pointer;
            transition: all 0.3s; box-shadow: 0 10px 25px rgba(70, 71, 4, 0.25); text-transform: uppercase;
        }
        button:hover:not(:disabled) { background: var(--text-main); color: var(--bg-body); transform: translateY(-3px); box-shadow: 0 15px 30px rgba(0, 0, 0, 0.35); }
        button:disabled { background: var(--texto-suave); cursor: not-allowed; box-shadow: none; transform: none; }

        .btn-logout {
            background: transparent; color: var(--texto-suave); box-shadow: none; border: 2px solid var(--input-border); margin-top: 10px;
        }
        .btn-logout:hover { background: var(--input-bg); color: #dc3545; }
    </style>
</head>
<body>
    <div class="container">
        <div class="brand-emblem">
            <i class="fa-solid fa-lock fa-2x"></i>
        </div>
        <h1>Recuperar Contraseña</h1>
        <span class="subtitle">Ingresa tu correo electrónico registrado y te enviaremos una clave temporal para que puedas acceder.</span>

        <form id="formRecuperar">
            <div class="input-group">
                <input type="email" id="email" name="email" placeholder="Ingresa tu correo electrónico" required>
            </div>
            
            <button type="submit" id="btnSubmit">
                <i class="fa-solid fa-paper-plane me-2"></i> Enviar Clave Temporal
            </button>
            <button type="button" class="btn-logout" onclick="window.location.href='login.jsp'">
                <i class="fa-solid fa-arrow-left"></i> Volver al Login
            </button>
        </form>
    </div>

    <script>
        if (localStorage.getItem('theme') === 'dark' || (!localStorage.getItem('theme') && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
            document.documentElement.setAttribute('data-theme', 'dark');
        }

        document.getElementById('formRecuperar').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('email').value;
            const btn = document.getElementById('btnSubmit');
            btn.disabled = true;
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Procesando...';

            fetch('recuperar_password', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ email: email })
            })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    Swal.fire({
                        icon: 'success',
                        title: '¡Correo Enviado!',
                        text: 'Hemos enviado una clave temporal a tu correo. Por favor revisa tu bandeja de entrada o la carpeta de SPAM.',
                        confirmButtonColor: '#464704',
                        confirmButtonText: 'Ir a Iniciar Sesión'
                    }).then(() => {
                        window.location.href = 'login.jsp';
                    });
                } else {
                    Swal.fire({ icon: 'error', title: 'Ocurrió un problema', text: data.message, confirmButtonColor: '#dc3545' });
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fa-solid fa-paper-plane me-2"></i> Enviar Clave Temporal';
                }
            })
            .catch(err => {
                Swal.fire({ icon: 'error', title: 'Error', text: 'No se pudo conectar con el servidor.', confirmButtonColor: '#dc3545'});
                btn.disabled = false;
                btn.innerHTML = '<i class="fa-solid fa-paper-plane me-2"></i> Enviar Clave Temporal';
            });
        });
    </script>
</body>
</html>
