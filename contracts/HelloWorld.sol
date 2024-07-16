// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import { Ownable } from "./Ownable.sol";
import { StringUtils } from "./Library.sol";

contract HelloWorld is Ownable {
  event Log(string message);
  event Log(string message, uint256 value);

  error NoSuchMethod();
  error HelloWorldNotAllowedHere();

  string internal text = "This is my text!";

  function getText() external view returns(string memory) {
    return text;
  }

  function setText(string calldata _text) external {
    if (StringUtils.compareStrings(_text, "Hello, world!")) {
      revert HelloWorldNotAllowedHere();
    }
    text = _text;
  }

  function payMe() external payable {
    emit Log("Payment received", msg.value);
    if (msg.sender == owner) {
      emit Log("Owner did a payment");
    }
  }

  receive() external payable {
    emit Log("Payment received without any calldata. Thank you anyway!", msg.value);
  }

  fallback() external {
    revert NoSuchMethod();
  }
}
