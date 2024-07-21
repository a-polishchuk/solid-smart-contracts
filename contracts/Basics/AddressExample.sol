// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AddressExample {
    address public immutable defaultValue; // 0x0
    address public immutable deployer;

    address public lastSender;
    uint256 public lastValue;

    event Receive(address a, uint256 value);

    constructor() {
        deployer = msg.sender;
    }

    receive() external payable {
        lastSender = msg.sender;
        lastValue = msg.value;
        emit Receive(msg.sender, msg.value);
    }

    function getCurrentBalance() public view returns(uint256) {
        // we need to cast "this" to address type first
        address thisAddress = address(this);

        // each address has built-in field balance 
        return thisAddress.balance;
    }
}