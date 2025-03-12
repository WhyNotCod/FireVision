import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'line_3d.dart'; // Your Graph widget
import '../widgets/characteristic_tile.dart'; // Your CharacteristicTile widget

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  _ParentScreenState createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  // Assuming this is your BluetoothCharacteristic object
  late BluetoothCharacteristic _characteristic;

  // Example to hold BLE data
  List<int> _value = [];

  // Callback to handle when new BLE data is received
  void _onBleDataChanged(List<int> data) {
    setState(() {
      _value = data; // Update the BLE data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Pass the correct BluetoothCharacteristic object, not the StreamSubscription
          CharacteristicTile(
            characteristic: _characteristic, // Pass the characteristic here
            descriptorTiles: [], // Pass the descriptorTiles here
            onValueChanged:
                _onBleDataChanged, // Pass the callback to handle updates
          ),
          Expanded(
            child: Graph(bleData: _value), // Pass data to Graph widget
          ),
        ],
      ),
    );
  }
}
