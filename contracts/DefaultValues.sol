// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import { StringUtils } from "./Library.sol";

contract DefaultValues {
    bool public myBool; // == false
    bool public isStringEmpty; // reassigned in constructor

    uint256 public myUint; // == 0
    
    // ! DON'T DO THAT, save some gas, value is already == 0
    uint256 public myAnotherUint = 0;

    int256 public myInt; // == 0

    // yes, it's also a special primitive type in Solidity
    address public myAddress; // == address(0) which is 0x0000000000000000000000000000000000000000

    string public myString;

    // this is a fixed size array: [0, 0, 0, 0, 0]    
    uint256[5] public myFixedSizeArray;

    // size is fixed, all the values are default primitive values, in this case - false
    bool[3] public myBooleanArray;

    constructor() {
        isStringEmpty = StringUtils.compareStrings(myString, "");
    }
}