# BrandToken Collectible dApp Smart Contracts

## Overview
This repository contains smart contracts for the BrandToken Collectible dApp, which aims to provide a platform for luxury brand collectibles. Below is a brief description of each smart contract included in this project.

### BrandToken.sol
- **Purpose**: Implements an ERC721 Non-Fungible Token (NFT) contract for luxury brand collectibles.
- **Features**:
  - Ownership and access control mechanisms.
  - Role-based permission management for minting new tokens.
  - Safe minting function to create new NFTs.
- **Status**: Under development.

### BrandTokenAccessControl.sol
- **Purpose**: Extends OpenZeppelin's AccessControl contract to manage roles and permissions specific to the BrandToken Collectibles dApp.
- **Features**:
  - Defines roles such as admin, brand owner, and user.
  - Grants and revokes role-based permissions.
- **Status**: Under development.

### BrandTokenFactory.sol
- **Purpose**: Factory contract to dynamically create and manage BrandToken contracts for luxury brands.
- **Features**:
  - Allows creation of new BrandToken contracts.
  - Tracks created BrandToken contracts.
  - Role-based permission for creating new contracts.
- **Status**: Under development.

### Counters.sol
- **Purpose**: Provides a counter that can be incremented or decremented by one, useful for tracking IDs and contract interactions.
- **Status**: Under development.

### Governance.sol
- **Purpose**: Implements a basic governance system allowing token holders to vote on proposals.
- **Features**:
  - Proposal creation and voting functionality.
  - Proposal execution based on vote count.
- **Status**: Under development.

### Marketplace.sol
- **Purpose**: Implements a marketplace for listing, selling, and auctioning BrandToken NFTs.
- **Features**:
  - Listing and buying NFTs functionality.
  - Commission-based revenue model.
- **Status**: Under development.

### RoyaltyManagement.sol
- **Purpose**: Implements EIP-2981 royalty standard for royalty management on secondary sales.
- **Features**:
  - Setting royalty information for specific tokens.
  - Calculation of royalties based on sale price.
- **Status**: Under development.

### WalletInteraction.sol
- **Purpose**: Demonstrates a contract structure for facilitating interactions initiated by external wallets.
- **Features**:
  - Simulated wallet interaction function.
- **Status**: Under development.
