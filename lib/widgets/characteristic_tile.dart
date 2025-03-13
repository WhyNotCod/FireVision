import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:collection/collection.dart';
import 'package:matrices/matrices.dart';

import "../utils/snackbar.dart";
import "../parent.dart" as globals;
import "descriptor_tile.dart";

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;

  const CharacteristicTile(
      {Key? key,
      required this.characteristic,
      required this.descriptorTiles,
      required void Function(List<int> data) onValueChanged})
      : super(key: key);
  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  List<List<double>> _value = [];

  late StreamSubscription<List<int>> _lastValueSubscription;
  final transMat = Matrix.fromList([
    [-0.5, -0.5, 0],
    [0.5, -0.5, 0],
    [0.5, -0.5, 1],
    [-0.5, -0.5, 1],
    [-0.5, -0.5, 0],
    [-0.5, 0.5, 0],
    [0.5, 0.5, 0],
    [0.5, -0.5, 0],
    [0.5, -0.5, 1],
    [0.5, 0.5, 1],
    [0.5, 0.5, 0],
    [-0.5, 0.5, 0],
    [-0.5, 0.5, 1],
    [-0.5, -0.5, 1],
    [0.5, -0.5, 1],
    [0.5, 0.5, 1],
    [-0.5, 0.5, 1]
  ]);
  Matrix newMat = Matrix.fromList([
    [-0.5, -0.5, 0],
    [0.5, -0.5, 0],
    [0.5, -0.5, 1],
    [-0.5, -0.5, 1],
    [-0.5, -0.5, 0],
    [-0.5, 0.5, 0],
    [0.5, 0.5, 0],
    [0.5, -0.5, 0],
    [0.5, -0.5, 1],
    [0.5, 0.5, 1],
    [0.5, 0.5, 0],
    [-0.5, 0.5, 0],
    [-0.5, 0.5, 1],
    [-0.5, -0.5, 1],
    [0.5, -0.5, 1],
    [0.5, 0.5, 1],
    [-0.5, 0.5, 1]
  ]);
  @override
  void initState() {
    super.initState();
    _lastValueSubscription =
        widget.characteristic.lastValueStream.listen((value) {
      final bytes = Uint8List.fromList(value);
      final byteData = ByteData.sublistView(bytes);
      List<double> temp = [];
      for (var i = 0; i < value.length; i += 4) {
        temp.add(double.parse(
            (byteData.getFloat32(i, Endian.little)).toStringAsFixed(2)));
      }
      _value =
          temp.slices(3).toList(); //value.map((x) => x.toDouble()).toList();
      //_value = value;

      if (_value.isNotEmpty) {
        var tmpNewMat = [];
        for (var i = 0; i < _value.length; i++) {
          var newMat = transMat;
          double x = _value[i][0];
          double y = _value[i][1];
          double z = _value[i][2];
          newMat = updateData(newMat, x, y, z);
          tmpNewMat.add(newMat.matrix);
        }

        var strList = tmpNewMat
            .map((e) =>
                '{"type": "line3D","data": $e,"lineStyle": {"width": 4,"color": "#ff5733"}}')
            .toList();
        print("String List: ");
        print(strList); //testing if string updates
        //added
        globals.setBleData(strList); // Update this line
        } else {
          globals.setBleData([]); // Update this line
        }
      //   globals.bleData = strList; //
      // } else {
      //   globals.bleData = [];
      // }
      
      if (mounted) {
        setState(() {/* Need to change 3D animation */});
      }
    });
  }

  Matrix updateData(Matrix data, double x, double y, double z) {
    //data[-2] = (Matrix.fromList([data[-2]]) * z)[0]; // set height
    data[-2] = [0, 0, z, z, 0, 0, 0, 0, z, z, 0, 0, z, z, z, z, z];
    var tMat =
        Matrix.fromList(List.generate(17, (i) => [x, y, 0], growable: false));
    data = data + tMat;
    return data;
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  BluetoothCharacteristic get c => widget.characteristic;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  Future onReadPressed() async {
    try {
      await c.read();
      Snackbar.show(ABC.c, "Read: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Read Error:", e), success: false);
      print(e);
    }
  }

  Future onWritePressed() async {
    try {
      await c.write(_getRandomBytes(),
          withoutResponse: c.properties.writeWithoutResponse);
      Snackbar.show(ABC.c, "Write: Success", success: true);
      if (c.properties.read) {
        await c.read();
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
      print(e);
    }
  }

  Future onSubscribePressed() async {
    try {
      String op = c.isNotifying == false ? "Subscribe" : "Unubscribe";
      await c.setNotifyValue(c.isNotifying == false);
      Snackbar.show(ABC.c, "$op : Success", success: true);
      if (c.properties.read) {
        await c.read();
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Subscribe Error:", e),
          success: false);
      print(e);
    }
  }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${widget.characteristic.uuid.str.toUpperCase()}';
    return Text(uuid, style: TextStyle(fontSize: 13));
  }

  Widget buildValue(BuildContext context) {
    String data = _value.toString();
    return Text(data, style: TextStyle(fontSize: 13, color: Colors.grey));
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
        child: Text("Read"),
        onPressed: () async {
          await onReadPressed();
          if (mounted) {
            setState(() {});
          }
        });
  }

  Widget buildWriteButton(BuildContext context) {
    bool withoutResp = widget.characteristic.properties.writeWithoutResponse;
    return TextButton(
        child: Text(withoutResp ? "WriteNoResp" : "Write"),
        onPressed: () async {
          await onWritePressed();
          if (mounted) {
            setState(() {});
          }
        });
  }

  Widget buildSubscribeButton(BuildContext context) {
    bool isNotifying = widget.characteristic.isNotifying;
    return TextButton(
        child: Text(isNotifying ? "Unsubscribe" : "Subscribe"),
        onPressed: () async {
          await onSubscribePressed();
          if (mounted) {
            setState(() {});
          }
        });
  }

  Widget buildButtonRow(BuildContext context) {
    bool read = widget.characteristic.properties.read;
    bool write = widget.characteristic.properties.write;
    bool notify = widget.characteristic.properties.notify;
    bool indicate = widget.characteristic.properties.indicate;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (read) buildReadButton(context),
        if (write) buildWriteButton(context),
        if (notify || indicate) buildSubscribeButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Characteristic'),
            buildUuid(context),
            buildValue(context),
          ],
        ),
        subtitle: buildButtonRow(context),
        contentPadding: const EdgeInsets.all(0.0),
      ),
      children: widget.descriptorTiles,
    );
  }
}
