// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Counters.sol";

/**
 * @title BrandToken Contract for Luxury Brand Collectibles
 * @dev Extends ERC721 Non-Fungible Token Standard basic implementation with ownership and access control
 */
contract BrandToken is ERC721, Ownable, AccessControl {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    // Token name: BrandToken
    // Token symbol: BT
    constructor() ERC721("BrandToken", "BT") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender); // Assign the deployer as the default admin
        _setupRole(MINTER_ROLE, msg.sender); // Assign the deployer as the first minter
    }

    /**
     * @dev Grants MINTER_ROLE to a new account. Only callable by accounts with admin role.
     * @param to The account to be granted the MINTER_ROLE.
     */
    function grantMinterRole(address to) public onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(MINTER_ROLE, to);
    }

    /**
     * @dev Revokes MINTER_ROLE from an account. Only callable by accounts with admin role.
     * @param from The account to have the MINTER_ROLE revoked.
     */
    function revokeMinterRole(address from) public onlyRole(DEFAULT_ADMIN_ROLE) {
        revokeRole(MINTER_ROLE, from);
    }

    /**
     * @dev Safe mint function to create a new NFT. Only callable by accounts with MINTER_ROLE.
     * @param to The recipient of the NFT.
     * @param uri The metadata URI of the token.
     */
    function safeMint(address to, string memory uri) public onlyRole(MINTER_ROLE) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri); // Assumes _setTokenURI is implemented or use ERC721URIStorage
    }

    /**
     * @dev Override _baseURI to set the base URI for all tokens.
     */
    function _baseURI() internal pure override returns (string memory) {
        return "https://your-ipfs-or-api-base-uri/";
    }

    /**
     * @dev Override supportsInterface to declare support for AccessControl interface.
     * @param interfaceId The interface identifier, as specified in ERC165.
     */
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
