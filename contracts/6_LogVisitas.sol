// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract LogVisitas {

    address[] visitantes;
    address admin;

    constructor(){
        admin = msg.sender;
    }

    function visitar() external {
        visitantes.push(msg.sender);
    }

    function verLog() external view returns (address[] memory) {
        if (msg.sender != admin) revert ("El usuario no es ADMIN");
        return visitantes;
    }
}