// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

abstract contract Ownable {
    address internal owner = msg.sender;

    error NotAnOwner(address a);
    error AlreadyAnOwner(address a);

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotAnOwner(msg.sender);
        }
        _;
    }

    function transferOwner(address newOwner) external onlyOwner {
        if (newOwner == owner) {
            // no need to overwrite storage, let's revert this transaction
            revert AlreadyAnOwner(owner);
        }
        owner = newOwner;
    }

    function getOwner() external view returns(address) {
        return owner;
    }
}
