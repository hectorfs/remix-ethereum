// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./2_Owner.sol";

/*
-Generar un contrato que reciba apuestas (pagos).
-Tiene que ir contando cuantos ethers recibe, cuando llega a 10 ethers, le tiene
    que transferir el total al que tiene la mayor apuesta.

    -Opcion 1: el ultimo que apuesta y hace superar los 10 ethers,
    en esa transaccion se hace el pago al ganador.
    -Opcion 2: cuando se llegue a 10 ethers, que se bloqueen las apuestas hasta
    que el ganador reclame el pago.
        (elijo la opcion 2 porque me parece valido que se detengan las apuestas,
        para que se deje de recibir ether protegiendo a los que no estan al tanto
        que finalizo.)
*/

/*******************************************************************************
    Hay una vulnerabilidad en este ejercicio, el primero en apostar la mitad del
        limite maximo, sera siempre el ganador.
    Tambien se puede revisar por fuera del contrato,  quien tiene la mayor apuesta
        en cualquier momento y cuanto falta para llegar al maximo.
********************************************************************************/

contract Apuestas is Owner {

    enum Status {
        INICIADA,
        FINALIZADA,
        COBRADA
    }

    uint limiteMaximo;
    uint balancePrevio;
    Status estado = Status.COBRADA;
    address mayorApuesta;
    mapping(address => uint) apuestadoresIndice;
    uint[] apuestas;

    constructor() {
        /* se descarta el elemento 0; el mismo sera utilizado como parte de 
        la logica, para determinar si agregar o no al indice. */
        apuestas.push();
    }

    event ApuestaCerrada(
        address indexed ganador,
        uint premio
    );

    receive() external payable {
        if(estado == Status.FINALIZADA) {
            revert("La apuesta se encuentra finalizada");
        } else if(estado == Status.COBRADA) {
            revert("La apuesta no se encuentra iniciada");
        }

        require(msg.value > 0, "El ether enviado no puede ser 0");

        // Se debe utilizar el valor enviado hasta superar el limite. Se debe evitar 
        // que un apostador exceda el limite y se calcule el total enviado, para evitar
        // este escenario. Ejemplo: En el medio de la apuesta, un apostador puede poner
        // el maximo o mas, y al ser la mayor apuesta se lleva todo.
        uint resta = limiteMaximo - balancePrevio;
        uint apuesta = msg.value;
        if (msg.value > resta) {
            apuesta = resta;
        }

        // Se busca el indice mediante el mapping y luego se busca la apuesta
        // en el array, en caso de que el mapping devuelva 0, se hace push.
        uint indiceMayorApuesta = apuestadoresIndice[mayorApuesta];
        uint indice = apuestadoresIndice[msg.sender];
        if(indice == 0) {
            indice = apuestas.length;
            apuestadoresIndice[msg.sender] = indice;
            apuestas.push(apuesta);
        } else {
            apuestas[indice] += apuesta;
        }

        if(apuestas[indice] > apuestas[indiceMayorApuesta]) {
            mayorApuesta = msg.sender;
        }

        if (address(this).balance >= limiteMaximo) {
            estado = Status.FINALIZADA;
            emit ApuestaCerrada(mayorApuesta, address(this).balance);
        } else {
            balancePrevio += msg.value;
        }
    }

    function retirarPremio(address ganador) external {
        require(estado == Status.FINALIZADA, "La apuesta no se encuentra finalizada");
        require(ganador == mayorApuesta, "No es la persona ganadora");

        estado = Status.COBRADA;
        balancePrevio = 0;

        payable(ganador).transfer(address(this).balance);
    }    
    
    //10 ether to wei is 10000000000000000000     
    function iniciarApuesta(uint _limteMaximo) external isOwner {
        require(estado == Status.COBRADA, "La apuesta no se encuentra cobrada");
        require(address(this).balance == 0, "Todavia no se reclamo el premio");

        limiteMaximo = _limteMaximo;
        estado = Status.INICIADA;

        for(uint i; i < apuestas.length;) {
            apuestas[i] = 0;
            unchecked{ i++; }
        }
    }

    function verBalance() external view isOwner returns(uint) {
        return address(this).balance;
    }
}