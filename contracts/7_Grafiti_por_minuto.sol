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
        if (ultimoMensaje.autor == msg.sender){
            uint diff = block.timestamp - ultimoMensaje.fecha;

            if (diff <= 1 minutes) revert ("Solo puede guardar 1 mensaje por minuto");
        }

        ultimoMensaje.autor = msg.sender;
        ultimoMensaje.mensaje = mensajeParaGuardar;
        ultimoMensaje.fecha = block.timestamp;
    }

    function verMensajeGuardado() public view returns(Mensaje memory) {
        return ultimoMensaje;
    }
}