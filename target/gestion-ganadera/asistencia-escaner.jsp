<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
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
            border-radius: 32px;
            box-shadow: var(--shadow-apple);
            padding: 40px;
            width: 100%;
            max-width: 500px;
            text-align: center;
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

        /* Toggle Button Group */
        .btn-group-toggle {
            display: flex;
            background: #f5f5f7;
            border-radius: 20px;
            padding: 5px;
            margin-bottom: 30px;
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
            background: #ffffff;
            color: var(--brand-primary);
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        #reader {
            border-radius: 20px;
            overflow: hidden;
            border: 2px dashed #d2d2d7 !important;
            margin-bottom: 20px;
        }

        #reader button {
            background-color: var(--brand-primary);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 10px;
            font-weight: 600;
            margin-top: 10px;
        }

    </style>
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
        
        <div class="mt-4">
            <a href="login" class="text-decoration-none" style="color: var(--brand-info); font-weight: 600; font-size: 0.9rem;">
                <i class="bi bi-arrow-left"></i> Volver al Login
            </a>
        </div>
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