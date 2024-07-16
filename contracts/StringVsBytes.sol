// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// strings and bytes are the same under the hood
// better to avoid using strings in Solidity, except for the rare cases
contract StringsVsBytes {

    string public myString = "Hello world";
    bytes public myBytes = "Hello world";

    function getBytesLength() external view returns(uint256) {
        return myBytes.length; // 11
    }

    // YEP, they are equal
    // or I would say their hashes are equal
    function areTheyEqual() external view returns(bool) {
        return keccak256(abi.encodePacked(myString)) == keccak256(myBytes);
    }
}