// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

interface ISubscriber {
    function onTransfer(address from, address to, uint256 amount) external;
}

contract TransferSubscription {
    // typically all address params should be indexed
    // and amount params should not
    // no need to make everything indexed, it's gas expensive
    event Transfer(address indexed from, address indexed to, uint256 amount);

    error AlreadySubscribed(address addr);
    error NotSubscribed(address addr);

    // TODO: try to use custom struct instead of just bool
    // we also want to store address index in subsArray for gas optimisation
    // try that and compare gas consumption in both cases
    mapping(address => bool) subsMapping;
    address[] subsArray;

    function subscribe() public {
        if (subsMapping[msg.sender]) {
            revert AlreadySubscribed(msg.sender);
        }
        subsMapping[msg.sender] = true;
        subsArray.push(msg.sender);
    }

    function unsubscribe() public {
        if (!subsMapping[msg.sender]) {
            revert NotSubscribed(msg.sender);
        }
        subsMapping[msg.sender] = false;
        uint256 length = subsArray.length;
        
        // special case to save some gas
        if (length == 1) {
            subsArray.pop();
            return;
        }
        
        // still this operation seems to be too expensive
        for (uint256 i = 0; i < length; i++) {
            if (subsArray[i] == msg.sender) {
                subsArray[i] = subsArray[length - 1];
                subsArray.pop();
                break;
            }
        }
    }

    function transfer(address to, uint256 amount) public {
        // ... actual transfer code ...
        // using ERC20 token for example
        // we're interested in a subscription mechanism in this example

        emit Transfer(msg.sender, to, amount);
        notifyAboutTransfer(to, amount);
    }

    function notifyAboutTransfer(address to, uint256 amount) internal {
        // optimising gas, less storage reads
        uint256 length = subsArray.length;
        for (uint256 i = 0; i < length; i++) {
            ISubscriber(subsArray[i]).onTransfer(msg.sender, to, amount);
        }
    }
}