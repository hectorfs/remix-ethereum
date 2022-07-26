// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;

contract Grafiti {

    struct Mensaje {
        address autor;
        string mensaje;
        uint fecha;
    }

    Mensaje ultimoMensaje;

    function guardarMensaje(string memory mensajeNuevo) external {
        ultimoMensaje.mensaje = mensajeNuevo;
        ultimoMensaje.autor = msg.sender;
        ultimoMensaje.fecha = block.timestamp;
    }

    function verMensaje() external view returns(Mensaje memory) {
        return ultimoMensaje;
    }
}