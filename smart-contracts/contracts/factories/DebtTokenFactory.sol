// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {IDebtToken} from "../interfaces/tokens/IDebtToken.sol";
import {IDebtTokenFactory, IERC165} from "../interfaces/factories/IDebtTokenFactory.sol";

/**
 * @title debt token contract factory.
 */
contract DebtTokenFactory is ERC165, AccessControl, IDebtTokenFactory {
    // Address of debt token implementation
    address internal _implementation;

    /**
     * @dev Function that initializes state of smart contract at the moment
     * of deploy.
     * @param implementation address of debt token implementation.
     */
    constructor(address implementation) {
        _setImplementationAddress(implementation);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /// @inheritdoc IDebtTokenFactory
    function getImplementation() external view returns (address) {
        return (_implementation);
    }

    /// @inheritdoc IDebtTokenFactory
    function create(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        address _owner
    ) external returns (address instance) {
        instance = Clones.clone(_implementation);
        IDebtToken(instance).initialize(_name, _symbol, _decimals, _owner);

        emit DebtTokenCreated(msg.sender, instance);
    }

    /// @inheritdoc IERC165
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(AccessControl, ERC165, IERC165)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev Internal function that changes address of debt token implementation
     * and checks if new provided address is contract.
     */
    function _setImplementationAddress(address implementation) internal {
        if (!_checkIfAddressIsValid(implementation))
            revert InvalidImplementationAddress();

        _implementation = implementation;
    }

    /**
     * @dev Internal function that checks if provided address is contract.
     */
    function _checkIfAddressIsValid(address addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return (size != 0);
    }
}
