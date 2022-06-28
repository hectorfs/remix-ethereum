// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

//HERENCIA
contract Participante {

    string nombre;
    string apellido;

    constructor(string memory _nombre, string memory _apellido) {
        nombre = _nombre;
        apellido = _apellido;
    }

    
    //el modificador "virtual" abre el metodo para que sea re-escribible
    function saludo() public view virtual returns (string memory){
        return ((string) (abi.encodePacked("Hola ", nombre, " ", apellido)));
    }
}

contract Alumno is Participante {
   
    string idAlumno;
    
    constructor(string memory _nombre, string memory _apellido, string memory _idAlumno) Participante (_nombre, _apellido) {
        idAlumno  = _idAlumno;
    }

    function saludo() public view override returns (string memory){
        return ((string) (abi.encodePacked("Hola ", nombre, " ", apellido, " ", idAlumno)));
    }
}

contract Docente is Participante {
    string idDocente;

    constructor(string memory _nombre, string memory _apellido, string memory _idDocente) Participante (_nombre, _apellido) {
        idDocente  = _idDocente;
    }

    function saludo() public view override returns (string memory){
        string memory resultadoAnterior = super.saludo(); //otra forma
        return ((string) (abi.encodePacked(resultadoAnterior, " ", idDocente)));
    }
    
}