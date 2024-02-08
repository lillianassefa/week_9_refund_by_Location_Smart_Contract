// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract RefundGeolocation {
    uint public avaialableFunds;
    address public company;
    address public device;

    uint public latitude;
    uint public longitude;
    uint public range;

    bool public isWithinZone;

    event ComplianceChecked(address indexed device, bool isWithinZone);
    event RefundProcessed(address indexed device, uint256 amount);

    modifier onlyCreator() {
        require(msg.sender == company, "Only Company can call this function");
        _;
    }

    modifier onlyDevice() {
        require(msg.sender == device, "Only Device caqn call this function");
        _;
    }

    constructor(uint _latitude, uint _longtiude, uint _range) {
        company = msg.sender;
        latitude = _latitude;
        longitude = _longtiude;
        range = _range;
    }

    function sendCoordinates(uint _latitude, uint _longitude) external onlyDevice {
        isWithinZone = isWithinRange(_latitude, _longitude);
        emit ComplianceChecked(device, isWithinZone);

        if(isWithinZone){
            emit RefundProcessed(device, 100);
        }
    }
    function isWithinRange(uint _latitude, uint _longitutde) internal view returns (bool) {
        uint latDiff = latitude > _latitude ? latitude - _latitude : _latitude -latitude;
        uint longDiff = longitude > _longitutde ? longitude -_longitutde : _longitutde - longitude;
        return (latDiff <= range && longDiff <= range);
    }
}
