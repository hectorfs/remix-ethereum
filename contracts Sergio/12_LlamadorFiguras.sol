// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./11_IFigura.sol";

contract LlamadorFiguras {
	
	function verPerimetroContrato(address contrato) external returns(uint) {
		IFigura figura = IFigura(contrato);
		return figura.verPerimetro();
        // ver en la salida de la transaccion, "el Decoded Output"
	}
}