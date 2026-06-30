<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Escaner de Asistencia | Finca La Rosa</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <script src="https://unpkg.com/html5-qrcode"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            --bg-page: #F3F5E7 !important;     
            --bg-card: #FFFFFF !important;
            --brand-primary: #464704 !important; 
            --brand-info: #9CA889 !important;    
            --brand-dark: #423926 !important;    
            --text-main: #1d1d1f !important;
            --text-subtle: #86868b !important;
            --shadow-apple: 0 4px 6px rgba(0, 0, 0, 0.02), 0 10px 20px rgba(0, 0, 0, 0.04);
            --toggle-bg: #f5f5f7;
            --toggle-active-bg: #ffffff;
            --reader-border: #d2d2d7;
            --border-subtle: rgba(0,0,0,0.1);
        }

        /* DARK MODE PALETTE - PREMIUM ZINC */
        html[data-theme="dark"] {
            --bg-page: #09090b !important;
            --bg-card: #18181b !important;
            --text-main: #f4f4f5 !important;
            --text-subtle: #a1a1aa !important;
            --brand-dark: #f4f4f5 !important;
            --brand-primary: #a3b889 !important; /* Bright Sage */
            --shadow-apple: 0 10px 40px rgba(0, 0, 0, 0.8);
            --toggle-bg: #09090b;
            --toggle-active-bg: #27272a;
            --reader-border: #27272a;
            --border-subtle: #27272a;
        }

        body { 
            font-family: 'Inter', sans-serif; 
            background-color: var(--bg-page) !important; 
            color: var(--text-main); 
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .scanner-card {
            background: var(--bg-card);
            border-radius: 36px;
            box-shadow: var(--shadow-apple);
            padding: 50px 40px;
            width: 100%;
            max-width: 500px;
            text-align: center;
            border: 1px solid var(--border-subtle);
        }

        .brand-icon {
            font-size: 3rem;
            color: var(--brand-primary);
            margin-bottom: 10px;
        }

        .title {
            font-weight: 800;
            color: var(--brand-dark);
            margin-bottom: 5px;
        }

        .subtitle {
            color: var(--text-subtle);
            margin-bottom: 30px;
            font-size: 0.95rem;
        }

        /* iOS-style Segmented Control */
        .btn-group-toggle {
            display: flex;
            background: var(--toggle-bg);
            border-radius: 18px;
            padding: 6px;
            margin-bottom: 30px;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
        }

        .btn-toggle {
            flex: 1;
            border: none;
            background: transparent;
            padding: 12px;
            font-weight: 600;
            color: var(--text-subtle);
            border-radius: 15px;
            transition: all 0.3s ease;
        }

        .btn-toggle.active {
            background: var(--toggle-active-bg);
            color: var(--brand-primary);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            font-weight: 700;
        }

        #reader {
            border-radius: 24px;
            overflow: hidden;
            border: 2px dashed var(--reader-border) !important;
            margin-bottom: 20px;
            background: var(--toggle-bg);
            padding: 10px;
        }

        #reader button {
            background-color: var(--brand-primary);
            color: #09090b;
            border: none;
            padding: 10px 20px;
            border-radius: 12px;
            font-weight: 700;
            margin-top: 15px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
        }
        
        #reader button:hover {
            transform: translateY(-2px);
            opacity: 0.9;
        }

        /* Invertir el ícono de la cámara de html5-qrcode en modo oscuro */
        html[data-theme="dark"] #reader img {
            filter: invert(1);
            opacity: 0.8;
        }
        
        /* Asegurar que los textos de error o mensajes del lector sean visibles */
        html[data-theme="dark"] #reader span {
            color: var(--text-main) !important;
        }

        /* SweetAlert2 Dark Mode overrides */
        div:where(.swal2-container) div:where(.swal2-popup) {
            border-radius: 30px !important;
            background: var(--bg-card) !important;
            color: var(--text-main) !important;
            box-shadow: var(--shadow-apple) !important;
        }
        div:where(.swal2-container) h2:where(.swal2-title) { color: var(--brand-dark) !important; }
        div:where(.swal2-container) div:where(.swal2-html-container) { color: var(--text-subtle) !important; }

    </style>
    <script>
        // Sincronizar con el tema elegido en el resto de la app
        if (localStorage.getItem('theme') === 'light') {
            document.documentElement.setAttribute('data-theme', 'light');
        } else {
            document.documentElement.setAttribute('data-theme', 'dark'); // Por defecto oscuro
        }
    </script>
</head>
<body>
    
    <div class="scanner-card">
        <i class="bi bi-qr-code-scan brand-icon"></i>
        <h3 class="title">Control de Asistencia</h3>
        <p class="subtitle">Selecciona el tipo de registro y escanea tu carnet</p>

        <div class="btn-group-toggle">
            <button class="btn-toggle active" id="btnEntrada" onclick="setTipoRegistro('entrada')">
                <i class="bi bi-box-arrow-in-right me-2"></i>Entrada
            </button>
            <button class="btn-toggle" id="btnSalida" onclick="setTipoRegistro('salida')">
                <i class="bi bi-box-arrow-right me-2"></i>Salida
            </button>
        </div>

        <div id="reader"></div>
        
        <!-- Botón de salir eliminado para modo kiosco -->
    </div>

    <script>
        let tipoRegistroActual = 'entrada'; // Por defecto

        function setTipoRegistro(tipo) {
            tipoRegistroActual = tipo;
            document.getElementById('btnEntrada').classList.remove('active');
            document.getElementById('btnSalida').classList.remove('active');
            
            if (tipo === 'entrada') {
                document.getElementById('btnEntrada').classList.add('active');
            } else {
                document.getElementById('btnSalida').classList.add('active');
            }
        }

        let isScanning = false;

        function onScanSuccess(decodedText, decodedResult) {
            if (isScanning) return; // Prevenir múltiples escaneos
            isScanning = true;
            html5QrcodeScanner.pause(true); // Pausar escáner

            // Enviamos el código escaneado al Servlet
            fetch('asistencia-registro', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'qrData=' + encodeURIComponent(decodedText) + '&tipoRegistro=' + tipoRegistroActual
            })
            .then(res => res.text())
            .then(msg => {
                if (msg.startsWith('OK')) {
                    Swal.fire({
                        icon: 'success',
                        title: '¡Registrado!',
                        text: msg.substring(4),
                        confirmButtonColor: '#464704',
                        timer: 3000,
                        timerProgressBar: true
                    }).then(() => {
                        isScanning = false;
                        html5QrcodeScanner.resume();
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: msg.startsWith('ERROR:') ? msg.substring(7) : msg,
                        confirmButtonColor: '#dc3545'
                    }).then(() => {
                        isScanning = false;
                        html5QrcodeScanner.resume();
                    });
                }
            })
            .catch(err => {
                Swal.fire('Error', 'No se pudo conectar con el servidor', 'error');
                isScanning = false;
                html5QrcodeScanner.resume();
            });
        }

        let html5QrcodeScanner = new Html5QrcodeScanner("reader", { fps: 10, qrbox: 250 });
        html5QrcodeScanner.render(onScanSuccess);
    </script>
</body>
</html>