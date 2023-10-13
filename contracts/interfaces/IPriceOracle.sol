
pragma solidity >=0.5.17;

interface IPriceOracle {
    function getPrice(address token) external  view returns(uint);
    function SetFeed(address token, address feed) external;
}