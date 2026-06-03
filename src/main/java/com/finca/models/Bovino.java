package com.finca.models;

import java.sql.Date;
import java.time.LocalDate;
import java.time.Period;

public class Bovino {
    private int idBovino;
    private String numeroArete;
    private String raza;
    private String genero;
    private double pesoKg;
    private String proposito;
    private String estadoSalud;
    private Date fechaNacimiento;
    private double precioEstimado;
    
    // Columnas de Producción / Venta
    private String clasificacion; 
    private int numeroPartos;
    private double litrosDiariosPromedio;
    
    // 📸 ¡AQUÍ ESTÁ LA VARIABLE FALTANTE PARA LA FOTO!
    private String imageUrl; 
    
    public Bovino() {}

    // Función para calcular la edad
    public int getEdadAnios() {
        if (this.fechaNacimiento == null) return 0;
        LocalDate nacimiento = this.fechaNacimiento.toLocalDate();
        LocalDate ahora = LocalDate.now();
        return Period.between(nacimiento, ahora).getYears();
    }

    // Getters
    public int getIdBovino() { return idBovino; }
    public String getNumeroArete() { return numeroArete; }
    public String getRaza() { return raza; }
    public String getGenero() { return genero; }
    public double getPesoKg() { return pesoKg; }
    public String getProposito() { return proposito; }
    public String getEstadoSalud() { return estadoSalud; }
    public Date getFechaNacimiento() { return fechaNacimiento; }
    public double getPrecioEstimado() { return precioEstimado; }
    public String getClasificacion() { return clasificacion; }
    public int getNumeroPartos() { return numeroPartos; }
    public double getLitrosDiariosPromedio() { return litrosDiariosPromedio; }
    public String getImageUrl() { return imageUrl; }

    // Setters
    public void setIdBovino(int idBovino) { this.idBovino = idBovino; }
    public void setNumeroArete(String numeroArete) { this.numeroArete = numeroArete; }
    public void setRaza(String raza) { this.raza = raza; }
    public void setGenero(String genero) { this.genero = genero; }
    public void setPesoKg(double pesoKg) { this.pesoKg = pesoKg; }
    public void setProposito(String proposito) { this.proposito = proposito; }
    public void setEstadoSalud(String estadoSalud) { this.estadoSalud = estadoSalud; }
    public void setFechaNacimiento(Date fechaNacimiento) { this.fechaNacimiento = fechaNacimiento; }
    public void setPrecioEstimado(double precioEstimado) { this.precioEstimado = precioEstimado; }
    public void setClasificacion(String clasificacion) { this.clasificacion = clasificacion; }
    public void setNumeroPartos(int numeroPartos) { this.numeroPartos = numeroPartos; }
    public void setLitrosDiariosPromedio(double litrosDiariosPromedio) { this.litrosDiariosPromedio = litrosDiariosPromedio; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}