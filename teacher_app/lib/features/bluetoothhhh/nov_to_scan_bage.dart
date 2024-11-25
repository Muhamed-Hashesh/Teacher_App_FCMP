import 'package:flutter/material.dart';
import 'package:teacher_app/features/bluetoothhhh/bluetooth_scanner_page.dart';

class NavToScanPage extends StatelessWidget {
  const NavToScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('NovToScan'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('NovToScan'),
              ElevatedButton(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BluetoothScannerPage(),
                        ),
                      ),
                  child: Text('Scan'))
            ],
          ),
        ));
  }
}
