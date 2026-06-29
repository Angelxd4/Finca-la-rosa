package com.finca.models;

import java.util.Date;
import java.util.List;

public class Venta {
    private int idVenta;
    private int idCliente;
    private String nombreCliente; // Fetch logic
    private Date fechaVenta;
    private double total;
    private String metodoPago;
    private String estado;
    private String facturaUrl;
    
    private List<DetalleVenta> detalles;

    public Venta() {}

    public int getIdVenta() { return idVenta; }
    public void setIdVenta(int idVenta) { this.idVenta = idVenta; }

    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }

    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }

    public Date getFechaVenta() { return fechaVenta; }
    public void setFechaVenta(Date fechaVenta) { this.fechaVenta = fechaVenta; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public String getMetodoPago() { return metodoPago; }
    public void setMetodoPago(String metodoPago) { this.metodoPago = metodoPago; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getFacturaUrl() { return facturaUrl; }
    public void setFacturaUrl(String facturaUrl) { this.facturaUrl = facturaUrl; }

    public List<DetalleVenta> getDetalles() { return detalles; }
    public void setDetalles(List<DetalleVenta> detalles) { this.detalles = detalles; }
}
