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

    <style>
        :root {
            --brand-main: #1C7345;
            --brand-hover: #165c37;
            --brand-accent: #00A859;
            --brand-light: #eaf6ee;
            --text-dark: #1d1d1f;
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
            border-bottom: 1px solid rgba(0,0,0,0.05);
            padding: 15px 0;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
        }

        .navbar-brand {
            font-weight: 800;
            color: var(--brand-main) !important;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .brand-icon {
            background: linear-gradient(135deg, var(--brand-main), var(--brand-accent));
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 12px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 1.2rem;
        }

        .btn-login-outline {
            border: 2px solid var(--brand-main);
            color: var(--brand-main);
            font-weight: 700;
            padding: 8px 25px;
            border-radius: 50px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
        }

        .btn-login-outline:hover {
            background: var(--brand-main);
            color: white;
            box-shadow: 0 5px 15px rgba(28, 115, 69, 0.2);
        }

        /* --- SECCIÓN HERO (PORTADA) --- */
        .hero-section {
            padding: 160px 0 100px;
            background: linear-gradient(135deg, #f0f7f3 0%, #ffffff 100%);
            position: relative;
            overflow: hidden;
        }

        .hero-shape-1 {
            position: absolute;
            top: -100px;
            right: -100px;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(0, 168, 89, 0.08) 0%, transparent 70%);
            border-radius: 50%;
            z-index: 0;
        }

        .hero-shape-2 {
            position: absolute;
            bottom: 0;
            left: -150px;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(28, 115, 69, 0.05) 0%, transparent 70%);
            border-radius: 50%;
            z-index: 0;
        }

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .hero-badge {
            background: var(--brand-light);
            color: var(--brand-main);
            padding: 8px 20px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.85rem;
            display: inline-block;
            margin-bottom: 20px;
            letter-spacing: 1px;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 20px;
            color: #1a1a1a;
            letter-spacing: -1px;
        }

        .hero-title span {
            color: var(--brand-main);
        }

        .hero-text {
            font-size: 1.1rem;
            color: #555;
            margin-bottom: 40px;
            line-height: 1.7;
            max-width: 90%;
        }

        .btn-primary-custom {
            background: var(--brand-main);
            color: white;
            padding: 15px 40px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            border: none;
            transition: all 0.3s ease;
            box-shadow: 0 10px 25px rgba(28, 115, 69, 0.3);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .btn-primary-custom:hover {
            background: var(--brand-hover);
            transform: translateY(-3px);
            color: white;
            box-shadow: 0 15px 35px rgba(28, 115, 69, 0.4);
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
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(28, 115, 69, 0.08);
            border-color: #eaf6ee;
        }

        .feature-icon {
            width: 60px;
            height: 60px;
            background: var(--brand-light);
            color: var(--brand-main);
            border-radius: 16px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 1.8rem;
            margin-bottom: 25px;
            transition: all 0.3s ease;
        }

        .feature-card:hover .feature-icon {
            background: var(--brand-main);
            color: white;
        }

        .feature-title {
            font-weight: 800;
            font-size: 1.25rem;
            margin-bottom: 15px;
            color: #2b3445;
        }

        .feature-text {
            color: #6c757d;
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 0;
        }

        /* --- FOOTER --- */
        .footer {
            background: #1a201d;
            color: #8c9c93;
            padding: 40px 0;
            text-align: center;
        }
        
        .footer-brand {
            color: white;
            font-weight: 800;
            font-size: 1.2rem;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

    <nav class="navbar-public">
        <div class="container d-flex justify-content-between align-items-center">
            <a href="index.jsp" class="navbar-brand text-decoration-none">
                <div class="brand-icon">
                    <i class="bi bi-moisture"></i>
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
                    <a href="login" class="btn-primary-custom">
                        Acceder al Portal <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
                <div class="col-lg-5">
                    <div class="position-relative d-flex justify-content-center">
                        <div style="width: 350px; height: 450px; background: linear-gradient(135deg, #1C7345, #00A859); border-radius: 40px; transform: rotate(5deg); position: absolute; z-index: 1; opacity: 0.1;"></div>
                        <div style="width: 350px; height: 450px; background: white; border-radius: 40px; z-index: 2; box-shadow: 0 20px 50px rgba(0,0,0,0.1); padding: 30px; display: flex; flex-direction: column; gap: 20px;">
                            <div style="width: 50%; height: 15px; background: #eaf6ee; border-radius: 10px;"></div>
                            <div style="width: 100%; height: 120px; background: #f8f9fa; border-radius: 20px; border: 1px dashed #dee2e6;"></div>
                            <div class="d-flex gap-3">
                                <div style="flex: 1; height: 80px; background: #eaf6ee; border-radius: 15px;"></div>
                                <div style="flex: 1; height: 80px; background: #eaf6ee; border-radius: 15px;"></div>
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
                <h2 class="fw-bolder" style="color: #1a1a1a;">Módulos del Sistema</h2>
                <p class="text-muted">Herramientas profesionales para el desarrollo del agro.</p>
            </div>
            
            <div class="row g-4">
                <div class="col-lg-3 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-clipboard2-data-fill"></i>
                        </div>
                        <h3 class="feature-title">Inventario Bovino</h3>
                        <p class="feature-text">Control exacto del hato ganadero, clasificando animales por producción, venta y crías con validaciones biológicas.</p>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-shield-plus"></i>
                        </div>
                        <h3 class="feature-title">Bioseguridad</h3>
                        <p class="feature-text">Registro clínico de tratamientos y alertas asíncronas para apartar la leche de descarte del tanque comercial.</p>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-droplet-half"></i>
                        </div>
                        <h3 class="feature-title">Ordeño y Lácteos</h3>
                        <p class="feature-text">Cálculo de eficiencia de ordeño en tiempo real y módulo de fábrica para transformar leche cruda en productos.</p>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-kanban"></i>
                        </div>
                        <h3 class="feature-title">Tablero de Tareas</h3>
                        <p class="feature-text">Gestión ágil (Kanban) para asignar responsabilidades a operarios y veterinarios mediante sistema Drag & Drop.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="container">
            <div class="footer-brand">
                <i class="bi bi-moisture me-2" style="color: var(--brand-accent);"></i>Finca La Rosa
            </div>
            <p class="mb-0" style="font-size: 0.85rem;">
                Desarrollo de Software ADSO &copy; 2026. Todos los derechos reservados.
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>