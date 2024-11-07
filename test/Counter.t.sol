// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IERC2535DiamondCutInternal} from "solidstate-solidity/interfaces/IERC2535DiamondCutInternal.sol";
import {CounterFacet} from "../src/Counter/CounterFacet.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;
    CounterFacet public counterFacet;

    function setUp() public {
        counter = new Counter();
        counterFacet = new CounterFacet();
        counterFacet.setNumber(0);
    }

    function test_Increment() public {
        counterFacet.increment();
        assertEq(counterFacet.getNumber() , 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counterFacet.setNumber(x);
        assertEq(counterFacet.getNumber(), x);
    }

    function test_upgrade() public {
        IERC2535DiamondCutInternal.FacetCut[] memory facetCuts = new IERC2535DiamondCutInternal.FacetCut[](1);
        bytes4[] memory selectors = new bytes4[](1);
        uint256 selectorIndex;

        // register a new function
        selectors[selectorIndex++] = CounterFacet.getNumber.selector;

        facetCuts[0] = IERC2535DiamondCutInternal.FacetCut({
            target: address(this),
            action: IERC2535DiamondCutInternal.FacetCutAction.ADD,
            selectors: selectors
        });

        counter.diamondCut(facetCuts, address(0), "");
    }

}
