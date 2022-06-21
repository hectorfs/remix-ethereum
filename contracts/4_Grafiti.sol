// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Grafiti{

    struct Mensaje{
        address autor;
        string mensaje;
        uint fecha;
    }

    Mensaje ultimoMensaje;

    function guardarMensaje(string memory mensajeParaGuardar) public {
        ultimoMensaje.autor = msg.sender;
        ultimoMensaje.mensaje = mensajeParaGuardar;
        ultimoMensaje.fecha = block.timestamp;
    }

    function verMensajeGuardado() public view returns(Mensaje memory) {
        return ultimoMensaje;
    }
}