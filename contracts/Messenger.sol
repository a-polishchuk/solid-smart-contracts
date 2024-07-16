// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Messenger {
    struct Message {
        address from;
        string text;
        uint256 editsCount;
    }

    event MessagePosted(uint id, address from, string text);
    event MessageEdited(uint id, address from, string text);

    error Unauthorized();

    address internal immutable admin;
    Message[] internal messages;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        if (msg.sender != admin) {
            revert Unauthorized();
        }
        _;
    }

    function postMessage(string calldata _text) external {
        messages.push(Message(msg.sender, _text, 0));
        uint256 id = messages.length - 1;
        emit MessagePosted(id, msg.sender, _text);
    }

    function editMessage(uint id, string calldata _text) external {
        Message storage m = messages[id];
        if (msg.sender != m.from) {
            revert Unauthorized();
        }
        m.text = _text;
        m.editsCount++;
        emit MessageEdited(id, msg.sender, _text);
    }

    function deleteMessage(uint id) external onlyAdmin {
        string memory deletedText = "-- deleted by Admin --";
        messages[id].text = deletedText;
        emit MessageEdited(id, admin, deletedText);
    }

    function getMessage(uint id) external view returns (Message memory) {
        return messages[id];
    }
}