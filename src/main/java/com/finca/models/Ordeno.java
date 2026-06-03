package com.finca.models;
import java.sql.Timestamp;

public class Ordeno {
    private int idOrdeno;
    private Timestamp fechaHora;
    private int vacasOrdenadas;
    private double litrosObtenidos;
    private int supervisorId;
    private String nombreSupervisor; // Para mostrar el nombre en la tabla
    private String asistentes;
    private String observaciones;

    public Ordeno() {}

    // Getters
    public int getIdOrdeno() { return idOrdeno; }
    public Timestamp getFechaHora() { return fechaHora; }
    public int getVacasOrdenadas() { return vacasOrdenadas; }
    public double getLitrosObtenidos() { return litrosObtenidos; }
    public int getSupervisorId() { return supervisorId; }
    public String getNombreSupervisor() { return nombreSupervisor; }
    public String getAsistentes() { return asistentes; }
    public String getObservaciones() { return observaciones; }

    // Setters
    public void setIdOrdeno(int idOrdeno) { this.idOrdeno = idOrdeno; }
    public void setFechaHora(Timestamp fechaHora) { this.fechaHora = fechaHora; }
    public void setVacasOrdenadas(int vacasOrdenadas) { this.vacasOrdenadas = vacasOrdenadas; }
    public void setLitrosObtenidos(double litrosObtenidos) { this.litrosObtenidos = litrosObtenidos; }
    public void setSupervisorId(int supervisorId) { this.supervisorId = supervisorId; }
    public void setNombreSupervisor(String nombreSupervisor) { this.nombreSupervisor = nombreSupervisor; }
    public void setAsistentes(String asistentes) { this.asistentes = asistentes; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
}