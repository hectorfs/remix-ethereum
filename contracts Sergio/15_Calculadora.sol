// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//Usar el compilador 0.7.0 -> asi veremos la falla que hay al hacer
//  require(balances[msg.sender] - monto > 0);
// producto del suboverflow

contract Calculadora {
	mapping(address => uint) balances;
	
	constructor() {
		balances[msg.sender] = 1000;
	}

	function transferir(address destino, uint monto) external {
		require(balances[msg.sender] - monto > 0);
		balances[msg.sender] -= monto;
        balances[destino] += monto;
	}

	function sumar(uint num1, uint num2) external pure returns(uint) {
		return num1 + num2;
	}
}