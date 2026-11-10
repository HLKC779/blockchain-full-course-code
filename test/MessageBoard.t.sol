// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {MessageBoard} from "../src/MessageBoard.sol";

contract MessageBoardTest is Test {
    MessageBoard board;
    address owner = address(this);

    function setUp() public {
        board = new MessageBoard("hello");
    }

    function test_OwnerCanSetMessage() public {
        vm.prank(owner);
        board.setMessage("updated");

        assertEq(board.message(), "updated");
        assertEq(board.updates(), 1);
    }

    function test_RevertWhen_NotOwner() public {
        vm.prank(address(1));
        vm.expectRevert("Only the owner can post");
        board.setMessage("updated");
    }

    function test_RevertWhen_EmptyMessage() public {
        vm.prank(owner);
        vm.expectRevert("Message cannot be empty");
        board.setMessage("");
    }

    function test_RevertWhen_EmptyInitialMessage() public {
        vm.expectRevert("Message cannot be empty");
        new MessageBoard("");
    }
}
