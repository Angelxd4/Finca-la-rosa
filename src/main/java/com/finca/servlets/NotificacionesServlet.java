package com.finca.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.finca.dao.NotificacionDAO;
import com.finca.models.Notificacion;
import com.finca.models.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/NotificacionesServlet")
public class NotificacionesServlet extends HttpServlet {

    private final NotificacionDAO notiDAO = new NotificacionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            response.setStatus(401);
            return;
        }

        Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
        int userId = u.getId();
        
        List<Notificacion> lista = notiDAO.obtenerPorUsuario(userId);
        int noLeidas = notiDAO.contarNoLeidas(userId);

        // Construir JSON manualmente para evitar dependencias extra si no hay Gson
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"noLeidas\":").append(noLeidas).append(",");
        json.append("\"notificaciones\":[");
        for (int i = 0; i < lista.size(); i++) {
            Notificacion n = lista.get(i);
            json.append("{");
            json.append("\"id\":").append(n.getIdNotificacion()).append(",");
            json.append("\"titulo\":\"").append(escapeJson(n.getTitulo())).append("\",");
            json.append("\"mensaje\":\"").append(escapeJson(n.getMensaje())).append("\",");
            json.append("\"tipo\":\"").append(escapeJson(n.getTipo())).append("\",");
            json.append("\"link\":\"").append(escapeJson(n.getLink() != null ? n.getLink() : "#")).append("\",");
            json.append("\"tiempo\":\"").append(escapeJson(n.getTiempoRelativo())).append("\",");
            json.append("\"leida\":").append(n.isLeida());
            json.append("}");
            if (i < lista.size() - 1) json.append(",");
        }
        json.append("]");
        json.append("}");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(json.toString());
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            response.setStatus(401);
            return;
        }

        String action = request.getParameter("action");
        if ("marcarLeidas".equals(action)) {
            Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
            notiDAO.marcarComoLeidas(u.getId());
            response.getWriter().write("ok");
        }
    }

    private String escapeJson(String data) {
        if (data == null) return "";
        return data.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }
}
