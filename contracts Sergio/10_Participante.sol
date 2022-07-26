// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

abstract contract Participante {
    string nombre;
    string apellido;

    constructor(string memory _nombre, string memory _apellido) {
        nombre = _nombre;
        apellido = _apellido;
    }
    
    function saludar() public view virtual returns(string memory) {
        return (string)(abi.encodePacked("hola ", nombre, " ", apellido));
    }
}

contract Docente is Participante {
    constructor(string memory _nombre, string memory _apellido) Participante(_nombre, _apellido) {}
}

contract Alumno is Participante {
    string legajo;
    constructor(string memory _nombre, string memory _apellido, string memory _legajo) Participante(_nombre, _apellido) {
        legajo = _legajo;
    }

    function saludar() public view override virtual returns (string memory) {
        string memory resultadoAnterior = super.saludar();
        return (string)(abi.encodePacked(resultadoAnterior, " legajo=", legajo));
    }
}
