// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

library StringUtils {
    function compareStrings(string memory a, string memory b) public pure returns(bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}