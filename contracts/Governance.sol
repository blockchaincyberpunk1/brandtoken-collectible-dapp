// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Governance Contract
 * @dev Implements a basic governance system allowing token holders to vote on proposals.
 */
contract Governance is ReentrancyGuard, Ownable {
    IERC20 public votingToken;

    struct Proposal {
        string description;
        bytes callData;
        address recipient;
        uint256 voteCount;
        bool executed;
    }

    Proposal[] public proposals;

    mapping(address => uint256) public lastVotedOnProposal;

    event ProposalCreated(uint256 indexed proposalId, string description);
    event VoteCast(address indexed voter, uint256 indexed proposalId, uint256 votes);
    event ProposalExecuted(uint256 indexed proposalId);

    /**
     * @param _votingToken The token used for voting rights.
     */
    constructor(IERC20 _votingToken) {
        require(address(_votingToken) != address(0), "Governance: Voting token is the zero address");
        votingToken = _votingToken;
    }

    /**
     * @notice Create a new proposal.
     * @param description The description of the proposal.
     * @param callData The call data to be executed.
     * @param recipient The recipient of the proposal execution.
     */
    function createProposal(string memory description, bytes memory callData, address recipient) public onlyOwner {
        proposals.push(Proposal({
            description: description,
            callData: callData,
            recipient: recipient,
            voteCount: 0,
            executed: false
        }));

        emit ProposalCreated(proposals.length - 1, description);
    }

    /**
     * @notice Vote on a proposal.
     * @param proposalId The ID of the proposal to vote on.
     * @param votes The number of votes to cast.
     */
    function vote(uint256 proposalId, uint256 votes) external nonReentrant {
        require(proposalId < proposals.length, "Governance: Proposal does not exist");
        require(votes > 0, "Governance: Votes must be greater than 0");
        require(lastVotedOnProposal[msg.sender] < proposalId, "Governance: Already voted on this proposal");

        Proposal storage proposal = proposals[proposalId];

        votingToken.transferFrom(msg.sender, address(this), votes);
        proposal.voteCount += votes;

        lastVotedOnProposal[msg.sender] = proposalId;

        emit VoteCast(msg.sender, proposalId, votes);
    }

    /**
     * @notice Execute a proposal that has met the criteria.
     * @param proposalId The ID of the proposal to execute.
     */
    function executeProposal(uint256 proposalId) external nonReentrant {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Governance: Proposal already executed");
        require(proposal.voteCount >= 10000 * (10 ** 18), "Governance: Not enough votes");

        (bool success,) = proposal.recipient.call(proposal.callData);
        require(success, "Governance: Proposal execution failed");

        proposal.executed = true;

        emit ProposalExecuted(proposalId);
    }
}
