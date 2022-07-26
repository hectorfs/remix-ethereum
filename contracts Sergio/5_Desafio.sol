// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;

contract Desafio {

    uint lastNumber;
    uint totalNumber;

    function saveNumber(uint newLastNumber) external {
        lastNumber = newLastNumber;
        totalNumber += newLastNumber;
    }

    function getLastAndTotalNumber() external view returns(uint, uint) {
        return (lastNumber, totalNumber);
    }
}
