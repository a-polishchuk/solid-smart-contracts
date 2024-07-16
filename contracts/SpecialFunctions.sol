// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract SpecialFunctions {
    address private immutable owner; // accessible only within contract
    uint internalStateVariable = 123; // accessible with contract and derived contracts
    uint defaultModifierInt; // == also internal state variable

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        // MUST BE external AND payable
        
        // triggered when someone sends ether to this contract with no callData (only ether) 

        // it's a more specialized version
    }

    fallback() external {
        // MUST BE external (but not necessary payable)
        
        // triggered when there is no other functions to handle incoming message
    }

    function internalFunc() internal {
        // can be called only from this contract or from derived contracts
    }

    function publicFunc() public {
        // can be called from everywhere
    }

    function externalFunc() external {

    }
}