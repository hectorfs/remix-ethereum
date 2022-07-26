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

struct User {
    address addr;
    uint balance;
}

struct itmap {
    mapping(uint => User) data;
    mapping(address => uint) key;
    uint size;
}

library IterableMapping {
    function insert(itmap storage self, address key, User memory value) internal returns (bool replaced) {
        uint keyIndex = self.key[key];
        if (keyIndex > 0){
            replaced = true;
        } else {
            self.size++;
            self.key[key] = self.size;
        }
        self.data[self.size] = value;
    }

    function contains(itmap storage self, address key) internal view returns (bool) {
        return self.key[key] > 0;
    }

    function get(itmap storage self, address key) internal view returns (User storage value) {
        value = self.data[self.key[key]];
    }

    function iterateValid(itmap storage self, uint keyIndex) internal view returns (bool) {
        return keyIndex <= self.size;
    }

    function iterateGet(itmap storage self, uint keyIndex) internal view returns (User storage value) {
        value = self.data[keyIndex];
    }
}


contract CursoMonedaDesafioV2 {

    using IterableMapping for itmap;

    itmap users;

    event Transferencia(
        address indexed origen,
        address indexed destino,
        uint monto,
        bool emision);

    modifier tieneSaldoSuficiente(uint montoTransferir) {
        require(users.get(msg.sender).balance >= montoTransferir, "No tiene suficiente balance para realizar la transferencia");
        _; 
    }

    constructor(uint balanceInicial) {
        User memory newUser = User(msg.sender, balanceInicial);
        users.insert(msg.sender, newUser);
    }

    function trasnferir(address destino, uint monto) external tieneSaldoSuficiente(monto) {
        ejecutarMovimiento(destino, monto, false);
    }

    function emitir(address destino, uint monto) external {
        require(obtenerEmisor() == msg.sender, "No es la direccion con mayor balance");
        require(users.get(msg.sender).balance > monto, "No puede emitir un monto igual o superior a su balance");
        
        ejecutarMovimiento(destino, monto, true);
    }

    function consultar() external view returns (uint){
        return users.get(msg.sender).balance;
    }

    function ejecutarMovimiento(address destino, uint monto, bool emision) private {
        validarMovimiento(destino, monto, emision ? "emitir":"transferir");

        if(!users.contains(destino)) {
            User memory newUser = User(destino, monto);
            users.insert(destino, newUser);
        } else {
            User storage userDestino = users.get(destino);
            userDestino.balance += monto;
        }

        if(!emision) {
            User storage userOrigen = users.get(msg.sender);
            userOrigen.balance -= monto;
        }

        emit Transferencia(msg.sender, destino, monto, emision);
    }

    function validarMovimiento(address destino, uint monto, string memory accion) private view {
        require(msg.sender != destino, concat("No se puede ", accion, " a si mismo, no gaste fee sin sentido"));
        require(destino != address(0), concat("No se puede quemar el monto a ", accion, ""));
        require(monto > 0, concat("el monto a ", accion, " no puede ser 0"));
    }

    function obtenerEmisor() private view returns (address) {
        uint maxBalance;
        address emisor;
        
        for (uint i = 1; users.iterateValid(i);) {
            (User memory value) = users.iterateGet(i);

            if(value.balance > maxBalance) {
                emisor = value.addr;
                maxBalance = value.balance;
            }

            unchecked{ i++; }
        }

       return emisor;
    }

    function concat(string memory a, string memory b, string memory c) private pure returns(string memory) {
       return string(abi.encodePacked(a,b,c));
    }
}