// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// NOTE that this contract is abstract, it CANNOT be deployed to the blockchain
// there is no sense in deploying this contract, it's just a prefab
abstract contract WithMembers {
    error NotAMember(address stranger);

    mapping(address => bool) internal isMember;

    constructor(address[] memory _members) {
        isMember[msg.sender] = true;
        for (uint i = 0; i < _members.length; i++) {
            isMember[_members[i]] = true;
        }
    }

    modifier onlyMember() {
        if (isMember[msg.sender] == false) {
            revert NotAMember(msg.sender);
        }
        _;
    }
}

contract Voting is WithMembers {
    struct Proposal {
        address target;
        bytes data;
        uint yesCount;
        uint noCount;
        bool executed;
    }

    enum VoteResult {
        NONE,
        YES,
        NO
    }

    event ProposalCreated(uint256 proprosalId);
    event VoteCast(uint256 proposalId, address voter);
    
    error ProposalExecutionFailed(uint256 propId);
    
    uint256 internal immutable yesThreshold;
    Proposal[] internal proposals;
    mapping(uint256 => mapping(address => VoteResult)) internal votes;

    constructor(uint256 _yesThreshold, address[] memory _members) WithMembers(_members) {
        yesThreshold = _yesThreshold;
    }

    function newProposal(address target, bytes calldata data) external onlyMember {
        Proposal memory p = Proposal({
            target: target,
            data: data,
            yesCount: 0,
            noCount: 0,
            executed: false
        });
        proposals.push(p);
        emit ProposalCreated(proposals.length - 1);
    }

    function castVote(uint256 proposalId, bool yes) external onlyMember {
        VoteResult voteResult = votes[proposalId][msg.sender];
        VoteResult newVoteResult = yes ? VoteResult.YES : VoteResult.NO;
        if (voteResult == newVoteResult) {
            emit VoteCast(proposalId, msg.sender);
            return;
        }

        Proposal storage p = proposals[proposalId];
        if (yes) {
            p.yesCount++;
            if (voteResult == VoteResult.NO) {
                p.noCount--;
            }
            if (p.yesCount == yesThreshold && !p.executed) {
                executeProposal(proposalId, p);
            }
        } else {
            p.noCount++;
            if (voteResult == VoteResult.YES) {
                p.yesCount--;
            }
        }
        
        votes[proposalId][msg.sender] = newVoteResult;
        emit VoteCast(proposalId, msg.sender);
    }

    function executeProposal(uint256 proposalId, Proposal storage prop) internal {
        (bool success,) = prop.target.call(prop.data);
        if (!success) {
            revert ProposalExecutionFailed(proposalId);
        }
        prop.executed = true;
    }
}
