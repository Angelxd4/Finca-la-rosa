package com.finca.filters;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String uri = req.getRequestURI();
        
        // Rutas que no requieren sesión (rutas públicas)
        boolean isLogin = uri.endsWith("/login") || uri.endsWith("/login.jsp") || uri.endsWith("/LoginServlet");
        boolean isRecover = uri.endsWith("/recuperar") || uri.endsWith("/recuperar.jsp") || uri.endsWith("/RecuperacionServlet") || uri.endsWith("/recuperar-password.jsp") || uri.endsWith("/recuperar_password");
        boolean isStaticResource = uri.contains("/css/") || uri.contains("/js/") || uri.contains("/img/") || uri.contains("/uploads/") || uri.contains("/assets/");
        boolean isTrazabilidad = uri.endsWith("/trazabilidad") || uri.endsWith("/trazabilidad.jsp");
        boolean isIndex = uri.endsWith("/") || uri.endsWith("/index.jsp");

        if (isLogin || isRecover || isStaticResource || isIndex || isTrazabilidad) {
            // Permitir el paso a recursos públicos
            chain.doFilter(request, response);
            return;
        }

        // Si no hay sesión o no está logueado, redirigir al login
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            // Verificamos si es una petición AJAX o Fetch
            String requestedWith = req.getHeader("X-Requested-With");
            String acceptHeader = req.getHeader("Accept");
            
            if ("XMLHttpRequest".equals(requestedWith) || (acceptHeader != null && acceptHeader.contains("application/json"))) {
                res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                res.getWriter().write("{\"error\": \"Sesión expirada. Por favor inicie sesión de nuevo.\"}");
            } else {
                String scheme = req.getHeader("X-Forwarded-Proto");
                if (scheme != null && scheme.equalsIgnoreCase("https")) {
                    res.sendRedirect("https://" + req.getServerName() + req.getContextPath() + "/login");
                } else {
                    res.sendRedirect(req.getContextPath() + "/login");
                }
            }
            return;
        }

        // 🔒 Validar si requiere cambio de contraseña obligatorio (Primer Inicio)
        com.finca.models.Usuario u = (com.finca.models.Usuario) session.getAttribute("usuarioLogueado");
        if (u.isRequiereCambioPassword()) {
            boolean isPasswordChangeRoute = uri.endsWith("/cambiar-password.jsp");
            if (!isPasswordChangeRoute) {
                String scheme = req.getHeader("X-Forwarded-Proto");
                if (scheme != null && scheme.equalsIgnoreCase("https")) {
                    res.sendRedirect("https://" + req.getServerName() + req.getContextPath() + "/cambiar-password.jsp");
                } else {
                    res.sendRedirect(req.getContextPath() + "/cambiar-password.jsp");
                }
                return;
            }
        }

        // Usuario autenticado, continuar con la petición normal
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
