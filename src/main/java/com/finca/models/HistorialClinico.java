package com.finca.models;

import java.sql.Date;
import java.sql.Timestamp;

public class HistorialClinico {
    private int idRegistro;
    private int idBovino;
    private Date fechaEvento;
    private String tipoEvento;
    private String descripcion;
    private int veterinarioId;
    private String nombreVeterinario; // Para mostrar quién la inyectó
    private Timestamp createdAt;

    public HistorialClinico() {}

    // Getters
    public int getIdRegistro() { return idRegistro; }
    public int getIdBovino() { return idBovino; }
    public Date getFechaEvento() { return fechaEvento; }
    public String getTipoEvento() { return tipoEvento; }
    public String getDescripcion() { return descripcion; }
    public int getVeterinarioId() { return veterinarioId; }
    public String getNombreVeterinario() { return nombreVeterinario; }
    public Timestamp getCreatedAt() { return createdAt; }

    // Setters
    public void setIdRegistro(int idRegistro) { this.idRegistro = idRegistro; }
    public void setIdBovino(int idBovino) { this.idBovino = idBovino; }
    public void setFechaEvento(Date fechaEvento) { this.fechaEvento = fechaEvento; }
    public void setTipoEvento(String tipoEvento) { this.tipoEvento = tipoEvento; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public void setVeterinarioId(int veterinarioId) { this.veterinarioId = veterinarioId; }
    public void setNombreVeterinario(String nombreVeterinario) { this.nombreVeterinario = nombreVeterinario; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}