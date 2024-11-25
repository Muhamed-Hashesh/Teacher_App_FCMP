// bluetooth_scanner_page.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

import 'data_display_page.dart';

class BluetoothScannerPage extends StatefulWidget {
  const BluetoothScannerPage({super.key});

  @override
  BluetoothScannerPageState createState() => BluetoothScannerPageState();
}

class BluetoothScannerPageState extends State<BluetoothScannerPage> {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  StreamSubscription<DiscoveredDevice>? _scanSubscription;

  final Uuid serviceUuid = Uuid.parse("4fafc201-1fb5-459e-8fcc-c5c9c331914b");

  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  void _startScanning() async {
    bool permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) {
      print("Permissions not granted");
      return;
    }

    _startScan();
  }

  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      print("One or more permissions denied");
    }

    return allGranted;
  }

  void _startScan() {
    print('Scanning...');

    setState(() {
      _isScanning = true;
    });

    _scanSubscription = _ble.scanForDevices(withServices: [serviceUuid]).listen(
      (device) {
        print("Found device: ${device.name}");
        if (device.name == "ESP32_BLE") {
          print("Found ESP32: ${device.name}");
          _stopScan();
          _navigateToDataDisplayPage(device.id);
        }
      },
      onError: (error) {
        print("Scan error: $error");
        _stopScan();
      },
    );
  }

  void _stopScan() {
    _scanSubscription?.cancel();
    setState(() {
      _isScanning = false;
    });
    print("Scan stopped");
  }

  void _navigateToDataDisplayPage(String deviceId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DataDisplayPage(
          ble: _ble,
          deviceId: deviceId,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ESP32 Data Receiver"),
      ),
      body: Center(
        child: _isScanning
            ? CircularProgressIndicator()
            : Text(
                "Scanning for devices...",
                style: TextStyle(fontSize: 18),
              ),
      ),
    );
  }
}
