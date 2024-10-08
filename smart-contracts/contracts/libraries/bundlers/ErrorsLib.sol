// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

/// @title ErrorsLib
/// @author Morpho Labs
/// @notice Library exposing error messages.
library ErrorsLib {
    /// @dev Thrown when passing the zero address.
    string internal constant ZERO_ADDRESS = "zero address";

    /// @dev Thrown when a call is attempted while the bundler is not in an initiated execution context.
    string internal constant UNINITIATED = "uninitiated";

    /// @dev Thrown when a multicall is attempted while the bundler in an initiated execution context.
    string internal constant ALREADY_INITIATED = "already initiated";

    /// @dev Thrown when a call is attempted from an unauthorized sender.
    string internal constant UNAUTHORIZED_SENDER = "unauthorized sender";

    /// @dev Thrown when a call is attempted with the bundler address as input.
    string internal constant BUNDLER_ADDRESS = "bundler address";

    /// @dev Thrown when a call is attempted with a zero amount as input.
    string internal constant ZERO_AMOUNT = "zero amount";

    /// @dev Thrown when a call is attempted with a zero shares as input.
    string internal constant ZERO_SHARES = "zero shares";

    /// @dev Thrown when a call reverts with empty `returnData`.
    string internal constant CALL_FAILED = "call failed";

    /// @dev Thrown when the given owner is unexpected.
    string internal constant UNEXPECTED_OWNER = "unexpected owner";

    /// @dev Thrown when an action ends up minting/burning more shares than a given slippage.
    string internal constant SLIPPAGE_EXCEEDED = "slippage exceeded";

    /// @dev Thrown when a call to depositFor fails.
    string internal constant DEPOSIT_FAILED = "deposit failed";

    /// @dev Thrown when a call to withdrawTo fails.
    string internal constant WITHDRAW_FAILED = "withdraw failed";

    /* MIGRATION BUNDLERS */

    /// @dev Thrown when repaying a CompoundV2 debt returns an error code.
    string internal constant REPAY_ERROR = "repay error";

    /// @dev Thrown when redeeming CompoundV2 cTokens returns an error code.
    string internal constant REDEEM_ERROR = "redeem error";
}
