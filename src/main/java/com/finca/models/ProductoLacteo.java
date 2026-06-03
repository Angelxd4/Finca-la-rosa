package com.finca.models;

public class ProductoLacteo {
    private int idProducto;
    private String codigo;
    private String nombre;
    private String descripcion;
    private String unidadMedida;
    private double stock;
    private double precioUnitario;

    public ProductoLacteo() {}

    // Getters
    public int getIdProducto() { return idProducto; }
    public String getCodigo() { return codigo; }
    public String getNombre() { return nombre; }
    public String getDescripcion() { return descripcion; }
    public String getUnidadMedida() { return unidadMedida; }
    public double getStock() { return stock; }
    public double getPrecioUnitario() { return precioUnitario; }

    // Setters
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }
    public void setCodigo(String codigo) { this.codigo = codigo; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public void setUnidadMedida(String unidadMedida) { this.unidadMedida = unidadMedida; }
    public void setStock(double stock) { this.stock = stock; }
    public void setPrecioUnitario(double precioUnitario) { this.precioUnitario = precioUnitario; }
}