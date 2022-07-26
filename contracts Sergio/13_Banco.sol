// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Banco {

	function verBalance() external view returns(uint){
		return address(this).balance;
	}

	function TransferirPorSend(address direccion, uint monto) external returns(bool) {
		return payable(direccion).send(monto);
	}

	function TransferirPorTransfer(address direccion, uint monto) external returns(bool) {
		payable(direccion).transfer(monto);
        return true;
	}

	function TransferirPorCall(address direccion, uint monto) external returns(bool) {
		(bool resultado, ) = direccion.call{value: monto}("");
		return resultado;
	}

	/******** RECIBIR PAGOS *********/
	mapping(address => uint) balances;

	function recibirPago() external payable {
		balances[msg.sender] += msg.value;
	}

	receive() external payable {
		balances[msg.sender] += msg.value;
	}


	/******** CALL para consultar otros contratos *********/
	function verSupplyTether() external returns (uint) {
		address direccion = 0xa1Cba00d6e99f52B8cb5f867a6f2db0F3ad62276;

		(bool resultado, bytes memory respuesta) = direccion.call(abi.encodeWithSignature("getSupply()"));
		// en caso de recibir parametros el encabezado abi.encodeWithSignature("getSupply()",10,100)

		if (!resultado)
			revert("error funcion call");

		return abi.decode(respuesta, (uint));
	}
}