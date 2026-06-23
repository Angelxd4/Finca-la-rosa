<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finca La Rosa | Sistema Ganadero</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/premium-ui.css">

    <style>
        :root {
            /* Paleta Oficial Finca La Rosa */
            --moss: #464704;
            --sage: #9CA889;
            --khaki: #B7A78C;
            --drab: #423926;
            --ivory: #F3F5E7;
            --text-dark: #2b3445;
        }

        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #f8f9fa;
            color: var(--text-dark);
            overflow-x: hidden;
        }

        /* --- NAVEGACIÓN PÚBLICA --- */
        .navbar-public {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(70, 71, 4, 0.08);
            padding: 15px 0;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
        }

        .navbar-brand {
            font-weight: 800;
            color: var(--drab) !important;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        /* Contenedor del nuevo logo */
        .brand-icon {
            background: var(--ivory);
            color: var(--moss);
            width: 45px;
            height: 45px;
            border-radius: 14px;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 4px 10px rgba(70, 71, 4, 0.15);
        }

        .btn-login-outline {
            border: 2px solid var(--moss);
            color: var(--moss);
            font-weight: 700;
            padding: 8px 25px;
            border-radius: 50px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
        }

        .btn-login-outline:hover {
            background: var(--moss);
            color: white;
            box-shadow: 0 5px 15px rgba(70, 71, 4, 0.25);
        }

        /* --- SECCIÓN HERO (PORTADA) --- */
        .hero-section {
            padding: 160px 0 100px;
            background: linear-gradient(135deg, var(--ivory) 0%, #ffffff 100%);
            position: relative;
            overflow: hidden;
        }

        .hero-shape-1 {
            position: absolute;
            top: -100px;
            right: -100px;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(156, 168, 137, 0.15) 0%, transparent 70%);
            border-radius: 50%;
            z-index: 0;
        }

        .hero-shape-2 {
            position: absolute;
            bottom: 0;
            left: -150px;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(70, 71, 4, 0.08) 0%, transparent 70%);
            border-radius: 50%;
            z-index: 0;
        }

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .hero-badge {
            background: rgba(156, 168, 137, 0.2);
            color: var(--moss);
            padding: 8px 20px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.85rem;
            display: inline-block;
            margin-bottom: 20px;
            letter-spacing: 1px;
            border: 1px solid rgba(156, 168, 137, 0.4);
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 20px;
            color: var(--drab);
            letter-spacing: -1px;
        }

        .hero-title span {
            color: var(--moss);
            background: linear-gradient(120deg, var(--moss), var(--sage));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-text {
            font-size: 1.1rem;
            color: #555;
            margin-bottom: 40px;
            line-height: 1.7;
            max-width: 90%;
        }

        .btn-primary-custom {
            background: var(--moss);
            color: white;
            padding: 15px 40px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            border: none;
            transition: all 0.3s ease;
            box-shadow: 0 10px 25px rgba(70, 71, 4, 0.3);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .btn-primary-custom:hover {
            background: var(--drab);
            transform: translateY(-3px);
            color: white;
            box-shadow: 0 15px 35px rgba(66, 57, 38, 0.4);
        }

        /* --- TARJETAS DE CARACTERÍSTICAS --- */
        .features-section {
            padding: 80px 0;
            background: #ffffff;
            position: relative;
            z-index: 1;
        }

        .feature-card {
            background: #ffffff;
            border: 1px solid #f0f0f0;
            border-radius: 24px;
            padding: 40px 30px;
            height: 100%;
            transition: all 0.4s ease;
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 4px;
            background: var(--moss);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s ease;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(70, 71, 4, 0.1);
        }

        .feature-card:hover::before {
            transform: scaleX(1);
        }

        .feature-icon {
            width: 60px;
            height: 60px;
            background: var(--ivory);
            color: var(--moss);
            border-radius: 16px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 1.8rem;
            margin-bottom: 25px;
            transition: all 0.3s ease;
        }

        .feature-card:hover .feature-icon {
            background: var(--moss);
            color: white;
            transform: rotate(5deg) scale(1.1);
        }

        .feature-title {
            font-weight: 800;
            font-size: 1.25rem;
            margin-bottom: 15px;
            color: var(--drab);
        }

        .feature-text {
            color: #6c757d;
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 0;
        }

        /* --- FOOTER --- */
        .footer {
            background: var(--drab);
            color: var(--khaki);
            padding: 40px 0;
            text-align: center;
        }
        
        .footer-brand {
            color: white;
            font-weight: 800;
            font-size: 1.2rem;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
    </style>
</head>
<body>

    <nav class="navbar-public">
        <div class="container d-flex justify-content-between align-items-center">
            <a href="index.jsp" class="navbar-brand text-decoration-none">
                <div class="brand-icon">
                    <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 16v6" />
                        <path d="M12 20a4 4 0 0 1-3-3" />
                        <path d="M12 18a4 4 0 0 0 3-3" />
                        <path d="M12 16c-4.5 0-7-3.5-7-7 0-3 3-5 7-5s7 2 7 5c0 3.5-2.5 7-7 7z" />
                        <path d="M12 4c-2 2-2 5 0 7s4 2 5 1" />
                        <path d="M12 11c-1.5-1-1.5-3 0-4" />
                    </svg>
                </div>
                La Rosa
            </a>
            <div>
                <a href="login" class="btn-login-outline text-decoration-none">
                    <i class="bi bi-person-fill me-1"></i> Ingresar
                </a>
            </div>
        </div>
    </nav>

    <section class="hero-section">
        <div class="hero-shape-1"></div>
        <div class="hero-shape-2"></div>
        <div class="container hero-content">
            <div class="row align-items-center">
                <div class="col-lg-7 mb-5 mb-lg-0">
                    <div class="hero-badge">SISTEMA INTEGRAL WEB</div>
                    <h1 class="hero-title">Gestión Ganadera y Producción <span>Inteligente</span></h1>
                    <p class="hero-text">
                        Plataforma centralizada para el control del inventario bovino, monitoreo de bioseguridad, ordeño en tiempo real y transformación de lácteos. Diseñado para optimizar los procesos de la Finca La Rosa.
                    </p>
                    <a href="login" class="btn-primary-custom btn-ripple">
                        Acceder al Portal <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
                <div class="col-lg-5">
                    <div class="position-relative d-flex justify-content-center">
                        <div style="width: 350px; height: 450px; background: linear-gradient(135deg, var(--moss), var(--sage)); border-radius: 40px; transform: rotate(5deg); position: absolute; z-index: 1; opacity: 0.25;"></div>
                        <div style="width: 350px; height: 450px; background: white; border-radius: 40px; z-index: 2; box-shadow: 0 25px 60px rgba(66, 57, 38, 0.15); padding: 30px; display: flex; flex-direction: column; gap: 20px;">
                            <div style="width: 50%; height: 15px; background: var(--ivory); border-radius: 10px;"></div>
                            <div style="width: 100%; height: 120px; background: #f8f9fa; border-radius: 20px; border: 1.5px dashed var(--sage);"></div>
                            <div class="d-flex gap-3">
                                <div style="flex: 1; height: 80px; background: var(--ivory); border-radius: 15px;"></div>
                                <div style="flex: 1; height: 80px; background: var(--ivory); border-radius: 15px;"></div>
                            </div>
                            <div style="width: 80%; height: 15px; background: #f8f9fa; border-radius: 10px; margin-top: auto;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="features-section">
        <div class="container">
            <div class="text-center mb-5 pb-3">
                <h2 class="fw-bolder" style="color: var(--drab);">Módulos del Sistema</h2>
                <p class="text-muted">Herramientas profesionales para el desarrollo del agro.</p>
            </div>
            
            <div class="row g-4">
                <div class="col-lg-3 col-md-6">
                    <div class="feature-card animate-fade-in-up delay-100">
                        <div class="feature-icon"><i class="bi bi-clipboard2-data-fill"></i></div>
                        <h3 class="feature-title">Inventario Bovino</h3>
                        <p class="feature-text">Control exacto del hato ganadero, clasificando animales por producción, venta y crías con validaciones biológicas.</p>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="feature-card animate-fade-in-up delay-200">
                        <div class="feature-icon"><i class="bi bi-shield-plus"></i></div>
                        <h3 class="feature-title">Bioseguridad</h3>
                        <p class="feature-text">Registro clínico de tratamientos y alertas asíncronas para apartar la leche de descarte del tanque comercial.</p>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="feature-card animate-fade-in-up delay-300">
                        <div class="feature-icon"><i class="bi bi-droplet-half"></i></div>
                        <h3 class="feature-title">Ordeño y Lácteos</h3>
                        <p class="feature-text">Cálculo de eficiencia de ordeño en tiempo real y módulo de fábrica para transformar leche cruda en productos.</p>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="feature-card animate-fade-in-up delay-400">
                        <div class="feature-icon"><i class="bi bi-kanban"></i></div>
                        <h3 class="feature-title">Tablero Kanban</h3>
                        <p class="feature-text">Gestión ágil para asignar responsabilidades a operarios y veterinarios mediante sistema interactivo Drag & Drop.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="container">
            <div class="footer-brand">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 16v6" />
                    <path d="M12 20a4 4 0 0 1-3-3" />
                    <path d="M12 18a4 4 0 0 0 3-3" />
                    <path d="M12 16c-4.5 0-7-3.5-7-7 0-3 3-5 7-5s7 2 7 5c0 3.5-2.5 7-7 7z" />
                    <path d="M12 4c-2 2-2 5 0 7s4 2 5 1" />
                    <path d="M12 11c-1.5-1-1.5-3 0-4" />
                </svg>
                Finca La Rosa
            </div>
            <p class="mb-0" style="font-size: 0.85rem;">
                Desarrollo de Software ADSO &copy; 2026. Todos los derechos reservados.
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>