// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// A savings jar with a bug. Can you spot it?
contract Piggy {
    address public owner;
    bool private locked;

    constructor() payable {
        owner = msg.sender;
    }

    modifier nonReentrant() {
        require(!locked, "Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    function withdraw() public nonReentrant {
        require(msg.sender == owner, "Only the owner");
        uint256 amount = address(this).balance;
        (bool ok, ) = payable(owner).call{value: amount}("");
        require(ok, "Transfer failed");
    }
}