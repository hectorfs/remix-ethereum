// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./2_Owner.sol";

/*
-Generar un contrato "Moneda" (que tendra el supply como dato para otener).
-Generar un contrato "Ranking", que va a tener una coleccion de "Moneda" y cada vez que se crea una moneda se debe agregar al ranking.
-El contrato Ranking, expone la funcionalidad de cual es la que mas emision tiene y la que menos.
*/

abstract contract Moneda {
    string public nombre;
    uint public supply;
    //public genera el get pero no genera el set.

    constructor(string memory _nombre, uint _supply) {
        require(_supply > 0, "supply no puede ser 0");
        nombre = _nombre;
        supply = _supply;
    }
}

contract MonedaUno is Moneda {
    constructor(uint supply) Moneda("MonedaUno", supply) {}
}

contract MonedaDos is Moneda {
    constructor(uint supply) Moneda("MonedaDos", supply) {}
}

contract MonedaTres is Moneda {
    constructor(uint supply) Moneda("MonedaTres", supply) {}
}

contract Ranking is Owner {

    struct MonedaRanking {
        string nombre;
        uint supply;
    }

    Moneda[] monedas;
    mapping(address => bool) monedaIngresada;

    function addMoneda(address contratoMoneda) external isOwner {
        require(contratoMoneda != address(0), "La direccion es invalida");
        require(!monedaIngresada[contratoMoneda], "La moneda ya fue ingresada");
        monedas.push(Moneda(contratoMoneda));
    }

    function getMonedaMaxAndMinSupply() external view returns(MonedaRanking memory maxSupply, MonedaRanking memory minSupply) {
        require(monedas.length > 0, "no hay monedas en el ranking");
        
        uint indexMinSupply;
        uint indexMaxSupply;

        for (uint i = 1; i < monedas.length;) {

            if(monedas[i].supply() > monedas[indexMaxSupply].supply()) {
                indexMaxSupply = i;
            }
            
            if(monedas[i].supply() < monedas[indexMinSupply].supply()) {
                indexMinSupply = i;
            }

            unchecked{ i++; }
        }

        maxSupply.nombre = monedas[indexMaxSupply].nombre();
        maxSupply.supply = monedas[indexMaxSupply].supply();
        minSupply.nombre = monedas[indexMinSupply].nombre();
        minSupply.supply = monedas[indexMinSupply].supply();
    }
}