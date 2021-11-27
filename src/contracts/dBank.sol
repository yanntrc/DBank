// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {
    //assign Token contract to variable
    Token private token;

    //add mappings
    mapping(address => uint256) public etherBalanceOf;
    mapping(address => uint256) public depositStart;
    mapping(address => bool) public isDeposited;

    event Deposit(address indexed user, uint256 etherAmount, uint256 timeStart);
    event Withdraw(
        address indexed user,
        uint256 etherAmount,
        uint256 despositTime,
        uint256 interest
    );

    //pass as constructor argument deployed Token contract
    constructor(Token _token) public {
        token = _token;
    }

    function deposit() public payable {
        require(isDeposited[msg.sender] == false);
        //check if msg.value is >= than 0.01 ETH
        require(msg.value >= 1e16);
        //set msg.sender deposit status to true
        //emit Deposit event
        emit Deposit(msg.sender, msg.value, block.timestamp);
    }

    function withdraw() public {
        require(isDeposited[msg.sender] == true, "Error, no previous deposit");
        uint256 userBalance = etherBalanceOf[msg.sender];

        uint256 depositTime = block.timestamp - depositStart[msg.sender];
        uint256 interestPerSecond = 31668017 *
            (etherBalanceOf[msg.sender] / 1e16);
        uint256 interest = interestPerSecond * depositTime;

        msg.sender.transfer(userBalance);
        token.mint(msg.sender, interest);

        depositStart[msg.sender] = 0;
        etherBalanceOf[msg.sender] = 0;
        isDeposited[msg.sender] = false;
        emit Withdraw(msg.sender, userBalance, depositTime, interest);
    }

    function borrow() public payable {
        //check if collateral is >= than 0.01 ETH
        //check if user doesn't have active loan
        //add msg.value to ether collateral
        //calc tokens amount to mint, 50% of msg.value
        //mint&send tokens to user
        //activate borrower's loan status
        //emit event
    }

    function payOff() public {
        //check if loan is active
        //transfer tokens from user back to the contract
        //calc fee
        //send user's collateral minus fee
        //reset borrower's data
        //emit event
    }
}
