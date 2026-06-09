package com.finca.models;

import java.sql.Timestamp;
import java.util.List;

public class Ordeno {
    private int idOrdeno; 
    private Timestamp fechaHora;
    private String lugar;
    private int supervisorId;
    private String nombreSupervisor; 
    private int totalVacas;
    private double totalLitros;
    private double promedioLitros;
    
    // CORRECCIÓN: Devolvemos el campo de observaciones que se había perdido
    private String observaciones; 
    
    private List<DetalleOrdeno> detalles;

    public Ordeno() {}

    public int getIdOrdeno() { return idOrdeno; }
    public void setIdOrdeno(int idOrdeno) { this.idOrdeno = idOrdeno; }
    
    public Timestamp getFechaHora() { return fechaHora; }
    public void setFechaHora(Timestamp fechaHora) { this.fechaHora = fechaHora; }
    
    public String getLugar() { return lugar; }
    public void setLugar(String lugar) { this.lugar = lugar; }
    
    public int getSupervisorId() { return supervisorId; }
    public void setSupervisorId(int supervisorId) { this.supervisorId = supervisorId; }
    
    public String getNombreSupervisor() { return nombreSupervisor; }
    public void setNombreSupervisor(String nombreSupervisor) { this.nombreSupervisor = nombreSupervisor; }
    
    public int getTotalVacas() { return totalVacas; }
    public void setTotalVacas(int totalVacas) { this.totalVacas = totalVacas; }
    
    public double getTotalLitros() { return totalLitros; }
    public void setTotalLitros(double totalLitros) { this.totalLitros = totalLitros; }
    
    public double getPromedioLitros() { return promedioLitros; }
    public void setPromedioLitros(double promedioLitros) { this.promedioLitros = promedioLitros; }
    
    // Getters y Setters de la corrección
    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
    
    public List<DetalleOrdeno> getDetalles() { return detalles; }
    public void setDetalles(List<DetalleOrdeno> detalles) { this.detalles = detalles; }
}