package com.finca.services;

import java.util.List;

import com.finca.dao.UsuarioDAO;
import com.finca.models.Usuario;

public class EmpleadoService {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    public List<Usuario> obtenerTodos() {
        return usuarioDAO.obtenerTodos();
    }

    public boolean eliminar(int id) {
        return usuarioDAO.eliminar(id);
    }

    public boolean actualizarPerfil(Usuario u) {
        return usuarioDAO.actualizarPerfil(u);
    }

    public boolean registrar(Usuario u) {
        if (usuarioDAO.registrar(u)) { 
            Usuario recienCreado = usuarioDAO.obtenerPorEmail(u.getEmail());
            if (recienCreado != null) {
                u.setId(recienCreado.getId());
                usuarioDAO.actualizarPerfil(u);
            }
            return true;
        }
        return false;
    }
}
