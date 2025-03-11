import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'gl_script.dart' show glScript;
import 'dart:math';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  List<List<double>> generateData() {
    List<List<double>> data = [];
    for (double t = 0; t < 25; t += 0.001) {
      double x = (1 + 0.25 * cos(75 * t)) * cos(t);
      double y = (1 + 0.25 * cos(75 * t)) * sin(t);
      double z = t + 2.0 * sin(75 * t);
      data.add([x, y, z]);
    }
    print(data.length);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    List<List<double>> data = generateData();
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
        "type": "value"
      },
      "yAxis3D": {
        "type": "value"
      },
      "zAxis3D": {
        "type": "value"
      },
      "grid3D": {
        "viewControl": {
          "projection": "orthographic"
        }
      },
      "series": [
        {
          "type": "line3D",
          "data": $data,
          "lineStyle": {
            "width": 4
          }
        }
      ]
    }
    ''';

    return Container(
      child: Echarts(
        extensions: [glScript],
        option: option,
      ),
      width: 300,
      height: 250,
    );
  }
}


//-------------
// import 'package:flutter_echarts/flutter_echarts.dart';
// import 'package:flutter/material.dart';


// class Graph extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('3D Chart')),
//       body: Echarts(
//         extraScript: '''
//           <script src="assets/echarts.min.js"></script>
//           <script src="assets/echarts-gl.min.js"></script>
//         ''',
//         option: '''
//           {
//             "xAxis3D": {
//               "type": "value",
//               "min": -1.80,  // x-min
//               "max": 1.8    // x-max
//             },
//             "yAxis3D": {
//               "type": "value",
//               "min": 0,   // y-min
//               "max": 5.5    // y-max
//             },
//             "zAxis3D": {
//               "type": "value",
//               "min": 0,     // z-min
//               "max": 2.0    // z-max
//             },
//             "grid3D": {},
//             "series": [{
//               "type": "line3D",
//               "data": [[0,0,0], [1,0,0]]
//             }]
//           }
//         ''',
//       ),
//     );
//   }
// }
//------------------------------------
// class Graph extends StatelessWidget {
//   const Graph({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('3D Line Chart'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Line3DChart(),
//       ),
//     );
//   }
// }

// class Line3DChart extends StatelessWidget {
//   const Line3DChart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Step 1: Define variables
//     // var x = 0;
//     // var y = 2;
//     // var z = 2; // Example value for z

//     // Step 2: Define the data
//     // var data = [
//     //   [0, 0, 0], [1, 0, 0], // Line A-B
//     //   [1, 0, 2], [0, 0, 2], [0, 0, 0],
//     //   [0, 1, 0], [1, 1, 0], [1, 0, 0], [1, 0, 2],
//     //   [1, 1, 2], [1, 1, 0], [0, 1, 0], [0, 1, 2],
//     //   [0, 0, 2], [1, 0, 2], [1, 1, 2], [0, 1, 2]
//     // ];

//     // // Step 3: Modify the data list
//     // for (var i = 0; i < data.length; i++) {
//     //   for (var j = 0; j < data[i].length; j++) {
//     //     if (data[i][j] == 2) {
//     //       data[i][j] = z; // Replace 2 with z
//     //     }
//     //     if (j == 0) {
//     //       // Update x-coordinate
//     //       data[i][j] += x; // Add x to the x-coordinate
//     //     }
//     //     if (j == 1) {
//     //       // Update y-coordinate
//     //       data[i][j] += y; // Add y to the y-coordinate
//     //     }
//     //   }
//     // }

//     // Step 4: Convert data to a string to use in ECharts configuration
//     //var dataString = data.toString().replaceAll('[', '').replaceAll(']', '');

//     // Step 5: Define the ECharts option with the modified data

//     // Step 6: Return ECharts widget
//     // return (
//     //   option: jsonEncode(option),
//     // );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_echarts/flutter_echarts.dart';

// class Graph extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Simple Chart'),
//       ),
//       body: Center(child: Container(child: Echarts(option: ''' {
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
//       "xAxis3D": {"type": "value", "min": -1.80, "max": 1.8},
//       "yAxis3D": {"type": "value", "min": 0, "max": 5.5},
//       "zAxis3D": {"type": "value", "min": 0, "max": 2.0},
//       "grid3D": {
//         "viewControl": {"projection": "orthographic"}
//       },
//       "series": [
//         {
//           "type": "line3D",
//           "data": [
//       [0, 0, 0], [1, 0, 0],
//       [1, 0, 2], [0, 0, 2], [0, 0, 0],
//       [0, 1, 0], [1, 1, 0], [1, 0, 0], [1, 0, 2],
//       [1, 1, 2], [1, 1, 0], [0, 1, 0], [0, 1, 2],
//       [0, 0, 2], [1, 0, 2], [1, 1, 2], [0, 1, 2]
//     ],
//           "lineStyle": {"width": 4}
//         }
//       ]
//     }'''))),
//     );
//   }
// }
