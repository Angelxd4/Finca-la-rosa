<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión | Gestión Ganadera</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #e9ecef;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            overflow: hidden;
            max-width: 900px;
            width: 100%;
        }
        .login-img {
            background: url('https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80') center/cover;
            min-height: 100%;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="card login-card border-0">
        <div class="row g-0">
            <div class="col-md-6 d-none d-md-block login-img"></div>
            
            <div class="col-md-6 p-5">
                <div class="text-center mb-4">
                    <h2 class="fw-bold text-success">Finca La Rosa 🐄</h2>
                    <p class="text-muted">Sistema de Gestión Ganadera</p>
                </div>

                <% if(request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger text-center small p-2">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="login" method="POST">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Correo Electrónico</label>
                        <input type="email" name="email" class="form-control form-control-lg" required placeholder="admin@finca.com">
                    </div>
                    <div class="mb-4">
                        <label class="form-label small fw-bold text-muted">Contraseña</label>
                        <input type="password" name="password" class="form-control form-control-lg" required placeholder="••••••••">
                    </div>
                    <button type="submit" class="btn btn-success btn-lg w-100 fw-bold">Ingresar al Sistema</button>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>