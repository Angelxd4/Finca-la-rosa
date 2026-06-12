package com.finca.models;

import java.sql.Date;
import java.sql.Timestamp;

public class Tarea {
    private int idTarea;
    private String titulo;
    private String descripcion;
    private String estado;
    private Date fechaLimite;
    private int asignadoA;
    private int creadoPor;
    private Timestamp createdAt;

    // Campos extra para la vista HTML
    private String asignadoNombre;
    private String asignadoFoto;

    public Tarea() {}

    public int getIdTarea() { return idTarea; }
    public void setIdTarea(int idTarea) { this.idTarea = idTarea; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public Date getFechaLimite() { return fechaLimite; }
    public void setFechaLimite(Date fechaLimite) { this.fechaLimite = fechaLimite; }

    public int getAsignadoA() { return asignadoA; }
    public void setAsignadoA(int asignadoA) { this.asignadoA = asignadoA; }

    public int getCreadoPor() { return creadoPor; }
    public void setCreadoPor(int creadoPor) { this.creadoPor = creadoPor; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getAsignadoNombre() { return asignadoNombre; }
    public void setAsignadoNombre(String asignadoNombre) { this.asignadoNombre = asignadoNombre; }

    public String getAsignadoFoto() { return asignadoFoto; }
    public void setAsignadoFoto(String asignadoFoto) { this.asignadoFoto = asignadoFoto; }
}