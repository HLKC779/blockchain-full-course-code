// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {SimpleToken} from "../src/SimpleToken/SimpleToken.sol";

contract SimpleTokenTest is Test {
    SimpleToken token;
    address alice = address(0xA11CE);
    address bob = address(0xB0B);

    function setUp() public {
        vm.prank(alice);
        token = new SimpleToken(1000);
    }

    function test_CreatorGetsSupply() public view {
        assertEq(token.totalSupply(), 1000);
        assertEq(token.balanceOf(alice), 1000);
    }

    function test_Transfer() public {
        vm.prank(alice);
        token.transfer(bob, 250);
        assertEq(token.balanceOf(bob), 250);
        assertEq(token.balanceOf(alice), 750);
    }

    function test_RevertWhen_NotEnoughTokens() public {
        vm.prank(bob);
        vm.expectRevert("Not enough tokens");
        token.transfer(alice, 1);
    }

    function testFuzz_TransferKeepsTotal(uint256 amount) public {
        amount = bound(amount, 0, 1000);
        vm.prank(alice);
        token.transfer(bob, amount);
        assertEq(token.balanceOf(alice) + token.balanceOf(bob), 1000);
    }
}