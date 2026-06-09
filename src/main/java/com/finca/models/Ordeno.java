package com.finca.models;

import java.sql.Timestamp;
import java.util.List;

public class Ordeno {
    private int idOrdeno;
    private Timestamp fechaHora;
    private String lugar;
    private int supervisorId;
    private int totalVacas;
    private double totalLitros;
    private double promedioLitros;
    private String observaciones;
    private String nombreSupervisor;
    
    // CAMPOS DE CONTROL DE INVENTARIO Y DESCARTE
    private double litrosVenta;
    private double litrosFabrica;
    private double totalDescarte;
    private boolean asignado;
    
    private List<DetalleOrdeno> detalles;

    // Getters y Setters
    public int getIdOrdeno() { return idOrdeno; }
    public void setIdOrdeno(int idOrdeno) { this.idOrdeno = idOrdeno; }

    public Timestamp getFechaHora() { return fechaHora; }
    public void setFechaHora(Timestamp fechaHora) { this.fechaHora = fechaHora; }

    public String getLugar() { return lugar; }
    public void setLugar(String lugar) { this.lugar = lugar; }

    public int getSupervisorId() { return supervisorId; }
    public void setSupervisorId(int supervisorId) { this.supervisorId = supervisorId; }

    public int getTotalVacas() { return totalVacas; }
    public void setTotalVacas(int totalVacas) { this.totalVacas = totalVacas; }

    public double getTotalLitros() { return totalLitros; }
    public void setTotalLitros(double totalLitros) { this.totalLitros = totalLitros; }

    public double getPromedioLitros() { return promedioLitros; }
    public void setPromedioLitros(double promedioLitros) { this.promedioLitros = promedioLitros; }

    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }

    public String getNombreSupervisor() { return nombreSupervisor; }
    public void setNombreSupervisor(String nombreSupervisor) { this.nombreSupervisor = nombreSupervisor; }

    public double getLitrosVenta() { return litrosVenta; }
    public void setLitrosVenta(double litrosVenta) { this.litrosVenta = litrosVenta; }

    public double getLitrosFabrica() { return litrosFabrica; }
    public void setLitrosFabrica(double litrosFabrica) { this.litrosFabrica = litrosFabrica; }

    public double getTotalDescarte() { return totalDescarte; }
    public void setTotalDescarte(double totalDescarte) { this.totalDescarte = totalDescarte; }

    public boolean isAsignado() { return asignado; }
    public void setAsignado(boolean asignado) { this.asignado = asignado; }

    public List<DetalleOrdeno> getDetalles() { return detalles; }
    public void setDetalles(List<DetalleOrdeno> detalles) { this.detalles = detalles; }
}