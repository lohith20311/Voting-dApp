// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

struct candidate{
    uint id;
    string name;
    uint voteCount;  //0xd9145CCE52D386f254917e481eB44e9943F39138
}

contract VotingSystem{
    mapping (uint => candidate) public candidates;
    mapping ( address=> bool) public voters;

    uint public candidatesCount = 0;

    uint public startTime;
    uint public endTime;

    event votedEvent(uint indexed _candidateID);

    constructor(uint _durationInMinutes){
        startTime  = block.timestamp;
        endTime  = (_durationInMinutes * 1 minutes);

        addCandidate ("bob");
        addCandidate("alice");
    }

    function  addCandidate(string memory _name) private {
        candidatesCount++;
        candidates[candidatesCount] = candidate(candidatesCount, _name, 0);
        
    }
    function  vote(uint _candidateID) public {
        require(block.timestamp >= startTime && block.timestamp <= endTime,"voting is not allow at this time");
        require (!voters[msg.sender],"you have already voted");
        require(_candidateID >0 && _candidateID <= candidatesCount,"you have entered invalid ID");

        voters[msg.sender] = true;
        candidates[_candidateID].voteCount++;

        emit votedEvent(_candidateID);
    }
    function getAllCandidate()public view returns (candidate[] memory) { 
        candidate[] memory candidateArray  = new candidate[](candidatesCount);
        for (uint i = 1; i <=candidatesCount; i++){
             candidateArray[i-1] = candidates[i];
        }
        return candidateArray;
    }
    function getwinner() public view returns (string memory) {
    require(block.timestamp > endTime, "voting is still ongoing, result will be available after voting end");
        
    uint maxVotes = 0;
    uint leadingCandidateID = 0;
    
    for(uint i =1; i<= candidatesCount; i++){
        if(candidates[i].voteCount > maxVotes){
            maxVotes = candidates[i].voteCount;
            leadingCandidateID = i;
        }
       
    }

    if (leadingCandidateID == 0){
        return "no votes cast yet";
    }
     return candidates[leadingCandidateID].name;
    }
    }
