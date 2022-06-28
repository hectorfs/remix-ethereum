// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Banco {

    function transferirPorSend(address direccion, uint monto) external returns (bool) {
        return payable(direccion).send(monto);
    }

    function transferirPorTransfer(address direccion, uint monto) external returns (bool) {
        payable(direccion).transfer(monto);
        return true;
    }

    function transferirPorCall(address direccion, uint monto) external returns (bool) {
        (bool resultado, ) = direccion.call{value: monto}(""); // <<< (bool resultado, ) es una tuppla
        return resultado;
    }

    function recibirPago() external payable {
        // que monto enviamos "msg.value"
    }

    receive() external payable {
        //se ejecuta cuando recibe una transferencia
    }

    function verBalance() external view returns (uint) {
        return address(this).balance;
    }    
}