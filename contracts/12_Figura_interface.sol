// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

//INTERFACES
interface IFigura {

    function verPerimetro() external returns (uint);
    function verSuperficie() external returns (uint);
}

contract Cuadrado is IFigura {
    uint lado;

    constructor(uint _lado) {
        lado = _lado;
    }

    function verSuperficie() external view override returns (uint) {
        return lado * lado;
    }

    function verPerimetro() external view override returns (uint) {
        return 4 * lado;
    }
}

contract Circulo is IFigura {
    uint radio;

    uint constant pi = 314159;
    uint constant divisor = 100000;

    constructor(uint _radio) {
        radio = _radio;
    }

    function verSuperficie() external view override returns (uint) {
        return pi * radio * radio / divisor;
    }

    function verPerimetro() external view override returns (uint) {
        return 2 * pi * radio / divisor; 
    }
}