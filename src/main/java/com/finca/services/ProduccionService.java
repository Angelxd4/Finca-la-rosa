package com.finca.services;

import com.finca.dao.ProduccionDAO;
import com.finca.models.Ordeno;
import java.sql.Timestamp;
import java.util.List;

public class ProduccionService {

    private final ProduccionDAO produccionDAO = new ProduccionDAO();

    public List<Ordeno> obtenerHistorial(String filtro) {
        return produccionDAO.obtenerHistorial(filtro);
    }

    public double obtenerStock(String idTanque) {
        return produccionDAO.obtenerStock(idTanque);
    }

    public double[] obtenerEstadisticas(String filtro) {
        return produccionDAO.obtenerEstadisticas(filtro);
    }

    public boolean registrarSesion(Ordeno ordeno) {
        return produccionDAO.registrarSesion(ordeno);
    }

    public boolean fueOrdenadaEnTurno(int idBovino, Timestamp fechaHora) {
        return produccionDAO.fueOrdenadaEnTurno(idBovino, fechaHora);
    }

    public boolean asignarLeche(String filtro, String turno, double porcFabrica) {
        return produccionDAO.asignarLeche(filtro, turno, porcFabrica);
    }

    public boolean vaciarDescartePendiente(String filtro) {
        return produccionDAO.vaciarDescartePendiente(filtro);
    }
}

