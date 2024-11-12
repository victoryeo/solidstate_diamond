// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {SolidStateDiamond} from "solidstate-solidity/proxy/diamond/SolidStateDiamond.sol";

/**
 * @title  USBC
 * @notice USBC Proxy Cobtract
 * @dev    This is a Diamond Contract following EIP-2535.
 *         To view its ABI and interact with functions,
 *         use an EIP-2535 compatible explorer.
 */
contract Counter is SolidStateDiamond {}
