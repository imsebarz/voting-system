// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    struct Proposal {
        string name;
        uint256 voteCount;
    }

    address public admin;
    Proposal[] public proposals;
    mapping(address => bool) public whitelist;
    mapping(address => bool) public hasVoted;
    uint256 public votingDeadline;

    constructor() {
        admin = msg.sender;
        votingDeadline = block.timestamp + 3 days;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this action");
        _;
    }

    modifier onlyWhitelisted() {
        require(whitelist[msg.sender], "You are not whitelisted.");
        _;
    }

    modifier withinVotingPeriod() {
        require(block.timestamp <= votingDeadline, "You cannot vote anymore, votes can only be submitted within the first 3 days from the deploy");
        _;
    }

    function addProposal(string memory proposalName) public onlyAdmin {
        proposals.push(Proposal({
            name: proposalName,
            voteCount: 0
        }));
    }

    function addToWhitelist(address voter) public onlyAdmin {
        whitelist[voter] = true;
    }

    function vote(uint256 proposalIndex) public onlyWhitelisted withinVotingPeriod {
        require(!hasVoted[msg.sender], "You have already voted");
        proposals[proposalIndex].voteCount += 1;
        hasVoted[msg.sender] = true;
    }

    function getProposal(uint256 index) public view returns (string memory, uint256) {
        Proposal memory proposal = proposals[index];
        return (proposal.name, proposal.voteCount);
    }

    function getProposalsCount() public view returns (uint256) {
        return proposals.length;
    }
}
