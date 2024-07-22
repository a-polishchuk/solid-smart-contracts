// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import "contracts/Inheritance/AbstractPiggyBank.sol";

contract TargetPiggyBank is AbstractPiggyBank {
    uint256 immutable goal;

    error GoalNotReachedYet(uint256 balance);

    constructor(uint256 _goal) {
        goal = _goal;
    }

    function withdraw() public override onlyOwner {
        uint256 balance = getBalance();
        if (getBalance() < goal) {
            revert GoalNotReachedYet(balance);
        }
        super.withdraw();
    }
}