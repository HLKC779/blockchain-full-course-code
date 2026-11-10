// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Poll {
    string public question;
    string[] public options;
    mapping(uint256 => uint256) public votes;
    mapping(address => bool) public hasVoted;

    event Voted(address indexed voter, uint256 option);

    constructor(string memory q, string[] memory opts) {
        require(opts.length >= 2, "Need at least two options");
        question = q;
        options = opts;
    }

    function vote(uint256 option) public {
        require(option < options.length, "No such option");
        require(!hasVoted[msg.sender], "Already voted");
        hasVoted[msg.sender] = true;
        votes[option] += 1;
        emit Voted(msg.sender, option);
    }

    function winner() public view returns (uint256 best) {
        best = 0;

        for (uint256 i = 1; i < options.length; i++) {
            if (votes[i] > votes[best]) {
                best = i;
            }
        }
    }
}