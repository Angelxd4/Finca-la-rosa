<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finca La Rosa | Tradición y Excelencia Ganadera</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            /* LIGHT MODE PALETTE (Default) */
            --moss: #464704;
            --moss-dark: #353602;
            --sage: #9CA889;
            --khaki: #B7A78C;
            
            --bg-dark: #f8f9fa; /* Background */
            --bg-section: #ffffff; /* Section background */
            --card-bg: rgba(255, 255, 255, 0.9);
            --card-border: rgba(70, 71, 4, 0.08);
            
            --text-main: #2b3445;
            --text-muted: #555555;
            --text-heading: #423926;
            
            --nav-bg: rgba(255, 255, 255, 0.95);
            --overlay: rgba(70, 71, 4, 0.6);
            --badge-bg: rgba(255, 255, 255, 0.9);
            --product-card-bg: #ffffff;
            --product-card-hover: #ffffff;
            --contact-card-bg: var(--text-heading);
            --contact-card-text: #ffffff;
            --footer-bg: #2b2b2b;
            --footer-text: #b7b7b7;
        }

        [data-theme="dark"] {
            /* DARK MODE PALETTE */
            --moss: #9ca646;       /* Bright moss green for highlights */
            --moss-dark: #68702c;  /* Darker moss for hover states */
            --sage: #A4B291;       /* Soft sage */
            --khaki: #c4b69d;      /* Warm accent */
            
            --bg-dark: #0d0e0c;    /* Very dark green-tinted black */
            --bg-section: #141612; /* Slightly lighter section background */
            --card-bg: rgba(255, 255, 255, 0.04);
            --card-border: rgba(255, 255, 255, 0.08);
            
            --text-main: #e2e4e0;  /* Off-white text */
            --text-muted: #9ba195; /* Muted text */
            --text-heading: #ffffff; /* Pure white headings */
            
            --nav-bg: rgba(13, 14, 12, 0.85);
            --overlay: rgba(13, 14, 12, 0.8);
            --badge-bg: rgba(13, 14, 12, 0.7);
            --product-card-bg: var(--card-bg);
            --product-card-hover: rgba(255, 255, 255, 0.08);
            --contact-card-bg: var(--card-bg);
            --contact-card-text: var(--text-main);
            --footer-bg: #090a08;
            --footer-text: #8c9387;
        }

        html, body {
            font-family: 'Montserrat', sans-serif;
            background-color: var(--bg-dark);
            color: var(--text-main);
            overflow-x: hidden;
            max-width: 100%;
            scroll-behavior: smooth;
        }

        /* --- NAVEGACIÓN PÚBLICA --- */
        .navbar-public {
            background: var(--nav-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--card-border);
            padding: 15px 0;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
        }

        .navbar-brand {
            font-weight: 800;
            color: var(--text-heading) !important;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand-icon {
            background: var(--card-bg);
            color: var(--moss);
            width: 45px;
            height: 45px;
            border-radius: 14px;
            display: flex;
            justify-content: center;
            align-items: center;
            border: 1px solid var(--card-border);
            box-shadow: 0 4px 15px rgba(156, 166, 70, 0.15);
        }

        .nav-link {
            color: var(--text-main) !important;
            font-weight: 600;
            font-size: 0.95rem;
            transition: color 0.3s, text-shadow 0.3s;
        }

        .nav-link:hover {
            color: var(--moss) !important;
            text-shadow: 0 0 10px rgba(156, 166, 70, 0.4);
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
            text-decoration: none;
        }

        .btn-login-outline:hover {
            background: var(--moss);
            color: var(--bg-dark);
            box-shadow: 0 5px 20px rgba(156, 166, 70, 0.3);
        }

        /* --- SECCIÓN HERO --- */
        .hero-section {
            padding: 160px 0 100px;
            background: radial-gradient(circle at 50% -20%, #1a1f14 0%, var(--bg-dark) 80%);
            position: relative;
            overflow: hidden;
        }

        .hero-shape-1 {
            position: absolute;
            top: -100px;
            right: -100px;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(156, 166, 70, 0.15) 0%, transparent 70%);
            border-radius: 50%;
            z-index: 0;
        }

        .hero-shape-2 {
            position: absolute;
            bottom: 0;
            left: -150px;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(164, 178, 145, 0.1) 0%, transparent 70%);
            border-radius: 50%;
            z-index: 0;
        }

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .hero-badge {
            background: var(--card-bg);
            color: var(--moss);
            padding: 8px 20px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.85rem;
            display: inline-block;
            margin-bottom: 20px;
            letter-spacing: 1px;
            border: 1px solid var(--card-border);
            backdrop-filter: blur(10px);
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 20px;
            color: var(--text-heading);
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
            color: var(--text-muted);
            margin-bottom: 40px;
            line-height: 1.7;
            max-width: 90%;
        }

        .btn-primary-custom {
            background: var(--moss);
            color: var(--bg-dark);
            padding: 15px 40px;
            border-radius: 50px;
            font-weight: 800;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            border: none;
            transition: all 0.3s ease;
            box-shadow: 0 10px 25px rgba(156, 166, 70, 0.3);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .btn-primary-custom:hover {
            background: #b1bb64;
            transform: translateY(-3px);
            color: var(--bg-dark);
            box-shadow: 0 15px 35px rgba(156, 166, 70, 0.5);
        }

        .mockup-container {
            width: 100%;
            max-width: 350px;
            height: 450px;
            position: relative;
            margin: 0 auto;
        }

        /* --- SECCIÓN NOSOTROS --- */
        .about-section {
            padding: 100px 0;
            background: var(--bg-section);
        }

        .about-image-box {
            position: relative;
            border-radius: 30px;
            overflow: hidden;
            box-shadow: 0 25px 60px rgba(0,0,0,0.5);
        }

        .about-image-box img {
            width: 100%;
            height: auto;
            display: block;
        }
        
        .about-image-overlay {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(0deg, var(--overlay) 0%, rgba(0,0,0,0) 100%);
        }

        .about-badge {
            position: absolute;
            bottom: 30px;
            left: 30px;
            background: var(--badge-bg);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            padding: 15px 25px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            border: 1px solid var(--card-border);
        }

        .about-badge-icon {
            font-size: 2rem;
            color: var(--moss);
        }

        /* --- SECCIÓN PRODUCTOS --- */
        .products-section {
            padding: 100px 0;
            background: var(--bg-dark);
        }

        .product-card {
            background: var(--product-card-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-radius: 24px;
            padding: 40px 30px;
            height: 100%;
            transition: all 0.4s ease;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            position: relative;
            overflow: hidden;
            text-align: center;
            border: 1px solid var(--card-border);
        }

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 25px 50px rgba(0,0,0,0.4);
            border-color: var(--moss);
            background: var(--product-card-hover);
        }

        .product-icon {
            width: 80px;
            height: 80px;
            background: rgba(156, 166, 70, 0.1);
            color: var(--moss);
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 2.5rem;
            margin: 0 auto 25px auto;
            transition: all 0.3s ease;
            border: 1px solid rgba(156, 166, 70, 0.3);
        }

        .product-card:hover .product-icon {
            background: var(--moss);
            color: var(--bg-dark);
            transform: scale(1.1);
            box-shadow: 0 0 20px rgba(156, 166, 70, 0.4);
        }

        /* --- SECCIÓN UBICACIÓN --- */
        .contact-section {
            padding: 100px 0;
            background: var(--bg-section);
        }

        .contact-card {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            color: var(--text-main);
            border-radius: 30px;
            padding: 50px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.3);
            border: 1px solid var(--card-border);
            height: 100%;
        }

        .map-container {
            border-radius: 30px;
            overflow: hidden;
            box-shadow: 0 25px 60px rgba(0,0,0,0.3);
            border: 1px solid var(--card-border);
            height: 100%;
            min-height: 400px;
        }

        /* --- FOOTER --- */
        .footer {
            background: #090a08;
            color: #8c9387;
            padding: 60px 0 30px;
            border-top: 1px solid var(--card-border);
        }
        
        .footer-brand {
            color: var(--text-heading);
            font-weight: 800;
            font-size: 1.5rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* --- RESPONSIVIDAD --- */
        @media (max-width: 991px) {
            .hero-section {
                padding: 110px 0 50px;
                text-align: center;
            }
            .hero-title {
                font-size: 2.2rem;
            }
            .hero-text {
                margin: 0 auto 30px auto;
                font-size: 0.95rem;
                max-width: 100%;
            }
            .mockup-container {
                max-width: 90%;
                height: 350px;
                margin-top: 20px;
            }
            .about-section, .products-section, .contact-section {
                padding: 60px 0;
            }
            .about-image-box img {
                height: 350px;
            }
            .about-badge {
                bottom: 15px;
                left: 15px;
                right: 15px;
                padding: 10px 15px;
            }
            .about-badge-icon {
                font-size: 1.5rem;
            }
            .map-container {
                min-height: 250px;
            }
            .navbar-collapse {
                background: rgba(13, 14, 12, 0.95);
                backdrop-filter: blur(20px);
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.5);
                margin-top: 15px;
                text-align: center;
                border: 1px solid var(--card-border);
            }
            .btn-login-outline {
                display: block;
                margin-top: 15px;
            }
            .contact-card {
                padding: 30px;
            }
            .hero-shape-1, .hero-shape-2 {
                display: none;
            }
        }
        @media (max-width: 576px) {
            .hero-title { font-size: 1.8rem; }
            .hero-badge { font-size: 0.75rem; }
            .d-flex.gap-4.mt-5 { flex-direction: column; text-align: center; gap: 15px !important; }
            .d-flex.gap-4.mt-5 > div[style*="width: 2px"] { display: none; }
        }
    </style>
</head>
<body>

    <nav class="navbar-public navbar navbar-expand-lg">
        <div class="container">
            <a href="#" class="navbar-brand text-decoration-none">
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
            
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <i class="bi bi-list fs-1" style="color: var(--moss);"></i>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto gap-lg-4">
                    <li class="nav-item"><a class="nav-link" href="#inicio">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link" href="#nosotros">Nosotros</a></li>
                    <li class="nav-item"><a class="nav-link" href="#productos">Productos</a></li>
                    <li class="nav-item"><a class="nav-link" href="#contacto">Contacto</a></li>
                </ul>
                <div class="d-lg-flex align-items-center gap-3">
                    <button class="btn btn-link nav-link p-0 d-none d-lg-block" id="themeToggle" style="font-size: 1.2rem;" title="Cambiar Tema">
                        <i class="bi bi-moon-stars-fill" id="themeIcon"></i>
                    </button>
                    <a href="login" class="btn-login-outline">
                        <i class="bi bi-person-circle me-1"></i> Portal Empleados
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- INICIO -->
    <section id="inicio" class="hero-section">
        <div class="hero-shape-1"></div>
        <div class="hero-shape-2"></div>
        <div class="container hero-content">
            <div class="row align-items-center">
                <div class="col-lg-7 mb-5 mb-lg-0 text-center text-lg-start">
                    <div class="hero-badge shadow-sm"><i class="bi bi-award-fill me-1"></i> CALIDAD DESDE BOYACÁ</div>
                    <h1 class="hero-title">Tradición y Excelencia <span>Ganadera</span></h1>
                    <p class="hero-text mx-auto mx-lg-0">
                        En Finca La Rosa nos dedicamos a la crianza de ganado de la más alta calidad genética y a la producción de lácteos frescos 100% naturales desde los pastos de Santa Rosa de Viterbo.
                    </p>
                    <a href="#productos" class="btn-primary-custom btn-ripple shadow-lg">
                        Conocer Productos <i class="bi bi-arrow-down"></i>
                    </a>
                </div>
                <div class="col-lg-5">
                    <div class="d-flex justify-content-center">
                        <div class="mockup-container">
                            <div style="width: 100%; height: 100%; background: linear-gradient(135deg, var(--moss), var(--sage)); border-radius: 40px; transform: rotate(5deg); position: absolute; z-index: 1; opacity: 0.25;"></div>
                            <div style="width: 100%; height: 100%; background: rgba(13, 14, 12, 0.8); backdrop-filter: blur(15px); border-radius: 40px; z-index: 2; box-shadow: 0 25px 60px rgba(0, 0, 0, 0.5); padding: 30px; display: flex; flex-direction: column; justify-content: center; align-items: center; position: absolute; border: 1px solid var(--card-border);">
                                <i class="bi bi-flower1" style="font-size: 8rem; color: var(--moss); opacity: 0.8;"></i>
                                <h3 class="fw-bolder mt-3" style="color: var(--text-heading);">Finca La Rosa</h3>
                                <p class="text-center fw-bold" style="color: var(--text-muted);">Naturaleza en su mejor versión</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- NOSOTROS -->
    <section id="nosotros" class="about-section">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-lg-6 order-2 order-lg-1">
                    <div class="about-image-box">
                        <img src="img/finca-hero.png" alt="Paisaje Finca La Rosa, Boyacá" style="width: 100%; height: 500px; object-fit: cover;">
                        <div class="about-image-overlay"></div>
                        <div class="about-badge">
                            <i class="bi bi-check-decagram about-badge-icon"></i>
                            <div>
                                <h5 class="mb-0 fw-bolder" style="color: var(--text-heading);">Calidad Certificada</h5>
                                <small class="fw-bold" style="color: var(--text-muted);">Ganadería sostenible</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 order-1 order-lg-2">
                    <h6 class="text-uppercase fw-bold" style="color: var(--moss); letter-spacing: 2px;">Nuestra Historia</h6>
                    <h2 class="fw-bolder mb-4" style="color: var(--text-heading); font-size: 2.5rem;">Cuidado, Amor y Tradición por el Campo</h2>
                    <p class="fs-5 mb-4" style="color: var(--text-muted); line-height: 1.8;">
                        Situada en los hermosos y verdes paisajes de Santa Rosa de Viterbo, Boyacá, la <strong>Finca La Rosa</strong> nació de la pasión por el trabajo agrícola y el respeto absoluto por la naturaleza y nuestros animales.
                    </p>
                    <p class="mb-4" style="color: var(--text-muted); line-height: 1.8;">
                        Contamos con procesos de vanguardia en bioseguridad, garantizando el bienestar de nuestro hato. Esto nos permite asegurar que cada gota de leche y cada producto lácteo que llega a tu mesa sea sinónimo de pureza y sabor excepcional.
                    </p>
                    
                    <div class="d-flex gap-4 mt-5">
                        <div>
                            <h3 class="fw-bolder" style="color: var(--moss);">100%</h3>
                            <span class="fw-bold" style="color: var(--text-muted);">Natural</span>
                        </div>
                        <div style="width: 2px; background: var(--card-border);"></div>
                        <div>
                            <h3 class="fw-bolder" style="color: var(--moss);">1ra</h3>
                            <span class="fw-bold" style="color: var(--text-muted);">Calidad Genética</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- PRODUCTOS -->
    <section id="productos" class="products-section">
        <div class="container">
            <div class="text-center mb-5 pb-3">
                <h6 class="text-uppercase fw-bold" style="color: var(--moss); letter-spacing: 2px;">Lo que Ofrecemos</h6>
                <h2 class="fw-bolder" style="color: var(--text-heading); font-size: 2.5rem;">Nuestros Productos</h2>
            </div>
            
            <div class="row g-4 justify-content-center">
                <!-- Producto 1 -->
                <div class="col-lg-4 col-md-6">
                    <div class="product-card">
                        <div class="product-icon"><i class="bi bi-droplet-fill"></i></div>
                        <h4 class="fw-bolder" style="color: var(--text-heading);">Leche Cruda Premium</h4>
                        <p class="mt-3 mb-0" style="color: var(--text-muted); line-height: 1.6;">
                            Leche fresca y pura, extraída bajo los más altos estándares de higiene y control de calidad, ideal para procesamiento industrial o consumo directo tras hervir.
                        </p>
                    </div>
                </div>

                <!-- Producto 2 -->
                <div class="col-lg-4 col-md-6">
                    <div class="product-card">
                        <div class="product-icon"><i class="bi bi-diagram-3-fill"></i></div>
                        <h4 class="fw-bolder" style="color: var(--text-heading);">Venta de Ganado</h4>
                        <p class="mt-3 mb-0" style="color: var(--text-muted); line-height: 1.6;">
                            Ofrecemos crías, novillas y toros de excelente ascendencia genética, perfectos para mejorar la capacidad productiva de su propio hato ganadero.
                        </p>
                    </div>
                </div>

                <!-- Producto 3 -->
                <div class="col-lg-4 col-md-6">
                    <div class="product-card">
                        <div class="product-icon"><i class="bi bi-basket2-fill"></i></div>
                        <h4 class="fw-bolder" style="color: var(--text-heading);">Derivados Lácteos</h4>
                        <p class="mt-3 mb-0" style="color: var(--text-muted); line-height: 1.6;">
                            Producimos quesos artesanales (campesino, cuajada) procesados en nuestra propia fábrica de lácteos, garantizando sabor y frescura inigualable.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- UBICACIÓN Y CONTACTO -->
    <section id="contacto" class="contact-section">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-5">
                    <div class="contact-card">
                        <h2 class="fw-bolder mb-4 text-heading" style="color: var(--text-heading);">Visítanos o Contáctanos</h2>
                        <p class="mb-5" style="color: var(--text-muted); line-height: 1.7;">
                            Estamos siempre dispuestos a atenderte. Ya sea para realizar pedidos al por mayor, conocer nuestra genética o disfrutar de nuestros quesos.
                        </p>
                        
                        <div class="d-flex align-items-center gap-3 mb-4">
                            <div style="width: 50px; height: 50px; background: rgba(156, 166, 70, 0.15); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; color: var(--moss);">
                                <i class="bi bi-geo-alt-fill"></i>
                            </div>
                            <div>
                                <h6 class="mb-1 fw-bold text-white">Ubicación</h6>
                                <span style="color: var(--text-muted);">Santa Rosa de Viterbo, Boyacá, Colombia</span>
                            </div>
                        </div>

                        <div class="d-flex align-items-center gap-3 mb-4">
                            <div style="width: 50px; height: 50px; background: rgba(156, 166, 70, 0.15); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; color: var(--moss);">
                                <i class="bi bi-whatsapp"></i>
                            </div>
                            <div>
                                <h6 class="mb-1 fw-bold text-white">WhatsApp de Ventas</h6>
                                <span style="color: var(--text-muted);">+57 300 000 0000</span>
                            </div>
                        </div>

                        <div class="d-flex align-items-center gap-3">
                            <div style="width: 50px; height: 50px; background: rgba(156, 166, 70, 0.15); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; color: var(--moss);">
                                <i class="bi bi-envelope-paper-fill"></i>
                            </div>
                            <div>
                                <h6 class="mb-1 fw-bold text-white">Correo Electrónico</h6>
                                <span style="color: var(--text-muted);">contacto@fincalarosa.com</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-7">
                    <!-- Mapa interactivo de Google centrado en Santa Rosa de Viterbo -->
                    <div class="map-container">
                        <iframe 
                            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d15887.320579624843!2d-72.9904257134375!3d5.875225126839308!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8e6a45e7f1a3e611%3A0xb351e7f338c21a44!2sSanta%20Rosa%20de%20Viterbo%2C%20Boyac%C3%A1!5e0!3m2!1ses!2sco!4v1700000000000!5m2!1ses!2sco" 
                            width="100%" 
                            height="100%" 
                            style="border:0;" 
                            allowfullscreen="" 
                            loading="lazy" 
                            referrerpolicy="no-referrer-when-downgrade">
                        </iframe>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="container">
            <div class="row g-4 mb-4">
                <div class="col-lg-4">
                    <div class="footer-brand">
                        <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 16v6" />
                            <path d="M12 20a4 4 0 0 1-3-3" />
                            <path d="M12 18a4 4 0 0 0 3-3" />
                            <path d="M12 16c-4.5 0-7-3.5-7-7 0-3 3-5 7-5s7 2 7 5c0 3.5-2.5 7-7 7z" />
                            <path d="M12 4c-2 2-2 5 0 7s4 2 5 1" />
                            <path d="M12 11c-1.5-1-1.5-3 0-4" />
                        </svg>
                        Finca La Rosa
                    </div>
                    <p style="font-size: 0.95rem; line-height: 1.6; max-width: 300px;">
                        Pasión por la ganadería, calidad en nuestros productos láctos y tradición de Santa Rosa de Viterbo.
                    </p>
                </div>
                <div class="col-lg-4">
                    <h5 class="text-white fw-bold mb-4">Enlaces Rápidos</h5>
                    <ul class="list-unstyled d-flex flex-column gap-2">
                        <li><a href="#inicio" class="text-decoration-none" style="color: #b7b7b7;">Inicio</a></li>
                        <li><a href="#nosotros" class="text-decoration-none" style="color: #b7b7b7;">Sobre Nosotros</a></li>
                        <li><a href="#productos" class="text-decoration-none" style="color: #b7b7b7;">Productos</a></li>
                        <li><a href="login" class="text-decoration-none" style="color: var(--sage);">Portal de Empleados</a></li>
                    </ul>
                </div>
                <div class="col-lg-4">
                    <h5 class="text-white fw-bold mb-4">Síguenos</h5>
                    <div class="d-flex gap-3">
                        <a href="#" class="btn btn-outline-light rounded-circle" style="width: 45px; height: 45px; display: flex; align-items: center; justify-content: center;"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="btn btn-outline-light rounded-circle" style="width: 45px; height: 45px; display: flex; align-items: center; justify-content: center;"><i class="bi bi-instagram"></i></a>
                    </div>
                </div>
            </div>
            <div class="border-top pt-4 mt-4 text-center" style="border-color: rgba(255,255,255,0.1) !important;">
                <p class="mb-0" style="font-size: 0.85rem;">
                    &copy; 2026 Finca La Rosa. Diseño y Desarrollo de Software ADSO. Todos los derechos reservados.
                </p>
            </div>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const toggle = document.getElementById('themeToggle');
            const icon = document.getElementById('themeIcon');
            const root = document.documentElement;
            
            const currentTheme = localStorage.getItem('theme') || 'light';
            root.setAttribute('data-theme', currentTheme);
            updateIcon(currentTheme);
            
            toggle.addEventListener('click', () => {
                const newTheme = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
                root.setAttribute('data-theme', newTheme);
                localStorage.setItem('theme', newTheme);
                updateIcon(newTheme);
            });
            
            function updateIcon(theme) {
                if(theme === 'dark') {
                    icon.className = 'bi bi-sun-fill';
                    icon.style.color = '#ffc107'; 
                } else {
                    icon.className = 'bi bi-moon-stars-fill';
                    icon.style.color = 'var(--text-main)'; 
                }
            }
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>