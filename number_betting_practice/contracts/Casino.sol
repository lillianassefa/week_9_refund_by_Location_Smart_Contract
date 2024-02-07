pragma solidity ^0.8.0;

contract Casino {
    address public owner;
    uint256 public minimumBet;
    uint256 public totalBet;
    uint256 public numberOfBets;
    uint256 public maxAmountOfBets = 100;
    address[] public players;

    struct Player {
        uint256 amountBet;
        uint256 numberSelected;
    }
    mapping(address => Player) public playerInfo;

    receive() external payable {}

    constructor(uint256 _minimumBet) {
        owner = msg.sender;
        if (_minimumBet != 0) minimumBet = _minimumBet;
    }

    function kill() public {
        if (msg.sender == owner) selfdestruct(payable(owner));
    }

    function checkPlayerExists(address player) public view returns (bool) {
        for (uint256 i = 0; i < players.length; i++) {
            if (players[i] == player) return true;
        }
        return false;
    }

    function bet(uint256 numberSelected) public payable {
        require(!checkPlayerExists(msg.sender), "Player already exists");
        require(
            numberSelected >= 1 && numberSelected <= 10,
            "Number Must be between 1 and 10"
        );
        require(msg.value >= minimumBet, "Insufficient bet amount");

        playerInfo[msg.sender] = Player(msg.value, numberSelected);
        numberOfBets++;
        players.push(msg.sender);
        totalBet += msg.value;
        if (numberOfBets >= maxAmountOfBets) generateNumberWinner();
    }

    function generateNumberWinner() public {
        uint256 numberGenerated = (block.number % 10) + 1;
        distributePrizes(numberGenerated);
    }

    function distributePrizes(uint256 numberWinner) public {
        address[] memory winners = new address[](maxAmountOfBets);
        uint256 count = 0;
        for (uint256 i = 0; i < players.length; i++) {
            address playerAddress = players[i];
            if (playerInfo[playerAddress].numberSelected == numberWinner) {
                winners[count] = playerAddress;
                count++;
            }
            delete playerInfo[playerAddress];
        }
        players = new address[](0);
        uint256 winnerEtherAmount = totalBet / count;
        for (uint256 j = 0; j < count; j++) {
            if (winners[j] != address(0)) {
                payable(winners[j]).transfer(winnerEtherAmount);
            }
        }
        totalBet = 0;
        numberOfBets = 0;
    }
}
