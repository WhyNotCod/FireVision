//import 'package:flutter/material.dart';
//import 'package:flutter_echarts/flutter_echarts.dart';
//import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
//import 'dart:math' as Math;

// @override
// void initState() {
//   super.initState();
//   loadData();
// }

// //read from json file function here...needs to specify strings
// Future<void> loadData() async {
//   final String response = await rootBundle.loadString('assets/replay_1.json');
//   final List<dynamic> jsonData = json.decode(response);

//   // Assuming the JSON structure is a list of lists with x, y, z coordinates
//   data = jsonData.map((item) => [item[0] as double, item[1] as double, item[2] as double]).toList();

//   setState(() {
//     isLoading = false;
//   });
// }

//void main() => runApp(MyApp());
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart'
    as ECharts; // For chart display

class Graph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3D Line Chart'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Line3DChart(),
      ),
    );
  }
}

class Line3DChart extends StatelessWidget {
  const Line3DChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Step 1: Define variables
    var x = 0;
    var y = 2;
    var z = 2; // Example value for z

    // Step 2: Define the data
    var data = [
      [0, 0, 0], [1, 0, 0], // Line A-B
      [1, 0, 2], [0, 0, 2], [0, 0, 0],
      [0, 1, 0], [1, 1, 0], [1, 0, 0], [1, 0, 2],
      [1, 1, 2], [1, 1, 0], [0, 1, 0], [0, 1, 2],
      [0, 0, 2], [1, 0, 2], [1, 1, 2], [0, 1, 2]
    ];

    // Step 3: Modify the data list
    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < data[i].length; j++) {
        if (data[i][j] == 2) {
          data[i][j] = z; // Replace 2 with z
        }
        if (j == 0) {
          // Update x-coordinate
          data[i][j] += x; // Add x to the x-coordinate
        }
        if (j == 1) {
          // Update y-coordinate
          data[i][j] += y; // Add y to the y-coordinate
        }
      }
    }

    // Step 4: Convert data to a string to use in ECharts configuration
    //var dataString = data.toString().replaceAll('[', '').replaceAll(']', '');

    // Step 5: Define the ECharts option with the modified data
    var option = {
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
      "xAxis3D": {"type": "value", "min": -1.80, "max": 1.8},
      "yAxis3D": {"type": "value", "min": 0, "max": 5.5},
      "zAxis3D": {"type": "value", "min": 0, "max": 2.0},
      "grid3D": {
        "viewControl": {"projection": "orthographic"}
      },
      "series": [
        {
          "type": "line3D",
          "data": data,
          "lineStyle": {"width": 4}
        }
      ]
    };

    // Step 6: Return ECharts widget
    return ECharts.Echarts(
      option: jsonEncode(option),
    );
  }
}
