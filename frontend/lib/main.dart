import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class ContractClient {
  late Web3Client ethClient;
  String rpcUrl = "http://127.0.0.1:8545";

  ContractClient() {
    ethClient = Web3Client(
      rpcUrl,
      Client(),
    );
  }

  Position? _currentPosition;
  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString(
        "artifacts/contracts/Geolocation.sol/RefundGeolocation.json");
    String finalAbi = jsonDecode(abi)["abi"].toString();
    const String contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3";
    final contract = DeployedContract(
      ContractAbi.fromJson(finalAbi, "RefundGeolocation"),
      EthereumAddress.fromHex(contractAddress),
    );
    return contract;
  }

  Future<bool> sendCoordinates() async {
    String privateKey =
        "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";
    EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
    final deployedContract = await loadContract();

    final function = deployedContract.function('sendCoordinates');
    List<dynamic> params = [
      _currentPosition?.latitude.toDouble(),
      _currentPosition?.longitude.toDouble(),
    ];
    if (_currentPosition == null) {
      return false;
    }
    try {
      await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: deployedContract,
          function: function,
          parameters: params,
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}

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
      home: const GpsPage(),
    );
  }
}

class GpsPage extends StatefulWidget {
  const GpsPage({super.key});

  @override
  State<GpsPage> createState() => _GpsPageState();
}

class _GpsPageState extends State<GpsPage> {
  String? _currentAddress;
  Position? _currentPosition;
  final contractClient = ContractClient();

  Future<bool> _locationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services'),
        ),
      );
      return false;
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are denied'),
          ),
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _locationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Coordinates to get refund'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Latitude: ${_currentPosition?.latitude ?? ""}',
          ),
          Text(
            'Longitude: ${_currentPosition?.longitude ?? ""}',
          ),
          ElevatedButton(
            onPressed: _getCurrentPosition,
            child: const Text('Get my current location'),
          ),
          ElevatedButton(
            onPressed: () async {
              contractClient.sendCoordinates().then((success) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coordinates sent successfully!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Failed to send coordinates. Please try again.'),
                    ),
                  );
                }
              }).catchError(
                (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                    ),
                  );
                },
              );
            },
            child: const Text('Send My Coordinates'),
          ),
        ],
      )),
    );
  }
}
