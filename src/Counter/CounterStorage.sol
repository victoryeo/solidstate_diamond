// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

library CounterStorage {
    struct Layout {
        uint256 number;
    }

    bytes32 internal constant STORAGE_SLOT = keccak256("solidstate.contracts.storage.CounterStorage");

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
