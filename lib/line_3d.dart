import 'dart:math';

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
        final renderBox = _echartContainerKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.size.height < 10) {
          print("HEEEEELP");
          setState(() {
            _chartKey = UniqueKey();
          });
        }
      });
    });

    return SizedBox(
      width: 300,
      height: 300,
      child: Container(
        key: _echartContainerKey,
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
    );
  }
}