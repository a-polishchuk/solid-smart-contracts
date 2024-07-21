// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import "forge-std/console.sol";

contract OtherContract {
    event Log(string message);
    event Log(string message, uint amount);

    function someFunc() external {
        emit Log("someFunc called");
    }

    receive() external payable {
        emit Log("receive", msg.value);
    }

    fallback() external {
        emit Log("fallback");
    }
}

contract CallOtherContract {
    address private immutable deployer;
    OtherContract private immutable otherContract;
    
    constructor() {
        deployer = msg.sender;
        otherContract = new OtherContract();
    }

    receive() external payable {}

    function payOtherContract() external payable {
        (bool ok,) = address(otherContract).call{value: msg.value}("");
        require(ok, "transaction to otherContract failed");
    }

    function reachFallback() external {
        bytes memory callData = abi.encodeWithSignature("nonExistingFunc()", 145);
        (bool ok,) = address(otherContract).call(callData);
        require(ok, "fallback not reached");
    }

    function reachFallbackPayable() external payable {
        bytes memory callData = abi.encodeWithSignature("nonExistingFunc()", 100500);
        uint balance = address(this).balance;
        (bool ok,) = address(otherContract).call{value: balance}(callData);
        require(ok, "reachFallbackPayable failed");
    }
}   