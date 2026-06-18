package com.finca.services;

import com.finca.dao.LoteDAO;
import com.finca.dao.ProductoLacteoDAO;
import com.finca.models.LoteProduccion;
import com.finca.models.ProductoLacteo;

import java.util.List;

public class LacteosService {

    private final ProductoLacteoDAO lacteoDAO = new ProductoLacteoDAO();
    private final LoteDAO loteDAO = new LoteDAO();

    public List<ProductoLacteo> obtenerTodosProductos() {
        return lacteoDAO.obtenerTodos();
    }

    public List<LoteProduccion> obtenerTodosLotes() {
        return loteDAO.obtenerTodos();
    }

    public boolean registrarProducto(ProductoLacteo p) {
        return lacteoDAO.registrar(p);
    }

    public boolean eliminarProducto(int id) {
        return lacteoDAO.eliminar(id);
    }

    public boolean iniciarProduccion(LoteProduccion lote) {
        return loteDAO.iniciarProduccion(lote);
    }

    public boolean cambiarEstadoLote(int idLote, String nuevoEstado) {
        return loteDAO.cambiarEstado(idLote, nuevoEstado);
    }
}
