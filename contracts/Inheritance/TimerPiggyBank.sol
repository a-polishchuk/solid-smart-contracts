// SPDX-License-Identifier: MIT
pragma solidity <0.9.0;

import "contracts/Inheritance/AbstractPiggyBank.sol";

contract TimerPiggyBank is AbstractPiggyBank {
    uint256 public immutable doNotOpenBefore;

    error TooEarly();

    constructor(uint256 _minDuration) {
        doNotOpenBefore = block.timestamp + _minDuration;
    }

    function withdraw() public override onlyOwner {
        if (block.timestamp < doNotOpenBefore) {
            revert TooEarly();
        }
        super.withdraw();
    }
}