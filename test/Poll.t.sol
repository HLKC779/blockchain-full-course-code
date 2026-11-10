// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {Poll} from "../src/Poll.sol";

contract PollTest is Test {
    Poll poll;

    function setUp() public {
        string[] memory opts = new string[](3);
        opts[0] = "Python";
        opts[1] = "Solidity";
        opts[2] = "JavaScript";
        poll = new Poll("Favourite language?", opts);
    }

    function test_VotesAreCounted() public {
        vm.prank(address(1));
        poll.vote(1);
        vm.prank(address(2));
        poll.vote(1);
        vm.prank(address(3));
        poll.vote(0);
        assertEq(poll.votes(1), 2);
        assertEq(poll.winner(), 1);
    }

    function test_RevertWhen_VotingTwice() public {
        vm.startPrank(address(1));
        poll.vote(0);
        vm.expectRevert("Already voted");
        poll.vote(2);
        vm.stopPrank();
    }

    function test_RevertWhen_NoSuchOption() public {
        vm.expectRevert("No such option");
        poll.vote(7);
    }
}