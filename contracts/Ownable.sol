// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract Ownable {
    address internal owner = msg.sender;

    error NotAnOwner(address a);
    error AlreadyAnOwner(address a);

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotAnOwner(msg.sender);
        }
        _;
    }

    function transferOwner(address newOwner) external onlyOwner {
        if (newOwner == owner) {
            // let's try to save some gas
            revert AlreadyAnOwner(owner);
        }
        owner = newOwner;
    }

    function getOwner() external view returns(address) {
        return owner;
    }
}

interface IPiggyBank {
    function deposit() external payable;
    function withdraw() external; 
}

// contract can have more than one parent
contract PiggyBank is Ownable, IPiggyBank {
    event Deposited(address from, uint amount);
    event Withdrawal(uint amount);

    error NoSuchMethod(bytes callData);

    function deposit() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw() external onlyOwner {
        uint currentBalance = address(this).balance;
        (bool success,) = owner.call{value: currentBalance}("");
        require(success);
    }

    receive() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    fallback() external {
        revert NoSuchMethod(msg.data);
    }
}