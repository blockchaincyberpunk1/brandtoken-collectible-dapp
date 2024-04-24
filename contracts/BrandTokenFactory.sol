// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./BrandToken.sol"; // Assume this is the path to your BrandToken contract

/**
 * @title BrandTokenFactory
 * @dev Factory contract to create and manage BrandToken contracts for luxury brands.
 * This contract allows for the dynamic creation of BrandToken contracts and tracks them.
 */
contract BrandTokenFactory is Ownable, AccessControl {
    bytes32 public constant BRAND_CREATOR_ROLE = keccak256("BRAND_CREATOR_ROLE");
    // Track all created BrandToken contracts
    address[] public brandTokens;

    event BrandTokenCreated(address indexed brandTokenAddress, address indexed creator);

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender); // Admin role to manage other roles
        _setupRole(BRAND_CREATOR_ROLE, msg.sender); // Initially, only the deployer can create brand tokens
    }

    /**
     * @notice Creates a new BrandToken contract for a luxury brand.
     * @param name The name of the BrandToken.
     * @param symbol The symbol of the BrandToken.
     * @dev Only accounts with the BRAND_CREATOR_ROLE can call this function.
     */
    function createBrandToken(string memory name, string memory symbol) public onlyRole(BRAND_CREATOR_ROLE) {
        BrandToken brandToken = new BrandToken(name, symbol);
        brandTokens.push(address(brandToken));
        emit BrandTokenCreated(address(brandToken), msg.sender);
    }

    /**
     * @notice Grants the BRAND_CREATOR_ROLE to an account, allowing it to create BrandToken contracts.
     * @param account The account to grant the role to.
     * @dev Only the owner or accounts with the DEFAULT_ADMIN_ROLE can call this function.
     */
    function grantBrandCreatorRole(address account) public onlyOwner {
        grantRole(BRAND_CREATOR_ROLE, account);
    }

    /**
     * @notice Revokes the BRAND_CREATOR_ROLE from an account.
     * @param account The account to revoke the role from.
     * @dev Only the owner or accounts with the DEFAULT_ADMIN_ROLE can call this function.
     */
    function revokeBrandCreatorRole(address account) public onlyOwner {
        revokeRole(BRAND_CREATOR_ROLE, account);
    }

    /**
     * @notice Returns the number of BrandToken contracts created by this factory.
     * @return count The number of created BrandToken contracts.
     */
    function getBrandTokenCount() public view returns (uint256 count) {
        return brandTokens.length;
    }

    // Additional functions to manage and interact with BrandToken contracts can be added here.
}
