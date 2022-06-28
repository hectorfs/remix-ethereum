// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./2_Owner.sol";

contract Storage is Owner {

    uint256 number;

    function store(uint256 num) public isOwner {
        number = num;
    }

    function retrieve() public view returns (uint256){
        return number;
    }
}