// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import "contracts/Ownable.sol";

abstract contract AbstractPiggyBank is Ownable {
    event Deposit(address from, uint256 amount);
    event Withdraw(uint256 amount);

    error NothingToDeposit(address from);
    error WithdrawFailed(bytes data);
    error NoSuchMethod(bytes data);

    function deposit() public payable virtual {
        if (msg.value == 0) {
            revert NothingToDeposit(msg.sender);
        }
        emit Deposit(msg.sender, msg.value);    
    }
    
    function withdraw() public virtual onlyOwner {
        uint256 balance = getBalance();
        (bool success, bytes memory returnData) = msg.sender.call{value: balance}("");
        if (!success) {
            revert WithdrawFailed(returnData);
        }
        emit Withdraw(balance);
    }

    function getBalance() internal view returns(uint256) {
        return address(this).balance;
    }

    receive() external payable {
        deposit();
    }

    fallback() external {
        revert NoSuchMethod(msg.data);
    }
}

// here is the question: will event emit also be reverted if transaction failed? check it