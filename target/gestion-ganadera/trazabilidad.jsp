<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String loteId = request.getParameter("lote");
    if (loteId == null || loteId.trim().isEmpty()) {
        loteId = "Q-100"; // Lote de prueba por defecto
    }
%>
<!DOCTYPE html>
<html lang="es" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trazabilidad del Producto | Finca La Rosa</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        :root {
            --moss: #464704;       
            --sage: #9CA889;       
            --khaki: #B7A78C;      
            --drab: #423926;       
            --ivory: #F3F5E7;      
            --brand-primary: #8A9F6D;
        }
        body {
            background-color: var(--ivory);
            font-family: 'Inter', sans-serif;
            color: var(--drab);
        }
        .hero-section {
            background: linear-gradient(rgba(70, 71, 4, 0.8), rgba(70, 71, 4, 0.6)), url('https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover;
            height: 40vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
            border-bottom-left-radius: 40px;
            border-bottom-right-radius: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .info-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-top: -60px;
            box-shadow: 0 15px 35px rgba(66, 57, 38, 0.08);
            position: relative;
            z-index: 10;
            border: 1px solid rgba(183, 167, 140, 0.3);
        }
        .icon-box {
            width: 60px;
            height: 60px;
            background-color: var(--ivory);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: var(--moss);
            margin: 0 auto 15px auto;
        }
        .cert-badge {
            display: inline-block;
            background: rgba(138, 159, 109, 0.15);
            color: var(--moss);
            padding: 8px 15px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

    <div class="hero-section">
        <div class="px-3">
            <h1 class="display-4 fw-bolder mb-2">Finca La Rosa</h1>
            <p class="lead fw-medium mb-0">Del campo a tu mesa con amor y transparencia</p>
        </div>
    </div>

    <div class="container pb-5">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10">
                <div class="info-card text-center">
                    <span class="cert-badge"><i class="bi bi-shield-check me-1"></i> Origen Certificado</span>
                    
                    <h2 class="fw-bolder mb-1 mt-3" style="color: var(--moss);">Lote <%= loteId %></h2>
                    <p class="text-muted mb-4">Queso Artesanal de Finca</p>
                    
                    <div class="row g-4 text-start mt-2">
                        <div class="col-md-6">
                            <div class="d-flex align-items-start">
                                <div class="icon-box me-3 flex-shrink-0" style="width: 50px; height: 50px; font-size: 1.4rem;">
                                    <i class="bi bi-droplet-half"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold mb-1">Materia Prima</h5>
                                    <p class="text-muted small mb-0">Leche cruda 100% de vaca, obtenida del ordeño matutino bajo estrictas normas de higiene.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="d-flex align-items-start">
                                <div class="icon-box me-3 flex-shrink-0" style="width: 50px; height: 50px; font-size: 1.4rem;">
                                    <i class="bi bi-geo-alt-fill"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold mb-1">Origen Geográfico</h5>
                                    <p class="text-muted small mb-0">Santa Rosa de Viterbo, Boyacá. Vacas criadas en pastoreo libre y sin estrés.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="d-flex align-items-start">
                                <div class="icon-box me-3 flex-shrink-0" style="width: 50px; height: 50px; font-size: 1.4rem;">
                                    <i class="bi bi-stars"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold mb-1">Calidad Natural</h5>
                                    <p class="text-muted small mb-0">Sin conservantes artificiales. Sabor auténtico del campo colombiano.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="d-flex align-items-start">
                                <div class="icon-box me-3 flex-shrink-0" style="width: 50px; height: 50px; font-size: 1.4rem;">
                                    <i class="bi bi-calendar-check"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold mb-1">Fecha de Elaboración</h5>
                                    <p class="text-muted small mb-0">Garantizamos la frescura de tu producto. Elaborado artesanalmente esta semana.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <hr class="my-5" style="opacity: 0.1;">
                    
                    <h5 class="fw-bold mb-3">Conoce a nuestras estrellas</h5>
                    <p class="text-muted small mb-4">La leche para este lote proviene de nuestras vacas mejor alimentadas:</p>
                    
                    <div class="d-flex justify-content-center gap-3 flex-wrap">
                        <div class="text-center">
                            <img src="https://images.unsplash.com/photo-1546445317-29f4545e9d53?w=100&h=100&fit=crop" class="rounded-circle mb-2" style="border: 3px solid var(--sage);" alt="Vaca">
                            <span class="d-block small fw-bold">Margarita</span>
                        </div>
                        <div class="text-center">
                            <img src="https://images.unsplash.com/photo-1596733430284-f743727521a5?w=100&h=100&fit=crop" class="rounded-circle mb-2" style="border: 3px solid var(--sage);" alt="Vaca">
                            <span class="d-block small fw-bold">Lola</span>
                        </div>
                        <div class="text-center">
                            <img src="https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?w=100&h=100&fit=crop" class="rounded-circle mb-2" style="border: 3px solid var(--sage);" alt="Vaca">
                            <span class="d-block small fw-bold">Pinta</span>
                        </div>
                    </div>
                    
                    <div class="mt-5 pt-3 border-top">
                        <p class="small text-muted mb-0">¡Gracias por apoyar el campo colombiano!</p>
                        <p class="small fw-bold" style="color: var(--moss);">Finca La Rosa &copy; 2026</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
</body>
</html>
