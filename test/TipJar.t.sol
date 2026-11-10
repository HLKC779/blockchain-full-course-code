// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {TipJar} from "../src/TipJar.sol";

contract TipJarTest is Test {
    TipJar jar;
    address owner = address(0xA11CE);
    address fan = address(0xFA);

    function setUp() public {
        vm.prank(owner);
        jar = new TipJar();
        vm.deal(fan, 10 ether);
    }

    function test_TipIsStored() public {
        vm.prank(fan);
        jar.tip{value: 1 ether}("Great course!");
        assertEq(jar.tipCount(), 1);
        TipJar.Tip[] memory all = jar.getTips();
        assertEq(all[0].from, fan);
        assertEq(all[0].amount, 1 ether);
        assertEq(all[0].message, "Great course!");
        assertEq(address(jar).balance, 1 ether);
    }

    function test_RevertWhen_TipIsZero() public {
        vm.prank(fan);
        vm.expectRevert("Tip must be more than zero");
        jar.tip("free");
    }

    function test_OnlyOwnerCanWithdraw() public {
        vm.prank(fan);
        jar.tip{value: 2 ether}("thanks");

        vm.prank(fan);
        vm.expectRevert("Only the owner can withdraw");
        jar.withdraw();

        vm.prank(owner);
        jar.withdraw();
        assertEq(owner.balance, 2 ether);
        assertEq(address(jar).balance, 0);
    }
}