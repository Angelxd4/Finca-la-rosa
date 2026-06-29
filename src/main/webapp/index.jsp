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
            scroll-behavior: smooth;
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

        .nav-link {
            color: var(--drab) !important;
            font-weight: 600;
            font-size: 0.95rem;
            transition: color 0.3s;
        }

        .nav-link:hover {
            color: var(--moss) !important;
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
            color: white;
            box-shadow: 0 5px 15px rgba(70, 71, 4, 0.25);
        }

        /* --- SECCIÓN HERO --- */
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
            background: #ffffff;
        }

        .about-image-box {
            position: relative;
            border-radius: 30px;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(0,0,0,0.1);
        }

        .about-image-box img {
            width: 100%;
            height: auto;
            display: block;
        }
        
        .about-image-overlay {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(0deg, rgba(70,71,4,0.6) 0%, rgba(0,0,0,0) 100%);
        }

        .about-badge {
            position: absolute;
            bottom: 30px;
            left: 30px;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            padding: 15px 25px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .about-badge-icon {
            font-size: 2rem;
            color: var(--moss);
        }

        /* --- SECCIÓN PRODUCTOS --- */
        .products-section {
            padding: 100px 0;
            background: var(--ivory);
        }

        .product-card {
            background: #ffffff;
            border-radius: 24px;
            padding: 40px 30px;
            height: 100%;
            transition: all 0.4s ease;
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
            position: relative;
            overflow: hidden;
            text-align: center;
            border: 1px solid rgba(156, 168, 137, 0.2);
        }

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(70, 71, 4, 0.1);
            border-color: var(--moss);
        }

        .product-icon {
            width: 80px;
            height: 80px;
            background: var(--ivory);
            color: var(--moss);
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 2.5rem;
            margin: 0 auto 25px auto;
            transition: all 0.3s ease;
        }

        .product-card:hover .product-icon {
            background: var(--moss);
            color: white;
            transform: scale(1.1);
        }

        /* --- SECCIÓN UBICACIÓN --- */
        .contact-section {
            padding: 100px 0;
            background: #ffffff;
        }

        .contact-card {
            background: var(--drab);
            color: white;
            border-radius: 30px;
            padding: 50px;
            box-shadow: 0 20px 50px rgba(66, 57, 38, 0.2);
            height: 100%;
        }

        .map-container {
            border-radius: 30px;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(0,0,0,0.1);
            height: 100%;
            min-height: 400px;
        }

        /* --- FOOTER --- */
        .footer {
            background: #2b2b2b;
            color: #b7b7b7;
            padding: 60px 0 30px;
        }
        
        .footer-brand {
            color: white;
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
                padding: 140px 0 60px;
                text-align: center;
            }
            .hero-title {
                font-size: 2.5rem;
            }
            .hero-text {
                margin: 0 auto 30px auto;
            }
            .mockup-container {
                transform: scale(0.85);
                margin-top: 20px;
            }
            .navbar-collapse {
                background: white;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                margin-top: 15px;
                text-align: center;
            }
            .btn-login-outline {
                display: block;
                margin-top: 15px;
            }
            .contact-card {
                padding: 30px;
            }
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
                <div class="d-lg-flex align-items-center">
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
                            <div style="width: 100%; height: 100%; background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(10px); border-radius: 40px; z-index: 2; box-shadow: 0 25px 60px rgba(66, 57, 38, 0.15); padding: 30px; display: flex; flex-direction: column; justify-content: center; align-items: center; position: absolute; border: 1px solid rgba(255,255,255,0.5);">
                                <i class="bi bi-flower1" style="font-size: 8rem; color: var(--sage); opacity: 0.5;"></i>
                                <h3 class="fw-bolder mt-3" style="color: var(--drab);">Finca La Rosa</h3>
                                <p class="text-muted text-center fw-bold">Naturaleza en su mejor versión</p>
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
                                <h5 class="mb-0 fw-bolder text-dark">Calidad Certificada</h5>
                                <small class="text-muted fw-bold">Ganadería sostenible</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 order-1 order-lg-2">
                    <h6 class="text-uppercase fw-bold" style="color: var(--sage); letter-spacing: 2px;">Nuestra Historia</h6>
                    <h2 class="fw-bolder mb-4" style="color: var(--drab); font-size: 2.5rem;">Cuidado, Amor y Tradición por el Campo</h2>
                    <p class="text-muted fs-5 mb-4" style="line-height: 1.8;">
                        Situada en los hermosos y verdes paisajes de Santa Rosa de Viterbo, Boyacá, la <strong>Finca La Rosa</strong> nació de la pasión por el trabajo agrícola y el respeto absoluto por la naturaleza y nuestros animales.
                    </p>
                    <p class="text-muted mb-4" style="line-height: 1.8;">
                        Contamos con procesos de vanguardia en bioseguridad, garantizando el bienestar de nuestro hato. Esto nos permite asegurar que cada gota de leche y cada producto lácteo que llega a tu mesa sea sinónimo de pureza y sabor excepcional.
                    </p>
                    
                    <div class="d-flex gap-4 mt-5">
                        <div>
                            <h3 class="fw-bolder" style="color: var(--moss);">100%</h3>
                            <span class="text-muted fw-bold">Natural</span>
                        </div>
                        <div style="width: 2px; background: var(--border-subtle);"></div>
                        <div>
                            <h3 class="fw-bolder" style="color: var(--moss);">1ra</h3>
                            <span class="text-muted fw-bold">Calidad Genética</span>
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
                <h6 class="text-uppercase fw-bold" style="color: var(--sage); letter-spacing: 2px;">Lo que Ofrecemos</h6>
                <h2 class="fw-bolder" style="color: var(--drab); font-size: 2.5rem;">Nuestros Productos</h2>
            </div>
            
            <div class="row g-4 justify-content-center">
                <!-- Producto 1 -->
                <div class="col-lg-4 col-md-6">
                    <div class="product-card">
                        <div class="product-icon"><i class="bi bi-droplet-fill"></i></div>
                        <h4 class="fw-bolder" style="color: var(--drab);">Leche Cruda Premium</h4>
                        <p class="text-muted mt-3 mb-0" style="line-height: 1.6;">
                            Leche fresca y pura, extraída bajo los más altos estándares de higiene y control de calidad, ideal para procesamiento industrial o consumo directo tras hervir.
                        </p>
                    </div>
                </div>

                <!-- Producto 2 -->
                <div class="col-lg-4 col-md-6">
                    <div class="product-card">
                        <div class="product-icon"><i class="bi bi-diagram-3-fill"></i></div>
                        <h4 class="fw-bolder" style="color: var(--drab);">Venta de Ganado</h4>
                        <p class="text-muted mt-3 mb-0" style="line-height: 1.6;">
                            Ofrecemos crías, novillas y toros de excelente ascendencia genética, perfectos para mejorar la capacidad productiva de su propio hato ganadero.
                        </p>
                    </div>
                </div>

                <!-- Producto 3 -->
                <div class="col-lg-4 col-md-6">
                    <div class="product-card">
                        <div class="product-icon"><i class="bi bi-basket2-fill"></i></div>
                        <h4 class="fw-bolder" style="color: var(--drab);">Derivados Lácteos</h4>
                        <p class="text-muted mt-3 mb-0" style="line-height: 1.6;">
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
                        <h2 class="fw-bolder mb-4">Visítanos o Contáctanos</h2>
                        <p class="mb-5" style="color: rgba(255,255,255,0.8); line-height: 1.7;">
                            Estamos siempre dispuestos a atenderte. Ya sea para realizar pedidos al por mayor, conocer nuestra genética o disfrutar de nuestros quesos.
                        </p>
                        
                        <div class="d-flex align-items-center gap-3 mb-4">
                            <div style="width: 50px; height: 50px; background: rgba(255,255,255,0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                                <i class="bi bi-geo-alt-fill"></i>
                            </div>
                            <div>
                                <h6 class="mb-1 fw-bold text-white">Ubicación</h6>
                                <span style="color: rgba(255,255,255,0.7);">Santa Rosa de Viterbo, Boyacá, Colombia</span>
                            </div>
                        </div>

                        <div class="d-flex align-items-center gap-3 mb-4">
                            <div style="width: 50px; height: 50px; background: rgba(255,255,255,0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                                <i class="bi bi-whatsapp"></i>
                            </div>
                            <div>
                                <h6 class="mb-1 fw-bold text-white">WhatsApp de Ventas</h6>
                                <span style="color: rgba(255,255,255,0.7);">+57 300 000 0000</span>
                            </div>
                        </div>

                        <div class="d-flex align-items-center gap-3">
                            <div style="width: 50px; height: 50px; background: rgba(255,255,255,0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                                <i class="bi bi-envelope-paper-fill"></i>
                            </div>
                            <div>
                                <h6 class="mb-1 fw-bold text-white">Correo Electrónico</h6>
                                <span style="color: rgba(255,255,255,0.7);">contacto@fincalarosa.com</span>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>