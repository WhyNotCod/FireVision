// // import 'dart:ffi';
// import 'package:flutter/material.dart';
// import 'package:flutter_echarts/flutter_echarts.dart';
// import 'gl_script.dart' show glScript;
// import 'parent.dart' as globals;
// //import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// //import '../widgets/characteristic_tile.dart';

// class Graph extends StatefulWidget {
//   //final List<int> bleData; // Add BLE data parameter

//   //const Graph({super.key, required this.bleData});
//   const Graph({super.key});
//   @override
//   _GraphState createState() => _GraphState();
// }

// class _GraphState extends State<Graph> {
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

//   //added
//   @override
//   void initState() {
//     super.initState();
//     globals.onBleDataChanged = () {
//       setState(() {});
//     };
//   }

//   @override
//   void dispose() {
//     globals.onBleDataChanged = null;
//     super.dispose();
//   }

//   ///----------------------

//   @override
//   Widget build(BuildContext context) {
//     String option = '''
//     {
//       "tooltip": {},
//       "backgroundColor": "#fff",
//       "visualMap": {
//         "show": false,
//         "dimension": 2,
//         "min": 0,
//         "max": 30,
//         "inRange": {
//           "color": [
//             "#313695",
//             "#4575b4",
//             "#74add1",
//             "#abd9e9",
//             "#e0f3f8",
//             "#ffffbf",
//             "#fee090",
//             "#fdae61",
//             "#f46d43",
//             "#d73027",
//             "#a50026"
//           ]
//         }
//       },
//       "xAxis3D": {
//         "type": "value",
//         "min": -4.0,
//         "max": 4.0
//       },
//       "yAxis3D": {
//         "type": "value",
//         "min": 0,
//         "max": 8.0
//       },
//       "zAxis3D": {
//         "type": "value",
//         "min": 0,
//         "max": 3.0
//       },
//       "grid3D": {
//         "viewControl": {
//           "projection": "orthographic"
//         }
//       },
//       "series": ${globals.bleData}
//     }
//     ''';
//     return Container(
//       child: Echarts(
//         extensions: [glScript],
//         option: option,
//         reloadAfterInit: true,
//       ),
//       width: 300,
//       height: 250,
//     );
//   }
// }

// // extension on int {
// //   get length => null;
// // }

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'gl_script.dart' show glScript;
import 'parent.dart' as globals;

class Graph extends StatefulWidget {
  const Graph({super.key});
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  Map<String, dynamic> viewControl = {
    "projection": "orthographic",
    "autoRotate": false,
    "distance": 100,
    "alpha": 30,
    "beta": 30,
  };

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

  @override
  Widget build(BuildContext context) {
    String option = '''
    {
      "tooltip": {},
      "backgroundColor": "#fff",
      "visualMap": {
        "show": false,
        "dimension": 2,
        "min": 0,
        "max": 30,
        "inRange": {
          "color": [
            "#313695",
            "#4575b4",
            "#74add1",
            "#abd9e9",
            "#e0f3f8",
            "#ffffbf",
            "#fee090",
            "#fdae61",
            "#f46d43",
            "#d73027",
            "#a50026"
          ]
        }
      },
      "xAxis3D": {
        "type": "value",
        "min": -4.0,
        "max": 4.0
      },
      "yAxis3D": {
        "type": "value",
        "min": 0,
        "max": 8.0
      },
      "zAxis3D": {
        "type": "value",
        "min": 0,
        "max": 3.0
      },
      "grid3D": {
        "viewControl": ${viewControl}
      },
      "series": ${globals.bleData}
    }
    ''';
    return Container(
      child: Echarts(
        extensions: [glScript],
        option: option,
        reloadAfterInit: true,
        onMessage: (String message) {
          if (message.startsWith('viewControl')) {
            setState(() {
              viewControl = Map<String, dynamic>.from(
                  json.decode(message.substring('viewControl'.length)));
            });
          }
        },
      ),
      width: 300,
      height: 250,
    );
  }
}
