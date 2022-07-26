// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract GrafitiDesafio {

    struct Mensaje {
        address autor;
        string mensaje;
        uint fecha;
    }

    Mensaje ultimoMensaje;

    function guardarMensaje(string memory mensajeNuevo) external {
        if (msg.sender == ultimoMensaje.autor) {
            uint diffTime = block.timestamp - ultimoMensaje.fecha;
            if (diffTime < 2 minutes) {
                revert("Debe esperar 2 min o esperar a que otra persona deje un mensaje.");
            }
        } else {
            ultimoMensaje.autor = msg.sender;
        }

        ultimoMensaje.mensaje = mensajeNuevo;
        ultimoMensaje.fecha = block.timestamp;
    }

    function verMensaje() external view returns(Mensaje memory) {
        return ultimoMensaje;
    }
}