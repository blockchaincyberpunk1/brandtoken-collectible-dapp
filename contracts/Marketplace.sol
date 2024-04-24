// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Marketplace for BrandToken NFTs
 * @dev Implements a marketplace for listing, selling, and auctioning BrandToken NFTs.
 */
contract Marketplace is ReentrancyGuard, Ownable {
    struct Listing {
        address seller;
        address tokenAddress;
        uint256 tokenId;
        uint256 price;
        bool isActive;
    }

    // Listings mapped by a unique ID
    mapping(uint256 => Listing) public listings;
    uint256 public listingCount;

    // Commission rate as a percentage of sales
    uint256 public commissionRate = 5; // 5%

    // Event declarations
    event Listed(uint256 indexed listingId, address indexed seller, address tokenAddress, uint256 tokenId, uint256 price);
    event Sale(uint256 indexed listingId, address indexed buyer, uint256 price);
    event CommissionChanged(uint256 newRate);

    constructor() {}

    /**
     * @notice List an NFT on the marketplace.
     * @param tokenAddress The address of the NFT contract.
     * @param tokenId The ID of the NFT.
     * @param price The listing price in Wei.
     */
    function listNFT(address tokenAddress, uint256 tokenId, uint256 price) external nonReentrant {
        require(price > 0, "Price must be greater than zero");

        IERC721 token = IERC721(tokenAddress);
        require(token.ownerOf(tokenId) == msg.sender, "Caller must own the token");
        require(token.isApprovedForAll(msg.sender, address(this)), "Contract must be approved");

        listingCount += 1;
        listings[listingCount] = Listing(msg.sender, tokenAddress, tokenId, price, true);

        emit Listed(listingCount, msg.sender, tokenAddress, tokenId, price);
    }

    /**
     * @notice Buy an NFT listed on the marketplace.
     * @param listingId The ID of the listing.
     */
    function buyNFT(uint256 listingId) external payable nonReentrant {
        Listing storage listing = listings[listingId];
        require(listing.isActive, "Listing is not active");
        require(msg.value >= listing.price, "Insufficient payment");

        // Calculate commission and seller proceeds
        uint256 commission = (msg.value * commissionRate) / 100;
        uint256 sellerProceeds = msg.value - commission;

        // Transfer commission to the owner of the contract
        payable(owner()).transfer(commission);

        // Transfer proceeds to the seller
        payable(listing.seller).transfer(sellerProceeds);

        // Transfer NFT to buyer
        IERC721(listing.tokenAddress).safeTransferFrom(listing.seller, msg.sender, listing.tokenId);

        listing.isActive = false;

        emit Sale(listingId, msg.sender, msg.value);
    }

    /**
     * @notice Change the commission rate for the marketplace.
     * @param newRate The new commission rate as a percentage.
     * @dev This function can only be called by the contract owner.
     */
    function changeCommissionRate(uint256 newRate) external onlyOwner {
        require(newRate <= 100, "Commission rate cannot exceed 100%");
        commissionRate = newRate;
        emit CommissionChanged(newRate);
    }

    // Additional marketplace functions like updateListing, removeListing, etc., can be added here.
}
