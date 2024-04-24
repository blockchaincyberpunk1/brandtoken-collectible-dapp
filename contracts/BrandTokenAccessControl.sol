// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title AccessControl for BrandToken Collectibles
 * @dev Extends OpenZeppelin's AccessControl contract to manage roles and permissions specific to BrandToken Collectibles dApp.
 */
contract BrandTokenAccessControl is AccessControl {
    // Define role identifiers using public constant variables
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant BRAND_OWNER_ROLE = keccak256("BRAND_OWNER_ROLE");
    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");

    /**
     * @dev Sets up the default roles and grants the deployer the default admin role.
     */
    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender); // Deployer is the default admin
        _setRoleAdmin(BRAND_OWNER_ROLE, ADMIN_ROLE); // Only ADMIN can manage BRAND_OWNER_ROLE
        _setRoleAdmin(USER_ROLE, BRAND_OWNER_ROLE); // BRAND_OWNER can manage USER_ROLE
    }

    /**
     * @notice Grants admin role to an account.
     * @dev Grants ADMIN_ROLE to `account`. Only callable by an account with DEFAULT_ADMIN_ROLE.
     * @param account The address of the account to be granted ADMIN_ROLE.
     */
    function grantAdminRole(address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(ADMIN_ROLE, account);
    }

    /**
     * @notice Grants brand owner role to an account.
     * @dev Grants BRAND_OWNER_ROLE to `account`. Only callable by an account with ADMIN_ROLE.
     * @param account The address of the account to be granted BRAND_OWNER_ROLE.
     */
    function grantBrandOwnerRole(address account) public onlyRole(ADMIN_ROLE) {
        grantRole(BRAND_OWNER_ROLE, account);
    }

    /**
     * @notice Grants user role to an account.
     * @dev Grants USER_ROLE to `account`. Only callable by an account with BRAND_OWNER_ROLE.
     * @param account The address of the account to be granted USER_ROLE.
     */
    function grantUserRole(address account) public onlyRole(BRAND_OWNER_ROLE) {
        grantRole(USER_ROLE, account);
    }

    // Additional functions to revoke roles or check permissions can be implemented following the same pattern.
}
