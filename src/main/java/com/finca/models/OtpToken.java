package com.finca.models;

import java.sql.Timestamp;

public class OtpToken {
    private int id;
    private int idUsuario;
    private String codigo;
    private Timestamp fechaGen;
    private Timestamp expiraEn;
    private boolean usado;

    public OtpToken() {}

    // Getters
    public int getId() { return id; }
    public int getIdUsuario() { return idUsuario; }
    public String getCodigo() { return codigo; }
    public Timestamp getFechaGen() { return fechaGen; }
    public Timestamp getExpiraEn() { return expiraEn; }
    public boolean isUsado() { return usado; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }
    public void setCodigo(String codigo) { this.codigo = codigo; }
    public void setFechaGen(Timestamp fechaGen) { this.fechaGen = fechaGen; }
    public void setExpiraEn(Timestamp expiraEn) { this.expiraEn = expiraEn; }
    public void setUsado(boolean usado) { this.usado = usado; }
}