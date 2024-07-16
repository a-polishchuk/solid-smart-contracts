// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract A {
    address immutable owner;

    constructor() {
        owner = msg.sender;
    }
}

contract B {
    address immutable owner = msg.sender; // the same as constructor option
}