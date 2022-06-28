// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./12_Figura_interface.sol";

//POLIMORFISMO
contract LlamadorFiguras {

    function verPerimetroContrato(address contrato) external returns (uint) {
        IFigura figura = IFigura(contrato);
        return figura.verPerimetro();
    }
}