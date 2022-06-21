// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
/* Cursomoneda:
- Balances de usuario (se pueden chequear)
- Transferencias entre usuarios
- Chequeo de saldo suficiente (usar modifiers)
- Emitir un evento en cada transferencia (decidir que datos emitir)
- Emision de moneda sólo para el usuario que más saldo tiene, y puede emitir menos que su propio saldo
- El constructor recibe un parametro que indica el saldo inicial de la cuenta sender
- El emisor no puede emitirse a si mismo */
contract CursoMoneda {

    mapping(address => Cuenta) private cuentas;
    
    struct Cuenta {
        uint saldo;
        string usuario;
    }
    
    event EventoTransferencia(address origen, address destino, uint monto);

    constructor(uint saldoInicial) {
        cuentas[msg.sender].saldo += saldoInicial;
    }

    modifier esTitular() {
        // require(cuentas[msg.sender] != msg.sender,
        //  "No es titular de cuenta, autorizado para la operacion");
        _; 
    }

    function consultaSaldo(address cuenta) external esTitular view returns(uint) {
        return cuentas[cuenta].saldo;
    }
    
    function transferir(address cuentaOrigen, address cuentaDestino, uint monto) external returns(bool) {
        
        if(cuentas[cuentaOrigen].saldo < monto){
            revert ("Saldo insuficiente");
        }

        cuentas[cuentaDestino].saldo += monto;
        cuentas[cuentaOrigen].saldo -= monto;

        emit EventoTransferencia(cuentaOrigen, cuentaDestino, monto);
        return true;
    }
}