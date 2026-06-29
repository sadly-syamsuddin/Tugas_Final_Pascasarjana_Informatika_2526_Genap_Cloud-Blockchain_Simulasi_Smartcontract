// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SampahPay {

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    enum Status {
        Created,
        Confirmed,
        Rewarded
    }

    struct WasteTransaction {
        uint id;
        address user;
        string wasteType;
        uint weight;
        uint reward;
        Status status;
    }

    uint public transactionCount;

    mapping(uint => WasteTransaction) public transactions;

    event TransactionCreated(
        uint id,
        address indexed user,
        string wasteType
    );

    event WeightConfirmed(
        uint id,
        uint weight,
        uint reward
    );

    event RewardReleased(
        uint id,
        uint reward
    );

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    // User membuat transaksi setor sampah
    function createTransaction(
        string memory _wasteType
    ) public {

        transactionCount++;

        transactions[transactionCount] = WasteTransaction({
            id: transactionCount,
            user: msg.sender,
            wasteType: _wasteType,
            weight: 0,
            reward: 0,
            status: Status.Created
        });

        emit TransactionCreated(
            transactionCount,
            msg.sender,
            _wasteType
        );
    }

    // Admin/Kolektor mengkonfirmasi berat sampah
    function confirmWeight(
        uint _id,
        uint _weight
    ) public onlyAdmin {

        WasteTransaction storage trx = transactions[_id];

        require(
            trx.status == Status.Created,
            "Already confirmed"
        );

        trx.weight = _weight;
        trx.reward = calculateReward(
            trx.wasteType,
            _weight
        );

        trx.status = Status.Confirmed;

        emit WeightConfirmed(
            _id,
            _weight,
            trx.reward
        );
    }

    // Perhitungan reward sederhana
    function calculateReward(
        string memory _type,
        uint _weight
    ) internal pure returns(uint){

        bytes32 waste = keccak256(bytes(_type));

        if(waste == keccak256(bytes("Plastic"))){
            return _weight * 2000;
        }

        if(waste == keccak256(bytes("Paper"))){
            return _weight * 1000;
        }

        if(waste == keccak256(bytes("Can"))){
            return _weight * 3000;
        }

        return _weight * 500;
    }

    // Reward diberikan
    function releaseReward(
        uint _id
    ) public onlyAdmin {

        WasteTransaction storage trx = transactions[_id];

        require(
            trx.status == Status.Confirmed,
            "Weight not confirmed"
        );

        trx.status = Status.Rewarded;

        emit RewardReleased(
            _id,
            trx.reward
        );
    }

    // Melihat detail transaksi
    function getTransaction(
        uint _id
    ) public view returns(

        uint,
        address,
        string memory,
        uint,
        uint,
        Status

    ){

        WasteTransaction memory trx = transactions[_id];

        return(
            trx.id,
            trx.user,
            trx.wasteType,
            trx.weight,
            trx.reward,
            trx.status
        );
    }

}