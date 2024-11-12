// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import "./CounterStorage.sol";

contract CounterInternal {
    event NewValue(uint256 value);

    function _setNumber(uint256 newNumber) internal {
        emit NewValue(newNumber);
    }

    function _getNumber() internal view returns (uint256 number) {
        return CounterStorage.layout().number;
    }
}
