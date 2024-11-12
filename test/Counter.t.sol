// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IERC2535DiamondCutInternal} from "solidstate-solidity/interfaces/IERC2535DiamondCutInternal.sol";
import {IERC2535DiamondLoupeInternal} from "solidstate-solidity/interfaces/IERC2535DiamondLoupeInternal.sol";
import {CounterFacet} from "../src/Counter/CounterFacet.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;
    CounterFacet public counterFacet;

    function setUp() public {
        counter = new Counter();
        counterFacet = new CounterFacet(100);
    }

    function test_Increment() public {
        counterFacet.increment();
        assertEq(counterFacet.getNumber(), 101);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counterFacet.setNumber(x);
        assertEq(counterFacet.getNumber(), x);
    }

    function test_upgrade_selector() public {
        IERC2535DiamondCutInternal.FacetCut[] memory facetCuts = new IERC2535DiamondCutInternal.FacetCut[](1);
        bytes4[] memory selectors = new bytes4[](2);
        uint256 selectorIndex;

        // register a new function
        selectors[selectorIndex++] = CounterFacet.getNumber.selector;
        // register another new function
        selectors[selectorIndex++] = CounterFacet.setNumber.selector;

        // diamond cut
        facetCuts[0] = IERC2535DiamondCutInternal.FacetCut({
            target: address(counterFacet),
            action: IERC2535DiamondCutInternal.FacetCutAction.ADD,
            selectors: selectors
        });

        // encode function call to send to the contract at _init
        bytes memory thecalldata = abi.encodeWithSelector(CounterFacet.initialize.selector, 100);

        counter.diamondCut(facetCuts, address(counterFacet), thecalldata);

        // Facet(address(diamond)).function(params);
        console.log("Value", CounterFacet(address(counter)).getNumber());

        // get the facets
        IERC2535DiamondLoupeInternal.Facet[] memory facets = counter.facets();

        console.log(facets.length, facets[0].target, facets[1].target);
        console.log(facets[0].selectors.length, facets[1].selectors.length);
        console.logBytes4(facets[1].selectors[0]);
        console.logBytes4(CounterFacet.getNumber.selector);

        // call setNumber at selectors[1]
        (bool ok1, bytes memory res1) =
            address(facets[1].target).call(abi.encodeWithSelector(facets[1].selectors[1], uint256(2)));
        console.logBytes(res1);
        assertEq(ok1, true);

        // call getNumber at selectors[0]
        (bool ok, bytes memory res) = address(facets[1].target).call(abi.encodeWithSelector(facets[1].selectors[0]));
        console.logBytes(res);
        assertEq(ok, true);
    }

    function test_upgrade_casting() public {
        IERC2535DiamondCutInternal.FacetCut[] memory facetCuts = new IERC2535DiamondCutInternal.FacetCut[](1);
        bytes4[] memory selectors = new bytes4[](2);
        uint256 selectorIndex;

        // register a new function
        selectors[selectorIndex++] = CounterFacet.getNumber.selector;
        // register another new function
        selectors[selectorIndex++] = CounterFacet.setNumber.selector;

        // diamond cut
        facetCuts[0] = IERC2535DiamondCutInternal.FacetCut({
            target: address(counterFacet),
            action: IERC2535DiamondCutInternal.FacetCutAction.ADD,
            selectors: selectors
        });

        // encode function call to send to the contract at _init
        bytes memory thecalldata = abi.encodeWithSelector(CounterFacet.initialize.selector, 100);

        counter.diamondCut(facetCuts, address(counterFacet), thecalldata);

        // call Facet(address(diamond)).function(params);
        console.log("Value", CounterFacet(address(counter)).getNumber());

        // call Facet(address(diamond)).function(params);
        CounterFacet(address(counter)).setNumber(10);

        console.log("Value", CounterFacet(address(counter)).getNumber());
        assertEq(CounterFacet(address(counter)).getNumber(), 10);
    }
}
