package com.finca.models;

import java.sql.Timestamp;

public class Notificacion {
    private int idNotificacion;
    private int idUsuario;
    private String titulo;
    private String mensaje;
    private boolean leida;
    private String tipo;
    private String link;
    private Timestamp createdAt;
    
    // Campo auxiliar para vistas
    private String tiempoRelativo; // Ej: "Hace 5 min"

    public Notificacion() {}

    public int getIdNotificacion() { return idNotificacion; }
    public void setIdNotificacion(int idNotificacion) { this.idNotificacion = idNotificacion; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getMensaje() { return mensaje; }
    public void setMensaje(String mensaje) { this.mensaje = mensaje; }

    public boolean isLeida() { return leida; }
    public void setLeida(boolean leida) { this.leida = leida; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getLink() { return link; }
    public void setLink(String link) { this.link = link; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getTiempoRelativo() { return tiempoRelativo; }
    public void setTiempoRelativo(String tiempoRelativo) { this.tiempoRelativo = tiempoRelativo; }
}
