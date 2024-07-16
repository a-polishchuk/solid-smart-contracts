// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract PiggyBank {
  event Deposit(uint amount, uint totalBalance);
  event Withdraw();
  event WithdrawFailed();

  address private immutable owner;

  modifier onlyOwner() {
    require(msg.sender == owner, "only owner can call this function");
    _;
  }

  constructor() {
    owner = msg.sender;
  }

  function deposit() external payable {
    uint currentBalance = address(this).balance;
    emit Deposit(msg.value, currentBalance);
  }

  function withdraw() external onlyOwner {
    uint currentBalance = address(this).balance;
    (bool sent,) = msg.sender.call{value: currentBalance}("");
    if (sent) {
        emit Withdraw();
    } else {
        emit WithdrawFailed();
    }
  }
}