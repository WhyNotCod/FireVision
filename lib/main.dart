import 'dart:async';
import 'screens/bluetooth_off_screen.dart';
import 'screens/scan_screen.dart';
import 'line_3d.dart';
//import 'package:fire_vision/render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'ble_service.dart';

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
      color: const Color.fromARGB(255, 137, 17, 6),
      title: 'FireVisions',
      home: HomeScreen(screen: screen),
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Widget screen;

  const HomeScreen({super.key, required this.screen});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BluetoothCharacteristic? _characteristicFF03;

  Future<void> _connectAndSubscribe() async {
    try {
      // Start scanning for devices with specific names
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        withNames: ["FireVision_Device", "FloatArray_Device"],
      );

      // Listen for scan results
      FlutterBluePlus.scanResults.listen((results) async {
        for (ScanResult result in results) {
          final device = result.device;

          // Connect to the device
          await device.connect();

          // Discover services
          List<BluetoothService> services = await device.discoverServices();

          // Look for the service with GUID 0x0FF
          for (BluetoothService service in services) {
            print("Help ${service.uuid}");
            if (service.serviceUuid == Guid("00FF")) {
              print("Service 0x0FF found!");

              // Look for the characteristic 0xFF03
              for (BluetoothCharacteristic characteristic
                  in service.characteristics) {
                if (characteristic.uuid == Guid("FF02")) {
                  print("Characteristic 0xFF02 found!");

                  // Subscribe to the characteristic
                  await characteristic.setNotifyValue(true);
                  BleService().startListening(characteristic);
                  if (characteristic.properties.read) {
                    await characteristic.read();
                  }

                  // Stop scanning and return after successful subscription
                  // await FlutterBluePlus.stopScan();
                  // return;
                }
                if (characteristic.uuid == Guid("FF03")) {
                  print("Characteristic 0xFF03 found!");
                  setState(() {
                    _characteristicFF03 = characteristic;
                  });

                  // Stop scanning and return after successful subscription
                  await FlutterBluePlus.stopScan();
                  return;
                }
              }
            }
          }

          // Disconnect if the service or characteristic is not found
          await device.disconnect();
        }
      });
    } catch (e) {
      print("Error connecting to device or subscribing to characteristic: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FireVision"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 50, // Adjust the height as needed
              width:
                  double.infinity, // Make it span the full width of the screen
              color: const Color.fromARGB(255, 137, 17, 6), // Solid color
            ),
            const Spacer(flex: 1),
            Image.asset('assets/images/logo.png', height: 200, scale: 4),
            ElevatedButton(
              onPressed: () {
                print('Navigating to Render'); // Debugging print statement
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        Graph(characteristic: _characteristicFF03),
                  ),
                );
              },
              child: const Text('3D Render'),
            ),
            ElevatedButton(
              onPressed: _connectAndSubscribe,
              child: const Text('Connect'),
            ),
            Expanded(child: widget.screen),
            Image.asset(
              'assets/images/house_on_fire.jpg', // Replace with your image path
              height: 100, // Adjust the height as needed
              scale: 2, // Adjust the scale as needed
            ),
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
