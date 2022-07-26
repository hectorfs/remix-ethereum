// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract InstitutoDesafio {
   
    address owner;
    mapping(address => uint[]) private notasPorAlumno;

    event NotaAgregada(
        address indexed alumno, 
        uint nota, 
        string materia);

    modifier isOwner() {
        require(msg.sender == owner, "No es el owner");
        _; 
    }

    constructor() {
        owner = msg.sender;
    }

    function agregarNota(string memory materia, address alumno, uint nota) external isOwner {
        //no se puede agregar una nota a la direccino del owner
        //que no se pueda poner nota superior a 10
        // no se puede agregar nota a la direccion 0
        
        notasPorAlumno[alumno].push(nota);
        emit NotaAgregada(alumno, nota, materia);
    }

    function calcularPromedio(address alumno) external view returns(uint) {
        require(notasPorAlumno[alumno].length > 0, "el alumno no tiene notas cargadas o no existe");
        
        uint suma;
        for(uint i = 0; i < notasPorAlumno[alumno].length; i++) {
            suma += notasPorAlumno[alumno][i];
        }

        return (suma/notasPorAlumno[alumno].length);
    }
}