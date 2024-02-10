// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract RefundGeolocation {
    uint public avaialableFunds;
    address public company;
    struct Device {
        address deviceAddress;
        uint timeLimit;
        uint gpsReadingRange;
        bool compliance;
    }

    uint public latitude;
    uint public longitude;
    uint public range;

    bool public isWithinZone;

    event ComplianceChecked(address indexed device, bool isWithinZone);
    event RefundProcessed(address indexed device, uint256 amount);
    event DeviceAdded(
        address indexed deviceAddress,
        uint timeLimit,
        uint gpsReadingRange
    );
    event CoordinatesSent(
        address indexed deviceAddress,
        uint latitude,
        uint longitude,
        bool isWithinZone
    );

    modifier onlyCompany() {
        require(msg.sender == company, "Only Company can call this function");
        _;
    }

    modifier onlyDevice() {
        require(msg.sender == device, "Only Device can call this function");
        _;
    }

    constructor(uint _latitude, uint _longtiude, uint _range) {
        company = msg.sender;
        latitude = _latitude;
        longitude = _longtiude;
        range = _range;
    }

    function addDevice(
        address _deviceAddress,
        uint _timeLimit,
        uint _gpsReadingRange
    ) external onlyCompany {
        devices[_deviceAddress] = Device(
            _deviceAddress,
            _timeLimit,
            _gpsReadingRange,
            false
        );
        emit DeviceAdded(_deviceAddress, _timeLimit, _gpsReadingRange);
    }

    // function sendCoordinates(
    //     uint _latitude,
    //     uint _longitude
    // ) external onlyDevice {
    //     isWithinZone = isWithinRange(_latitude, _longitude);
    //     emit ComplianceChecked(device, isWithinZone);

    //     if (isWithinZone) {
    //         emit RefundProcessed(device, 100);
    //     }
    // }
    function sendCoordinates(uint _latitude, uint _longitude) external {
        Device storage device = devices[msg.sender];
        require(device.deviceAddress != address(0), "Device not registered");
        require(block.timestamp <= device.timeLimit, "Time limit exceeded");

        bool isWithinZone = isWithinRange(_latitude, _longitude, device);
        device.compliance = isWithinZone;

        emit CoordinatesSent(msg.sender, _latitude, _longitude, isWithinZone);
    }

    function isWithinRange(
        uint _latitude,
        uint _longitutde
    ) internal view returns (bool) {
        uint latDiff = latitude > _latitude
            ? latitude - _latitude
            : _latitude - latitude;
        uint longDiff = longitude > _longitutde
            ? longitude - _longitutde
            : _longitutde - longitude;
        return (latDiff <= range && longDiff <= range);
    }

    function addFunds() external payable onlyCreator {
        avaialableFunds += msg.value;
    }

    function withdrawFunds(
        address payable _recipient,
        uint _amount
    ) external onlyCreator {
        require(_amount <= avaialableFunds, "Insufficient funds");
        avaialableFunds -= _amount;
        _recipient.transfer(_amount);
    }

    function getContractBalance() external view returns (uint) {
        return address(this).balance;
    }
}
