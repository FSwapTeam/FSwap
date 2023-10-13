// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16;


import './interfaces/IFSwapFactory.sol';
import './FSwapPair.sol';

contract FSwapFactory is IFSwapFactory {
    address public feeTo;
    address public admin;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor() public {
        admin = msg.sender;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(msg.sender == admin, 'FSwap: FORBIDDEN');
        require(tokenA != tokenB, 'FSwap: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'FSwap: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'FSwap: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(FSwapPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IFSwapPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == admin, 'FSwap: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setAdmin(address _admin) external {
        require(msg.sender == admin, 'FSwap: FORBIDDEN');
        admin = _admin;
    }
}
