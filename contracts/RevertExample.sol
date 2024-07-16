// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract RevertExample {
    address immutable owner = msg.sender;
    uint counter;

    // @notice happens when someone else except the owner tries to invoke ownery functions
    error Unauthorized();
    
    // @notice happens when someont tries to send ether to thins contract
    error DoNotPayMe(uint);

    function increaseCounter(uint amount) external {
        if (msg.sender != owner) {
            revert Unauthorized(); // !!! gas efficient !!!
        }
        counter += amount;
    }

    function incrementCounter() public {
        // of course we can use require() AND custom modifiers here
        if (msg.sender != owner) {
            revert("Unauthorized string!");
        }
        counter++;
    }

    receive() external payable {
        counter++; // will be reverted because transaction will fail
        revert DoNotPayMe(msg.value); // you can pass parameters to custom errors
    }
}

contract OtherContract {
    RevertExample immutable example = new RevertExample();
    
    function payToExample() external {
        uint balance = address(this).balance;
        (bool ok, bytes memory returnData) = address(example).call{value: balance}("");
        // transaction will revert
        // returnData == first 4 bytes of keccak256("DoNotPayMe(uint)")
    }
}