import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'gl_script.dart' show glScript;
import 'parent.dart' as globals;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Graph extends StatefulWidget {
  const Graph({super.key, required this.characteristic});
  @override
  _GraphState createState() => _GraphState();
  final BluetoothCharacteristic? characteristic; // Add BLE data parameter
}

class _GraphState extends State<Graph> {
  Key _chartKey = UniqueKey();
  int _counter = 0;
  BluetoothCharacteristic? _characteristic;
  final GlobalKey _echartContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _characteristic = widget.characteristic;
    globals.onBleDataChanged = () {
      setState(() {});
    };
  }

  @override
  void dispose() {
    globals.onBleDataChanged = null;
    super.dispose();
  }

  void _writeUnsignedInt32() async {
    _counter = (_counter + 1) % 3; // Cycle through 0, 1, 2
    if (_characteristic != null) {
      try {
        // Create a 4-byte buffer for the unsigned 32-bit integer
        final byteData = ByteData(4);
        byteData.setUint32(0, _counter,
            Endian.little); // Write the value in little-endian format

        // Write the buffer to the characteristic
        await _characteristic!.write(byteData.buffer.asUint8List());
        print("Successfully wrote $_counter to characteristic");
      } catch (e) {
        print("Error writing to characteristic: $e");
      }
    } else {
      print("Characteristic is null");
    }
    setState(() {}); // Update the UI to reflect the new mode
  }

  String _getModeText() {
    switch (_counter) {
      case 0:
        return "Normal";
      case 1:
        return "Ghost Removal";
      case 2:
        return "Highlight Ghosts";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    String option = '''
    {
      "tooltip": {},
      "backgroundColor": "#fff",
      "xAxis3D": {
        "type": "value",
        "name": "Width",
        "min": -4.0,
        "max": 4.0
      },
      "yAxis3D": {
        "type": "value",
        "name": "Depth",
        "min": 0,
        "max": 8.0
      },
      "zAxis3D": {
        "type": "value",
        "name": "Height",
        "min": 0,
        "max": 3.0
      },
      "grid3D": {
        "viewControl": {
          "projection": "orthographic",
          "orthographicSize": 400
        }
      },
      "series": ${globals.bleData}
    }
    ''';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        final renderBox = _echartContainerKey.currentContext?.findRenderObject()
            as RenderBox?;
        if (renderBox != null && renderBox.size.height < 10) {
          print("HEEEEELP");
          setState(() {
            _chartKey = UniqueKey();
          });
        }
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("FireVISION"),
        backgroundColor: const Color.fromARGB(255, 137, 17, 6), // Solid color
      ),
      body: Column(
        children: [
          Expanded(
            child: Echarts(
              key: _chartKey,
              extensions: [glScript],
              option: option,
              reloadAfterInit: false,
              onWebResourceError: (controller, error) {
                print("Callback Error: $error");
                setState(() {
                  _chartKey = UniqueKey();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 50.0), // Adjust the value to move the button higher
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _writeUnsignedInt32,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 137, 17, 6), // Set the background color
                  ),
                  child: const Text("Toggle Mode"),
                ),
                const SizedBox(
                    width: 16), // Add spacing between the button and text
                Text(
                  _getModeText(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
