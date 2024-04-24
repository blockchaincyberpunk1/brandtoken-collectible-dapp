// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title RoyaltyManagement
 * @dev Implements EIP-2981 royalty standard for royalty management on secondary sales.
 */
contract RoyaltyManagement is ERC721, IERC2981, Ownable {
    // Mapping from tokenID to royalty information
    mapping(uint256 => RoyaltyInfo) private _royalties;

    struct RoyaltyInfo {
        address recipient;
        uint256 amount;
    }

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    /**
     * @dev Sets royalty information for a specific token.
     * @param tokenId The token ID for which to set the royalty information.
     * @param recipient The address of the recipient for the royalties.
     * @param amount The royalty fee percentage (using 2 decimal places - 10000 = 100%).
     */
    function setTokenRoyalty(uint256 tokenId, address recipient, uint256 amount) public onlyOwner {
        require(amount <= 10000, "Royalty fee will exceed sale price");
        _royalties[tokenId] = RoyaltyInfo(recipient, amount);
    }

    /**
     * @notice Called with the sale price to determine how much royalty is owed and to whom.
     * @param tokenId The tokenId of the NFT
     * @param salePrice The sale price of the NFT
     * @return receiver The recipient of the royalties
     * @return royaltyAmount The amount of royalties to be paid
     */
    function royaltyInfo(uint256 tokenId, uint256 salePrice) external view override returns (address receiver, uint256 royaltyAmount) {
        RoyaltyInfo memory royalty = _royalties[tokenId];
        royaltyAmount = (salePrice * royalty.amount) / 10000;
        return (royalty.recipient, royaltyAmount);
    }

    // You can add more functions here as needed, following the ERC721 and EIP-2981 standards.
}
