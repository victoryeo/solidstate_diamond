// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {CounterFacet} from "../src/Counter/CounterFacet.sol";

contract CounterTest is Test {
    CounterFacet public counter;

    function setUp() public {
        counter = new CounterFacet();
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.getNumber() , 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.getNumber(), x);
    }
}
