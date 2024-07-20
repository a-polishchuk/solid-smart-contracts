// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import "contracts/PiggyBank/AbstractPiggyBank.sol";

contract HumblePiggyBank is AbstractPiggyBank {
    uint256 maxDeposit;

    error ThatIsTooMuch(address from, uint256 amount);

    constructor(uint256 _maxDeposit) {
        maxDeposit = _maxDeposit;
    }

    function deposit() public payable override {
        if (msg.value > maxDeposit) {
            revert ThatIsTooMuch(msg.sender, msg.value);
        }
        super.deposit();
    }
}