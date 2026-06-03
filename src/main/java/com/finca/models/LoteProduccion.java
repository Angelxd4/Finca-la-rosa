package com.finca.models;
import java.sql.Timestamp;

public class LoteProduccion {
    private int idLote;
    private int idProducto;
    private String nombreProducto; // Para mostrar el nombre del queso en la tabla
    private double cantidad;
    private double litrosLecheUsados;
    private String estado;
    private Timestamp fechaInicio;
    private Timestamp fechaFin;

    public LoteProduccion() {}

    // Getters
    public int getIdLote() { return idLote; }
    public int getIdProducto() { return idProducto; }
    public String getNombreProducto() { return nombreProducto; }
    public double getCantidad() { return cantidad; }
    public double getLitrosLecheUsados() { return litrosLecheUsados; }
    public String getEstado() { return estado; }
    public Timestamp getFechaInicio() { return fechaInicio; }
    public Timestamp getFechaFin() { return fechaFin; }

    // Setters
    public void setIdLote(int idLote) { this.idLote = idLote; }
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }
    public void setNombreProducto(String nombreProducto) { this.nombreProducto = nombreProducto; }
    public void setCantidad(double cantidad) { this.cantidad = cantidad; }
    public void setLitrosLecheUsados(double litrosLecheUsados) { this.litrosLecheUsados = litrosLecheUsados; }
    public void setEstado(String estado) { this.estado = estado; }
    public void setFechaInicio(Timestamp fechaInicio) { this.fechaInicio = fechaInicio; }
    public void setFechaFin(Timestamp fechaFin) { this.fechaFin = fechaFin; }
}