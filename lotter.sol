// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor() {
        manager = msg.sender;
    }

    function participate() public payable {
        require(msg.value == 1 ether, "You have to pay 1 ether to participate");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function random() public view returns (uint256) {
        return
            uint256(
                keccak256(
                   abi.encodePacked(block.prevrandao, block.timestamp, players)

                )
            );
    }

    function pickWinner() public {
        require(msg.sender == manager, "Only manager can pick the winner");
        uint256 index = random() % players.length;
        winner = players[index];
        players = new address payable[](0);
        payable(winner).transfer(address(this).balance);
    }
}
