// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract InstitutoDesafio {
    
    address owner;
    mapping(address => uint[]) private notasPorAlumno;

    event NotaAgregada(
        address indexed, 
        uint, 
        string);

    modifier isOwner() {
        require(msg.sender == owner, "No es el owner");
        _; 
    }

    constructor() {
        owner = msg.sender;
    }

    function agregarNota(string memory materia, address alumno, uint nota) external isOwner {
        notasPorAlumno[alumno].push(nota);
        emit NotaAgregada(alumno, nota, materia);
    }

    function calcularPromedio(address alumno) external view returns(uint) {
        uint suma;
        for(uint i = 0; i < notasPorAlumno[alumno].length; i++) {
            suma += notasPorAlumno[alumno][i];
        }
        return (suma/notasPorAlumno[alumno].length);
    }
}