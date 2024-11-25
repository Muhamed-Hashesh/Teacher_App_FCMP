// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
//
// import 'result_page.dart';
//
// class DataDisplayPage extends StatefulWidget {
//   final FlutterReactiveBle ble;
//   final String deviceId;
//   int? currentIndex;
//
//   DataDisplayPage({
//     super.key,
//     required this.ble,
//     required this.deviceId,
//     this.currentIndex = 1,
//   });
//
//   @override
//   DataDisplayPageState createState() => DataDisplayPageState();
// }
//
// class DataDisplayPageState extends State<DataDisplayPage> {
//   final Uuid serviceUuid = Uuid.parse("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
//   final Uuid characteristicUuid =
//       Uuid.parse("beb5483e-36e1-4688-b7f5-ea07361b26a8");
//
//   StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;
//   StreamSubscription<List<int>>? _valueSubscription;
//
//   String _receivedData = "No value yet";
//   String? mac = "";
//   String? answer = "";
//
//   bool _isConnected = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _connectToDevice();
//   }
//
//   void _connectToDevice() {
//     print('Connecting to device...');
//
//     _connectionSubscription =
//         widget.ble.connectToDevice(id: widget.deviceId).listen(
//       (connectionState) {
//         switch (connectionState.connectionState) {
//           case DeviceConnectionState.connecting:
//             print("Connecting to ESP32...");
//             break;
//           case DeviceConnectionState.connected:
//             print("Connected to ESP32");
//             setState(() {
//               _isConnected = true;
//             });
//             _subscribeToCharacteristic();
//             break;
//           case DeviceConnectionState.disconnecting:
//             print("Disconnecting from ESP32...");
//             break;
//           case DeviceConnectionState.disconnected:
//             print("Disconnected from ESP32");
//             _connectionSubscription?.cancel();
//             _valueSubscription?.cancel();
//             setState(() {
//               _isConnected = false;
//             });
//             break;
//         }
//       },
//       onError: (error) {
//         print("Connection error: $error");
//         _connectionSubscription?.cancel();
//         _valueSubscription?.cancel();
//         setState(() {
//           _isConnected = false;
//         });
//       },
//     );
//   }
//
//   void _subscribeToCharacteristic() {
//     print('Subscribing to characteristic...');
//     final characteristic = QualifiedCharacteristic(
//       serviceId: serviceUuid,
//       characteristicId: characteristicUuid,
//       deviceId: widget.deviceId,
//     );
//
//     _valueSubscription =
//         widget.ble.subscribeToCharacteristic(characteristic).listen(
//       (data) {
//         final value = String.fromCharCodes(data);
//         setState(() {
//           _receivedData = value;
//           mac = _receivedData.substring(0, 17);
//           answer = _receivedData.substring(18);
//         });
//         print("Received data: $_receivedData");
//
//         // Update Firestore with the received data
//         _updateFirestore();
//       },
//       onError: (error) {
//         print("Characteristic subscription error: $error");
//       },
//     );
//     print('Subscription started');
//   }
//
//   void _updateFirestore() async {
//     if (mac != null && answer != null) {
//       try {
//         // Build the document reference
//         DocumentReference docRef = FirebaseFirestore.instance
//             .collection('Sessions')
//             .doc('SessionID1')
//             .collection('responses')
//             .doc(mac)
//             .collection('questions_id')
//             .doc(widget.currentIndex.toString());
//
//         // Data to be saved
//         Map<String, dynamic> data = {
//           'answer': answer,
//         };
//
//         // Write data to Firestore
//         await docRef.set(data);
//         print("Data written to Firestore at index ${widget.currentIndex}.");
//
//         // Increment the index for the next entry
//         setState(() {
//           widget.currentIndex = widget.currentIndex! + 1;
//         });
//       } catch (e) {
//         print("Error writing to Firestore: $e");
//       }
//     } else {
//       print("MAC or Answer is null, cannot update Firestore.");
//     }
//   }
//
//   void _disconnectAndNavigateToResult() {
//     _valueSubscription?.cancel();
//     _connectionSubscription?.cancel();
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ResultPage(),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _valueSubscription?.cancel();
//     _connectionSubscription?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Received Data"),
//       ),
//       body: Center(
//         child: _isConnected
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Received Data:\n$_receivedData\nMAC: $mac\nAnswer: $answer",
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _disconnectAndNavigateToResult,
//                     child: Text("Go to Result Page"),
//                   ),
//                 ],
//               )
//             : CircularProgressIndicator(),
//       ),
//     );
//   }
// }
