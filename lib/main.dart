//import 'dart:convert';

import 'dart:async';
import 'screens/bluetooth_off_screen.dart';
import 'screens/scan_screen.dart';
import 'package:fire_vision/3d_render.dart';
// import 'package:english_words/english_words.dart';
// import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//import 'package:permission_handler/permission_handler.dart';

//void main() => runApp(const MyApp());

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(const MyApp());
}

// This widget shows BluetoothOffScreen or
// ScanScreen depending on the adapter state
//
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<MyApp> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? const ScanScreen()
        : BluetoothOffScreen(adapterState: _adapterState);

    return MaterialApp(
      color: const Color.fromARGB(255, 190, 98, 12),
      title: 'FireVision',
      home: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              Image.asset('assets/images/icons8-fire-100.png',
                  height: 200, scale: 2),
              ElevatedButton(
                child: const Text('3D Render'),
                onPressed: () {
                  //print('Navigating to Render'); // Debugging print statement
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Render(title: 'FireVision'),
                    ),
                  );
                },
              ),
              Expanded(child: screen),
            ],
          ),
        ),
      ),
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

// Removed unused _buildConnectButton function

//
// This observer listens for Bluetooth Off and dismisses the DeviceScreen
//
class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??=
          FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}
