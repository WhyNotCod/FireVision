import 'dart:async';
import 'screens/bluetooth_off_screen.dart';
import 'screens/scan_screen.dart';
import 'line_3d.dart';
//import 'package:fire_vision/render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(const MyApp());
}

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
      title: 'FireVisions',
      home: HomeScreen(screen: screen),
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}
//wait so would this just be a simple fix of just extracting the scaffold into another class ?
//Essentially, the context belongs to the Widget class. And when searching for inherited widgets, it can only search up the tree from that Widget

class HomeScreen extends StatelessWidget {
  final Widget screen;

  const HomeScreen({Key? key, required this.screen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FireVision"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset('assets/images/icons8-fire-100.png',
                height: 200, scale: 2),
            ElevatedButton(
              onPressed: () {
                print('Navigating to Render'); // Debugging print statement
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Graph(),
                  ),
                );
              },
              child: const Text('3D Render'),
            ),
            Expanded(child: screen),
          ],
        ),
      ),
    );
  }
}

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
