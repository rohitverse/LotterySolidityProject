// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery{
    address public manager;
    address payable[] public participants;

    constructor(){
        manager=msg.sender;
    }

    receive() external payable{
        require(msg.value==1 ether);
        participants.push(payable (msg.sender));
    }

    function getBalance() public view returns (uint){
        require(manager==msg.sender);
        return address(this).balance;
    }

    function random() public view returns(uint){
        require(manager==msg.sender);
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    function selectWinner() public
     //view returns(address)
    {
        require(msg.sender==manager);
        require(participants.length>=3);

        uint r=random();
        address payable winner;
        uint index=r%participants.length;
        winner=participants[index];
       // return winner;
        winner.transfer(getBalance());
        participants=new address payable[](0); 
    }
}