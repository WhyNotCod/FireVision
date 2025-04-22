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
import 'dart:math';

class Graph extends StatefulWidget {
  final BluetoothCharacteristic? characteristic;// Add BLE data parameter

  const Graph({super.key, required this.characteristic});
  //const Graph({super.key});
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  BluetoothCharacteristic? _characteristic; // Define the _characteristic variable
  int _selectedValue = 0; // Default selected value

  @override
  void initState() {
    super.initState();
    _characteristic = widget.characteristic; // Assign the passed characteristic
    globals.onBleDataChanged = () {
      setState(() {});
    };
  }

  @override
  void dispose() {
    globals.onBleDataChanged = null;
    super.dispose();
  }

  Future<void> onWritePressed(BluetoothCharacteristic characteristic, int value) async {
    try {
      // Write the selected value (0, 1, or 2) to the characteristic
      await characteristic.write([value], withoutResponse: true);
      print("Successfully wrote $value to the characteristic.");
    } catch (e) {
      print("Error writing to characteristic: $e");
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
        "name": "H",
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
            child: Column(
              children: [
                // Dropdown menu for selecting the value
                DropdownButton<int>(
                  value: _selectedValue,
                  items: [
                    DropdownMenuItem(value: 0, child: Text("Normal")),
                    DropdownMenuItem(value: 1, child: Text("ghost Removal")),
                    DropdownMenuItem(value: 2, child: Text("Show Ghosts")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!;
                    });
                  },
                ),
                SizedBox(height: 10), // Spacing between dropdown and button
                GestureDetector(
                  onTap: () async {
                    if (_characteristic != null) {
                      await onWritePressed(_characteristic!, _selectedValue);
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// class _GraphState extends State<Graph> {
//   BluetoothCharacteristic?
//       _characteristic; // Define the _characteristic variable
//   // List<List<double>> data = [
//   //   [0, 0, 0],
//   //   [1, 0, 0],
//   //   [1, 0, 2],
//   //   [0, 0, 2],
//   //   [0, 0, 0],
//   //   [0, 1, 0],
//   //   [1, 1, 0],
//   //   [1, 0, 0],
//   //   [1, 0, 2],
//   //   [1, 1, 2],
//   //   [1, 1, 0],
//   //   [0, 1, 0],
//   //   [0, 1, 2],
//   //   [0, 0, 2],
//   //   [1, 0, 2],
//   //   [1, 1, 2],
//   //   [0, 1, 2]
//   // ];
//   //Added

//   @override
//   void initState() {
//     super.initState();
//     _characteristic = widget.characteristic; // Assign the passed characteristic
//     globals.onBleDataChanged = () {
//       setState(() {});
//     };
//   }

//   @override
//   void dispose() {
//     globals.onBleDataChanged = null;
//     super.dispose();
//   }

//   List<int> _getRandomBytes() {
//     final math = Random();
//     return [
//       math.nextInt(255),
//       // math.nextInt(255),
//       // math.nextInt(255),
//       // math.nextInt(255)
//     ];
//   }

//   Future<void> onWritePressed(BluetoothCharacteristic characteristic) async {
//     try {
//       // Write the value 255 (1 byte) to the characteristic
//       await characteristic.write(_getRandomBytes(), withoutResponse: true);
//       print("Successfully wrote 255 to the characteristic.");
//     } catch (e) {
//       print("Error writing to characteristic: $e");
//     }
//   }

//   ///----------------------

//   @override //added realtime
//   Widget build(BuildContext context) {
//     String option = '''
//     {
//       "tooltip": {},
//       "backgroundColor": "#fff",
//       "xAxis3D": {
//         "type": "value",
//         name: "Width",
//         "min": -4.0,
//         "max": 4.0
//       },
//       "yAxis3D": {
//         "type": "value",
//         name: "Depth",
//         "min": 0,
//         "max": 8.0
//       },
//       "zAxis3D": {
//         "type": "value",
//         name: "H",
//         "min": 0,
//         "max": 3.0
//       },
//       "grid3D": {
//         "viewControl": {
//           "projection": "orthographic",
//           "orthographicSize": 350
//         }
//       },
//       "series": ${globals.bleData}
//     }
//     ''';
//     //added
//     return Scaffold(
//       body: Stack(
//         children: [
//           Center(
//             child: SizedBox(
//               width: 300,
//               height: 250,
//               child: Echarts(
//                 option: option,
//                 reloadAfterInit: true,
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             child: GestureDetector(
//               onTap: () async {
//                 // Add your button action here
//                 //print("Circular button pressed");
//                 if (_characteristic != null) {
//                   await onWritePressed(_characteristic!);
//                 } else {
//                   print("Characteristic is null");
//                 }
//               },
//               child: Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.blue, // Background color of the circle
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 20,
//                         height: 2,
//                         color: Colors.white, // Line color
//                       ),
//                       SizedBox(height: 4), // Spacing between lines
//                       Container(
//                         width: 20,
//                         height: 2,
//                         color: Colors.white,
//                       ),
//                       SizedBox(height: 4),
//                       Container(
//                         width: 20,
//                         height: 2,
//                         color: Colors.white,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
