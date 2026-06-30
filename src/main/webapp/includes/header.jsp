<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finca La Rosa</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.1/css/buttons.bootstrap5.min.css">
    
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            --bg-page: #F3F5E7 !important;
            --bg-card: #FFFFFF !important;
            --brand-primary: #464704 !important;
            --brand-accent: #B7A78C !important;
            --brand-info: #9CA889 !important;
            --brand-dark: #423926 !important;
            --text-main: #423926 !important;
            --text-subtle: #7A7463 !important;
            --border-subtle: #E2E4D5 !important;
        }

        body { 
            font-family: 'Inter', sans-serif; 
            background-color: var(--bg-page) !important; 
            color: var(--text-main); 
        }
        
        .dash-card, .panel-finca, .glass-panel { 
            background: var(--bg-card); 
            border-radius: 20px; 
            border: 1px solid var(--border-subtle); 
            box-shadow: 0 10px 15px -3px rgba(66, 57, 38, 0.05); 
            padding: 24px; 
            height: 100%; 
            transition: transform 0.3s ease, box-shadow 0.3s ease; 
        }
        .dash-card:hover, .panel-finca:hover, .glass-panel:hover { 
            transform: translateY(-3px); 
            box-shadow: 0 15px 25px rgba(66, 57, 38, 0.1); 
            border-color: var(--brand-accent); 
        }
        
        .card-title { 
            font-size: 0.95rem; 
            font-weight: 800; 
            color: var(--brand-dark); 
            margin-bottom: 20px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            text-transform: uppercase; 
            letter-spacing: 0.5px;
        }

        .btn-brand { background-color: var(--brand-primary); color: white; border: none; font-weight: 600; }
        .btn-brand:hover { background-color: var(--brand-dark); color: white; }
        
        .btn-outline-brand { color: var(--brand-primary); border-color: var(--brand-primary); font-weight: 600; }
        .btn-outline-brand:hover { background-color: var(--brand-primary); color: white; }

        .form-control, .form-select {
            border-color: var(--border-subtle);
            border-radius: 12px;
            padding: 0.7rem 1rem;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 0.25rem rgba(138, 159, 109, 0.25);
        }

        /* Utilidades globales */
        .text-brand { color: var(--brand-primary) !important; }
        .bg-brand { background-color: var(--brand-primary) !important; color: white !important; }
        .text-subtle { color: var(--text-subtle) !important; }

        /* Ajustes Globales para Dispositivos Móviles (Responsive) */
        @media (max-width: 768px) {
            /* Hacer que todas las tablas envueltas sean scrollables horizontalmente */
            .table-custom-wrapper, .module-container, .table-responsive {
                overflow-x: auto !important;
                overflow-y: hidden !important;
                -webkit-overflow-scrolling: touch; /* Scroll táctil suave */
            }
            .table th, .table td {
                white-space: nowrap !important; /* Evitar que las columnas se aplasten */
            }
            
            /* Ajustar ventanas modales para celulares */
            .modal-content {
                border-radius: 20px !important;
            }
            .modal-header, .modal-footer, .modal-body {
                padding: 15px !important; /* Reducir espacios gigantes */
            }
            .modal-dialog {
                margin: 0.5rem !important; /* Aprovechar más el ancho de la pantalla */
            }
            .form-control, .form-select {
                padding: 10px 14px !important; /* Achicar un poco los inputs */
            }
            .glass-panel, .dash-card, .panel-finca {
                padding: 15px !important; /* Reducir padding de paneles principales */
                border-radius: 16px !important;
            }
        }
    </style>
</head>
<body>
