package com.finca.services;

import com.finca.dao.BovinoDAO;
import com.finca.models.Bovino;

import java.util.List;

public class BovinoService {

    private final BovinoDAO bovinoDAO = new BovinoDAO();

    public List<Bovino> obtenerPorClasificacion(String clasificacion) {
        return bovinoDAO.obtenerPorClasificacion(clasificacion);
    }

    public void registrarBovino(Bovino bovino) {
        bovinoDAO.registrar(bovino);
    }

    public void actualizarBovino(Bovino bovino) {
        bovinoDAO.actualizar(bovino);
    }

    public void eliminarBovino(int idBovino) {
        bovinoDAO.eliminar(idBovino);
    }

    public void cambiarClasificacion(int idBovino, String nuevaClasificacion) {
        bovinoDAO.cambiarClasificacion(idBovino, nuevaClasificacion);
    }

    public Bovino obtenerPorId(int idBovino) {
        return bovinoDAO.obtenerPorId(idBovino);
    }

    public List<com.finca.models.HistorialClinico> obtenerHistorial(int idBovino) {
        return bovinoDAO.obtenerHistorial(idBovino);
    }

    public boolean registrarHistorial(com.finca.models.HistorialClinico h) {
        return bovinoDAO.registrarHistorial(h);
    }
}
