// SPDX-License-Identifier: GPL-3.0

import "hardhat/console.sol";

pragma solidity >=0.7.0 <0.9.0;

contract Cursomoneda {
    mapping(address => uint) balances;
    event Transferencia(address indexed emisor, address indexed receptor, uint monto);

    address[] cuentas;

    constructor(uint montoInicialSender) {
        require(montoInicialSender > 0, "El monto tiene que ser mayor a 0");

        console.log("hola mundo");

        balances[msg.sender] = montoInicialSender;
        cuentas.push(msg.sender);
    }

    function existeCuenta(address direccion) private view returns (bool) {
        bool encontrado;
        uint iterador;
        while (!encontrado && iterador < cuentas.length) {
            if (cuentas[iterador] == direccion) encontrado = true;
            else iterador++;
        }
        return encontrado;
    }

    function direccionSaldoMaximo() private view returns (address){
        uint saldoMaximo;
        address resultado; 

        for (uint i; i < cuentas.length; i++) {
            if (balances[cuentas[i]] > saldoMaximo) {
                saldoMaximo = balances[cuentas[i]];
                resultado = cuentas[i];
            }
        }

        return resultado;
    }

    function verBalance(address direccion) external view returns(uint) {
        return balances[direccion];
    }

    function transferir(address destino, uint monto) saldoSuficiente(monto) external {
        require(msg.sender != destino, "No podes transferirte a vos mismo");
        require(monto > 0, "El monto tiene que ser mayor a 0");

        balances[destino] += monto;
        balances[msg.sender] -= monto;

        // Si no existe la cuenta destino en cuentas la agrego
        if (! existeCuenta(destino)) {
            cuentas.push(destino);
        }

        emit Transferencia(msg.sender, destino, monto);
    }

    function emitirMoneda(address direccion, uint monto) external {
        // Si soy el maximo
        require(direccionSaldoMaximo() == msg.sender, "No sos la cuenta con mas saldo");

        require(direccion != msg.sender, "No puedo emitirme a mi mismo");
        require(monto < balances[msg.sender], "No puedo emitir mas que mi propio saldo");
        balances[direccion] += monto;

        // Si no existe la cuenta destino en cuentas la agrego
        if (! existeCuenta(direccion)) {
            cuentas.push(direccion);
        }
    }

    modifier saldoSuficiente(uint monto) {
        require(balances[msg.sender] >= monto, "No hay saldo suficiente");
        _;
    }
}