// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract ArraysTest {
    uint[3] public nums = [1, 2, 3];

    event Log(uint);

    modifier withLogs() {
        emit Log(nums[1]);
        _;
        emit Log(nums[1]);
    }

    constructor() withLogs {
        modifyArray(nums);
    }

    // note that this function is pure, it does not mutates the state
    // memory arr creates in-memory copy of an array
    function modifyArray(uint[3] memory arr) internal pure {
        arr[1] = 45;
    }

    // calldata is for external calls - transactions
    // calldata is readonly, you cannot modify this array
    // it's like memory but readonly
    // in this case you can replace it with memory modifier
    function getArrayLength(uint[] calldata arr) external pure returns(uint) {
        return arr.length;
    }
}