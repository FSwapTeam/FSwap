pragma solidity =0.5.16;

import '../FSwapERC20.sol';

contract ERC20 is FSwapERC20 {
    constructor(uint _totalSupply) public {
        _mint(msg.sender, _totalSupply);
    }
}
