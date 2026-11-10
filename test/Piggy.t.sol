// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {Piggy} from "../src/Piggy.sol";

contract PiggyTest is Test {
    Piggy piggy;
    address owner = address(0xA11CE);
    address stranger = address(0xBAD);

    function setUp() public {
        vm.deal(owner, 5 ether);
        vm.prank(owner);
        piggy = new Piggy{value: 5 ether}();
    }

    function test_OwnerCanWithdraw() public {
        vm.prank(owner);
        piggy.withdraw();
        assertEq(owner.balance, 5 ether);
    }

    function test_RevertWhen_StrangerWithdraws() public {
        vm.prank(stranger);
        vm.expectRevert("Only the owner");
        piggy.withdraw();
    }
}