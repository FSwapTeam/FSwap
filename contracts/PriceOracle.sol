// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./utils/Ownable.sol";
contract PriceOracle is Ownable{
    mapping(address => address) dataFeed;
    constructor(){

    }
    function getPrice(address token) public view returns(uint){
        if(dataFeed[token] == address(0))
            return 0;
        AggregatorV3Interface feed = AggregatorV3Interface( dataFeed[token] );
        uint80 roundId;
        int256 answer;
        uint256 startedAt;
        uint256 updateAt;
        uint80 answeredInRound;
        (roundId,answer ,startedAt , updateAt,answeredInRound )=feed.latestRoundData();
        require(roundId != 0, "Oracle: Bad feed address");
        return uint(answer);
    }
    function SetFeed(address token, address feed) public onlyOwner{
        dataFeed[token]=feed;
    }
    
}