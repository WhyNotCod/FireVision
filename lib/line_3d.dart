// import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'gl_script.dart' show glScript;
import 'parent.dart' as globals;
//import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../widgets/characteristic_tile.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'ble_service.dart';
import "widgets/descriptor_tile.dart";

class Graph extends StatefulWidget {
  //final List<int> bleData; // Add BLE data parameter

  //const Graph({super.key, required this.bleData});
  const Graph({super.key});
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  BluetoothCharacteristic?
      _characteristic; // Define the _characteristic variable
  // List<List<double>> data = [
  //   [0, 0, 0],
  //   [1, 0, 0],
  //   [1, 0, 2],
  //   [0, 0, 2],
  //   [0, 0, 0],
  //   [0, 1, 0],
  //   [1, 1, 0],
  //   [1, 0, 0],
  //   [1, 0, 2],
  //   [1, 1, 2],
  //   [1, 1, 0],
  //   [0, 1, 0],
  //   [0, 1, 2],
  //   [0, 0, 2],
  //   [1, 0, 2],
  //   [1, 1, 2],
  //   [0, 1, 2]
  // ];
  //Added

  Future<void> onWritePressed(BluetoothCharacteristic characteristic) async {
    try {
      // Write the value 255 (1 byte) to the characteristic
      await characteristic.write([255], withoutResponse: true);
      print("Successfully wrote 255 to the characteristic.");
    } catch (e) {
      print("Error writing to characteristic: $e");
    }
  }

  //added
  @override
  void initState() {
    super.initState();
    globals.onBleDataChanged = () {
      setState(() {});
    };
  }

  @override
  void dispose() {
    globals.onBleDataChanged = null;
    super.dispose();
  }

  ///----------------------

  @override //added realtime
  Widget build(BuildContext context) {
    String option = '''
    {
      "tooltip": {},
      "backgroundColor": "#fff",
      // "visualMap": {
      //   "show": false,
      //   "dimension": 2,
      //   "min": 0,
      //   "max": 30,
      //   realTime: true,
      //   "inRange": {
      //     "color": [
      //       "#313695",
      //       "#4575b4",
      //       "#74add1",
      //       "#abd9e9",
      //       "#e0f3f8",
      //       "#ffffbf",
      //       "#fee090",
      //       "#fdae61",
      //       "#f46d43",
      //       "#d73027",
      //       "#a50026"
      //     ]
      //   }
      // },
      "xAxis3D": {
        "type": "value",
        name: "Width",
        "min": -4.0,
        "max": 4.0
      },
      "yAxis3D": {
        "type": "value",
        name: "Depth",
        "min": 0,
        "max": 8.0
      },
      "zAxis3D": {
        "type": "value",
        name: "H",
        "min": 0,
        "max": 3.0
      },
      "grid3D": {
        "viewControl": {
          "projection": "orthographic",
          "orthographicSize": 350
        }
      },
      "series": ${globals.bleData}
    }
    ''';
    //added
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 300,
              height: 250,
              child: Echarts(
                option: option,
                reloadAfterInit: true,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onTap: () async {
                // Add your button action here
                //print("Circular button pressed");
                if (_characteristic != null) {
                  await onWritePressed(_characteristic!);
                } else {
                  print("Characteristic is null");
                }
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue, // Background color of the circle
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 2,
                        color: Colors.white, // Line color
                      ),
                      SizedBox(height: 4), // Spacing between lines
                      Container(
                        width: 20,
                        height: 2,
                        color: Colors.white,
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: 20,
                        height: 2,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
