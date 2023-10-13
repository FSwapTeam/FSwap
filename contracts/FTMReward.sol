pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FOTOM is ERC20, Ownable {
    mapping (address => bool) isMinter;
    constructor() ERC20("FOTOM", "FMT") {
        isMinter[msg.sender] = true;
    }
    function setMinter(address _minter,bool state)public onlyOwner{
        isMinter[_minter]= state;
    }
    function mint(address to, uint256 amount) public {
        if(isMinter[msg.sender])
            _mint(to, amount);
        else{
            require(false,'msg sender is not minter');
        }
    }
}