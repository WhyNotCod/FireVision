import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BleManager with ChangeNotifier {
  late FlutterBlue _flutterBlue;

  BleManager() {
    _flutterBlue = FlutterBlue.instance;
  }

  Future<void> startScan() async {
    _flutterBlue.startScan(timeout: Duration(seconds: 4));
  }



  Future<void> stopScan() async {
    _flutterBlue.stopScan();
  }
  //transform the stream of lists into a stream of individual ScanResult items.
  Stream<ScanResult> get scanResults => _flutterBlue.scanResults.asyncExpand((results) => Stream.fromIterable(results));

  Future<void> connectToDevice(ScanResult device) async {
    await device.device.connect();
  }
}