import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GEOLOGIX - REFUND BY GPS",
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: GpsPage(),
    );
  }
}

class GpsPage extends StatefulWidget {
  const GpsPage({super.key});

  @override
  State<GpsPage> createState() => _GpsPageState();
}

class _GpsPageState extends State<GpsPage> {
  Location location = Location();
  double? latitude = 0.0;
  double? longitude = 0.0;

  Future<void> _getCurrentLocaion() async {
    try {
      LocationData currentLocation = await location.getLocation();
      setState(() {
        latitude = currentLocation.latitude;
        longitude = currentLocation.longitude;
      });
    } catch (e) {
      print('Failed to get Location,$e');
    }
  }

  // Future<void> _sendCoordinates() async {
  //   final client = Web3Client(
  //     'https://sepolia.infura.io/v3/378ceb8f39444456acb28987f3d881c9',
  //     Client(),
  //   );

  Future<void> _sendCoordinates() async {
    final client = Web3Client(
      'http://localhost:8545',
      Client(),
    );

    Credentials credentials = EthPrivateKey.fromHex('Private key');

    EthereumAddress contractAddress =
        EthereumAddress.fromHex('0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0');

    // final List<Map<String, dynamic>> abi = [
    //   {
    //     "inputs": [
    //       {"internalType": "uint256", "name": "_latitude", "type": "uint256"},
    //       {"internalType": "uint256", "name": "_longtiude", "type": "uint256"},
    //       {"internalType": "uint256", "name": "_range", "type": "uint256"}
    //     ],
    //     "stateMutability": "nonpayable",
    //     "type": "constructor"
    //   },
    //   {
    //     "anonymous": false,
    //     "inputs": [
    //       {
    //         "indexed": true,
    //         "internalType": "address",
    //         "name": "device",
    //         "type": "address"
    //       },
    //       {
    //         "indexed": false,
    //         "internalType": "bool",
    //         "name": "isWithinZone",
    //         "type": "bool"
    //       }
    //     ],
    //     "name": "ComplianceChecked",
    //     "type": "event"
    //   },
    //   {
    //     "anonymous": false,
    //     "inputs": [
    //       {
    //         "indexed": true,
    //         "internalType": "address",
    //         "name": "device",
    //         "type": "address"
    //       },
    //       {
    //         "indexed": false,
    //         "internalType": "uint256",
    //         "name": "amount",
    //         "type": "uint256"
    //       }
    //     ],
    //     "name": "RefundProcessed",
    //     "type": "event"
    //   },
    //   {
    //     "inputs": [],
    //     "name": "avaialableFunds",
    //     "outputs": [
    //       {"internalType": "uint256", "name": "", "type": "uint256"}
    //     ],
    //     "stateMutability": "view",
    //     "type": "function"
    //   },
    //   {
    //     "inputs": [],
    //     "name": "company",
    //     "outputs": [
    //       {"internalType": "address", "name": "", "type": "address"}
    //     ],
    //     "stateMutability": "view",
    //     "type": "function"
    //   },
    //   {
    //     "inputs": [],
    //     "name": "device",
    //     "outputs": [
    //       {"internalType": "address", "name": "", "type": "address"}
    //     ],
    //     "stateMutability": "view",
    //     "type": "function"
    //   },
    //   {
    //     "inputs": [],
    //     "name": "isWithinZone",
    //     "outputs": [
    //       {"internalType": "bool", "name": "", "type": "bool"}
    //     ],
    //     "stateMutability": "view",
    //     "type": "function"
    //   },
    //   {
    //     "inputs": [],
    //     "name": "latitude",
    //     "outputs": [
    //       {"internalType": "uint256", "name": "", "type": "uint256"}
    //     ],
    //     "stateMutability": "view",
    //     "type": "function"
    //   },
    //   {
    //     "inputs": [],
    //     "name": "longitude",
    //     "outputs": [
    //       {"internalType": "uint256", "name": "", "type": "uint256"}
    //     ],
    //     "stateMutability": "view",
    //     "type": "function"
    //   },
    //   {
    //     "inputs": [],
    //     "name": "range",
    //     "outputs": [
    //       {"internalType": "uint256", "name": "", "type": "uint256"}
    //     ],
    //     "stateMutability": "view",
    //     "type": "function"
    //   },
    //   {
    //     "inputs": [
    //       {"internalType": "uint256", "name": "_latitude", "type": "uint256"},
    //       {"internalType": "uint256", "name": "_longitude", "type": "uint256"}
    //     ],
    //     "name": "sendCoordinates",
    //     "outputs": [],
    //     "stateMutability": "nonpayable",
    //     "type": "function"
    //   }
    // ];

    String jsonData =
        '[{"inputs":[{"internalType":"uint256","name":"_latitude","type":"uint256"},{"internalType":"uint256","name":"_longtiude","type":"uint256"},{"internalType":"uint256","name":"_range","type":"uint256"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"device","type":"address"},{"indexed":false,"internalType":"bool","name":"isWithinZone","type":"bool"}],"name":"ComplianceChecked","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"device","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"RefundProcessed","type":"event"},{"inputs":[],"name":"avaialableFunds","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"company","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"device","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"isWithinZone","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"latitude","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"longitude","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"range","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_latitude","type":"uint256"},{"internalType":"uint256","name":"_longitude","type":"uint256"}],"name":"sendCoordinates","outputs":[],"stateMutability":"nonpayable","type":"function"}]';

    // List<ContractFunction> abi =  ContractAbi.fromJson(jsonData, 'Geolocation').functions;

    final contract = DeployedContract(
        ContractAbi.fromJson(jsonData, 'Geolocation'), contractAddress);
    final function = contract.function('sendCoordinates');
    List<dynamic> params = [
      latitude?.toDouble(),
      longitude?.toDouble(),
    ];

    await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: params,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Coordinates to get refund'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Latitude: $latitude',
          ),
          Text(
            'Longitude: $longitude',
          ),
          ElevatedButton(
            onPressed: _getCurrentLocaion,
            child: const Text('Get my current location'),
          ),
          ElevatedButton(
            onPressed: _sendCoordinates,
            child: const Text('Send My Coordinates'),
          ),
        ],
      )),
    );
  }
}
