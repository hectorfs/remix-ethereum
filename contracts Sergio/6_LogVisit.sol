// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;

contract LogVisit {

    address[] visits;
    address admin;

    constructor(){
        admin = msg.sender;
    }

    function visit() external {
        visits.push(msg.sender);
    }

    function viewLog() external view returns(address[] memory) {
        if (msg.sender != admin) revert("the user not is admin");

        return visits;
    }
}