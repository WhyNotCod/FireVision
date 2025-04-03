import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:matrices/matrices.dart';
import '../parent.dart' as globals;
import 'package:collection/collection.dart';

class BleService {
  static final BleService _instance = BleService._internal(); //
  factory BleService() => _instance;
  BleService._internal();

  StreamSubscription<List<int>>? _lastValueSubscription;
  List<List<double>> _value = [];
  final Matrix transMat = Matrix.fromList([
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

  List<List<double>> get value => _value;
  void startListening(BluetoothCharacteristic characteristic) {
    _lastValueSubscription = characteristic.lastValueStream.listen((value) {
      final bytes = Uint8List.fromList(value);
      final byteData = ByteData.sublistView(bytes);
      List<double> temp = [];
      for (var i = 0; i < value.length; i += 4) {
        temp.add(double.parse(
            (byteData.getFloat32(i, Endian.little)).toStringAsFixed(2)));
      }
      _value = temp.slices(3).toList();

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
        // print("String List");
        // print(strList);
        globals.setBleData(strList);
      } else {
        //print("hey buddy");
        globals.setBleData([]);
      }
    });
  }

  void stopListening() {
    _lastValueSubscription?.cancel();
  }

  Matrix updateData(Matrix data, double x, double y, double z) {
    data[-2] = [0, 0, z, z, 0, 0, 0, 0, z, z, 0, 0, z, z, z, z, z];
    var tMat =
        Matrix.fromList(List.generate(17, (i) => [x, y, 0], growable: false));
    data = data + tMat;
    return data;
  }
}
