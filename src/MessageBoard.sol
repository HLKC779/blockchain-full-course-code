// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract MessageBoard {
    address public immutable owner;
    string public message;
    uint256 public updates;

    event MessageChanged(address indexed by, string newMessage);

    constructor(string memory firstMessage) {
        require(bytes(firstMessage).length > 0, "Message cannot be empty");
        owner = msg.sender;
        message = firstMessage;
    }

    function setMessage(string memory newMessage) public {
        require(msg.sender == owner, "Only the owner can post");
        require(bytes(newMessage).length > 0, "Message cannot be empty");
        message = newMessage;
        updates += 1;
        emit MessageChanged(msg.sender, newMessage);
    }
}