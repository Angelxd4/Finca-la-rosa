package com.finca.models;

public class DetalleOrdeno {
    private int idDetalle;
    private int idSesion;
    private int idBovino;
    private String numeroArete;
    private String imageUrl;
    private double litrosObtenidos;

    public DetalleOrdeno() {}

    public int getIdDetalle() { return idDetalle; }
    public void setIdDetalle(int idDetalle) { this.idDetalle = idDetalle; }
    public int getIdSesion() { return idSesion; }
    public void setIdSesion(int idSesion) { this.idSesion = idSesion; }
    public int getIdBovino() { return idBovino; }
    public void setIdBovino(int idBovino) { this.idBovino = idBovino; }
    public String getNumeroArete() { return numeroArete; }
    public void setNumeroArete(String numeroArete) { this.numeroArete = numeroArete; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public double getLitrosObtenidos() { return litrosObtenidos; }
    public void setLitrosObtenidos(double litrosObtenidos) { this.litrosObtenidos = litrosObtenidos; }
}