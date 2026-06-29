package com.finca.models;

import java.sql.Date;
import java.sql.Timestamp;

public class Usuario {
    private int id;
    private String fullName;
    private String documentId;
    private String email;
    private String password;
    private String rol;
    private String profilePicture;
    private Timestamp createdAt;
    private Date fechaNacimiento;
    private String direccion;
    private String telefono;
    private String contactoEmergencia;
    private String eps;
    private String codigoEmpleado;
    private String cargo;
    private Date fechaIngreso;
    private String tipoContrato;
    private double salarioBase;
    private String horario;
    private String departamento;
    private String jefeInmediato;
    
    // 🆕 Nuevos campos obligatorios para Carnetización y RRHH
    private String estado;
    private String qrCodigo;
    private String tipoSangre;
    private String arl;
    
    // 🔒 Seguridad
    private boolean requiereCambioPassword;

    public Usuario() {}

    // =========================================================
    // GETTERS Y SETTERS COMPLETOS
    // =========================================================
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getDocumentId() { return documentId; }
    public void setDocumentId(String documentId) { this.documentId = documentId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }

    public String getProfilePicture() { return profilePicture; }
    public void setProfilePicture(String profilePicture) { this.profilePicture = profilePicture; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Date getFechaNacimiento() { return fechaNacimiento; }
    public void setFechaNacimiento(Date fechaNacimiento) { this.fechaNacimiento = fechaNacimiento; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getContactoEmergencia() { return contactoEmergencia; }
    public void setContactoEmergencia(String contactoEmergencia) { this.contactoEmergencia = contactoEmergencia; }

    public String getEps() { return eps; }
    public void setEps(String eps) { this.eps = eps; }

    public String getCodigoEmpleado() { return codigoEmpleado; }
    public void setCodigoEmpleado(String codigoEmpleado) { this.codigoEmpleado = codigoEmpleado; }

    public String getCargo() { return cargo; }
    public void setCargo(String cargo) { this.cargo = cargo; }

    public Date getFechaIngreso() { return fechaIngreso; }
    public void setFechaIngreso(Date fechaIngreso) { this.fechaIngreso = fechaIngreso; }

    public String getTipoContrato() { return tipoContrato; }
    public void setTipoContrato(String tipoContrato) { this.tipoContrato = tipoContrato; }

    public double getSalarioBase() { return salarioBase; }
    public void setSalarioBase(double salarioBase) { this.salarioBase = salarioBase; }

    public String getHorario() { return horario; }
    public void setHorario(String horario) { this.horario = horario; }

    public String getDepartamento() { return departamento; }
    public void setDepartamento(String departamento) { this.departamento = departamento; }

    public String getJefeInmediato() { return jefeInmediato; }
    public void setJefeInmediato(String jefeInmediato) { this.jefeInmediato = jefeInmediato; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getQrCodigo() { return qrCodigo; }
    public void setQrCodigo(String qrCodigo) { this.qrCodigo = qrCodigo; }

    public String getTipoSangre() { return tipoSangre; }
    public void setTipoSangre(String tipoSangre) { this.tipoSangre = tipoSangre; }

    public String getArl() { return arl; }
    public void setArl(String arl) { this.arl = arl; }

    public boolean isRequiereCambioPassword() { return requiereCambioPassword; }
    public void setRequiereCambioPassword(boolean requiereCambioPassword) { this.requiereCambioPassword = requiereCambioPassword; }
}