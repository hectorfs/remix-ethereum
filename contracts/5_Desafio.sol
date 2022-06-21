// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Desafio {

    struct Valor {
        uint ultimoNumero;
        uint acumulador;
    }

    Valor valor;

    function guardar(uint num) public {
        valor.ultimoNumero = num;
        valor.acumulador += num;
    }

    function leer() public view returns (Valor memory) {
        return valor;
    }
}