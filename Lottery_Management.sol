pragma solidity >= 0.5.0 < 0.9.0;

contract Lottery
{
    address public manager;
    
    // as we will share perticular amount of either of winning Participant will make the address as payable
    address payable[] public participants;

    constructor()
    {
        //Global variable msg.sender will add contract address to the manager and make it MAiN
        manager= msg.sender;
    }
    
    receive() external payable
    {
        // REQUIRE STATEMENT IS used as a IF ELSE > for the payment of Ether from PARTICIPANTS
        require (msg.value==1 ether);

        // participants will send the ether to the contract
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint)
    {
        //REQUIRE statement is used for GET BALANCE FOR THE > MANAGER ONLY  
        require (msg.sender== manager);
        return address(this).balance;
    }
    
    // MAKING SOME RANDOM VALUES THROUGH KECCAK256 
    // NOTE DON'T USE THIS ON REAL CONTRACT AS THIS IS VERY RISKY FUNCTION TO USE 
    function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    // SELECT WINNER Randomly through Function
    function SelectWinner() public 
    {
        require (msg.sender == manager);
        require (participants.length >=3);
        uint r = random();
        uint index = r % participants.length; // returns remainder to get the index 

        address  payable Winner;
        Winner = participants[index];
        Winner.transfer(getBalance());  // AMOUNT WILL TRANSER FROM THIS ACC. to PARTICI acc.
 
        // FOR NEW ROUND ALL PARTICIPANTS ADDRESS WILL BE REMOVED 
        participants= new address payable[](0);

    }

}
