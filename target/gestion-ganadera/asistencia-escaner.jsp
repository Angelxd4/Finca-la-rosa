<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Control de Asistencia | Finca La Rosa</title>
    <script src="https://unpkg.com/html5-qrcode"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light text-center py-5">
    
    <div class="container">
        <h3><i class="bi bi-camera-fill"></i> Escanear Carnet QR</h3>
        <div id="reader" style="width: 100%; max-width: 500px; margin: auto;"></div>
        <div id="resultado" class="mt-3 h4"></div>
    </div>

    <script>
        function onScanSuccess(decodedText, decodedResult) {
            // Enviamos el código escaneado al Servlet
            fetch('asistencia-registro', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'qrData=' + encodeURIComponent(decodedText)
            })
            .then(res => res.text())
            .then(msg => {
                document.getElementById('resultado').innerText = msg;
                // Detener escáner tras éxito
                html5QrcodeScanner.clear();
            });
        }

        let html5QrcodeScanner = new Html5QrcodeScanner("reader", { fps: 10, qrbox: 250 });
        html5QrcodeScanner.render(onScanSuccess);
    </script>
</body>
</html>