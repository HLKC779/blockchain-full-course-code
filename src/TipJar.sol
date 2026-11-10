// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TipJar {
    struct Tip {
        address from;
        uint256 amount;
        string message;
    }

    address public owner;
    Tip[] private tips;

    event NewTip(address indexed from, uint256 amount, string message);

    constructor() {
        owner = msg.sender;
    }

    function tip(string memory message) public payable {
        require(msg.value > 0, "Tip must be more than zero");
        require(bytes(message).length <= 100, "Message too long");
        tips.push(Tip(msg.sender, msg.value, message));
        emit NewTip(msg.sender, msg.value, message);
    }

    function getTips() public view returns (Tip[] memory) {
        return tips;
    }

    function tipCount() public view returns (uint256) {
        return tips.length;
    }

    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw");
        uint256 amount = address(this).balance;
        (bool ok, ) = owner.call{value: amount}("");
        require(ok, "Transfer failed");
    }
}