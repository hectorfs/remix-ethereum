// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
Cursomoneda:
- Almacena balances de usuario
- Transferencias entre usuarios (se modifican los balances)
- Chequeo de saldo (para poder hacer las transferencias -> hacerlo con modificador)
- Emitir un evento en cada transferencia
- Emision de moneda sólo para el usuario que más saldo tiene, y puede emitir menos que su propio saldo
- El constructor recibe un parametro que indica el saldo inicial de la cuenta sender
- El emisor no puede emitirse a si mismo
*/

contract CursoMonedaDesafioV1 {
   
    address[] users;
    mapping(address => uint) private balancePorUsuario;

    event Transferencia(
        address indexed origen,
        address indexed destino,
        uint monto,
        bool emision);

    modifier tieneSaldoSuficiente(uint montoTransferir) {
        require(balancePorUsuario[msg.sender] >= montoTransferir, "No tiene suficiente balance para realizar la transferencia");
        _; 
    }

    constructor(uint balanceInicial) {
        balancePorUsuario[msg.sender] = balanceInicial;
        users.push(msg.sender);
    }

    function emitir(address destino, uint monto) external {
        require(obtenerEmisor() == msg.sender, "No es la direccion con mayor balance");
        require(balancePorUsuario[msg.sender] > monto, "No puede emitir un monto igual o superior a su balance");

        ejecutarMovimiento(destino, monto, true);
    }

    function trasnferir(address destino, uint monto) external tieneSaldoSuficiente(monto) {
        ejecutarMovimiento(destino, monto, false);
    }

    function consultar() external view returns (uint){
        return balancePorUsuario[msg.sender];
    }

    function ejecutarMovimiento(address destino, uint monto, bool emision) private {
        validarMovimiento(destino, monto, emision ? "emitir":"transferir");

        if(!contains(destino)) {
            users.push(destino);
        } 

        if(!emision) {
            balancePorUsuario[msg.sender] -= monto;
        }
        balancePorUsuario[destino] += monto;

        emit Transferencia(msg.sender, destino, monto, emision);
    }

    function validarMovimiento(address destino, uint monto, string memory accion) private view {
        require(msg.sender != destino, concat("No se puede ", accion, " a si mismo, no gaste fee sin sentido"));
        require(destino != address(0), concat("No se puede quemar el monto a ", accion, ""));
        require(monto > 0, concat("el monto a ", accion, " no puede ser 0"));
    }

    function contains(address addr) private view returns (bool) {     
        for (uint i = 0; i < users.length;) {
            if(users[i] == addr) {
                return true;
            }
            unchecked{ i++; }
        }
       return false;
    }

    function obtenerEmisor() private view returns (address) {
        uint maxBalance;
        address emisor;
        
        for (uint i = 0; i < users.length;) {
            if(balancePorUsuario[users[i]] > maxBalance) {
                emisor = users[i];
                maxBalance = balancePorUsuario[users[i]];
            }
            unchecked{ i++; }
        }
       return emisor;
    }

    function concat(string memory a, string memory b, string memory c) private pure returns(string memory) {
       return string(abi.encodePacked(a,b,c));
    }
}