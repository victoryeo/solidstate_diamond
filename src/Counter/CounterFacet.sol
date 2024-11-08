// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "./CounterStorage.sol";
import "./CounterInternal.sol";

contract CounterFacet is CounterInternal {
    constructor (uint256 value) {
        CounterStorage.layout().number = value;
    }

    function initialize (uint256 value) public {
        CounterStorage.layout().number = value;
    }

    function setNumber(uint256 newNumber) public {
        CounterStorage.layout().number = newNumber;
        _setNumber(newNumber);
    }

    function increment() public {
        CounterStorage.layout().number++;
    }

    function getNumber() public view returns (uint256 number) {
      return _getNumber();
    }
}
