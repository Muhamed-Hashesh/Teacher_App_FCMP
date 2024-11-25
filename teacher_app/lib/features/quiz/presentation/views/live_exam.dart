import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:teacher_app/features/quiz/presentation/views/widgets/quiz_questions.dart';
import 'package:teacher_app/features/quiz/presentation/views/widgets/students_grid.dart';

class LiveExam extends StatefulWidget {
  const LiveExam({super.key, required this.ble, required this.deviceId});

  final FlutterReactiveBle ble;
  final String deviceId;

  @override
  State<LiveExam> createState() => _LiveExamState();
}

class _LiveExamState extends State<LiveExam> {
  late Timer _timer;
  int _timeElapsed = 0;
  int _currentIndex = 0;

  final Uuid serviceUuid = Uuid.parse("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
  final Uuid characteristicUuid =
      Uuid.parse("beb5483e-36e1-4688-b7f5-ea07361b26a8");

  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;
  StreamSubscription<List<int>>? _valueSubscription;

  String _receivedData = "No value yet";
  String? mac = "";
  String? answer = "";

  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _connectToDevice();
    _startTimer();
  }

  void _connectToDevice() {
    print('Connecting to device...');

    _connectionSubscription =
        widget.ble.connectToDevice(id: widget.deviceId).listen(
      (connectionState) {
        switch (connectionState.connectionState) {
          case DeviceConnectionState.connecting:
            print("Connecting to ESP32...");
            break;
          case DeviceConnectionState.connected:
            print("Connected to ESP32");
            setState(() {
              _isConnected = true;
            });
            _subscribeToCharacteristic();
            break;
          case DeviceConnectionState.disconnecting:
            print("Disconnecting from ESP32...");
            break;
          case DeviceConnectionState.disconnected:
            print("Disconnected from ESP32");
            _connectionSubscription?.cancel();
            _valueSubscription?.cancel();
            setState(() {
              _isConnected = false;
            });
            break;
        }
      },
      onError: (error) {
        print("Connection error: $error");
        _connectionSubscription?.cancel();
        _valueSubscription?.cancel();
        setState(() {
          _isConnected = false;
        });
      },
    );
  }

  void _subscribeToCharacteristic() {
    print('Subscribing to characteristic...');
    final characteristic = QualifiedCharacteristic(
      serviceId: serviceUuid,
      characteristicId: characteristicUuid,
      deviceId: widget.deviceId,
    );

    _valueSubscription =
        widget.ble.subscribeToCharacteristic(characteristic).listen(
      (data) {
        final value = String.fromCharCodes(data);
        setState(() {
          _receivedData = value;
          mac = _receivedData.substring(0, 17);
          answer = _receivedData.substring(18);
        });
        print("Received data: $_receivedData");

        _updateFirestore();
      },
      onError: (error) {
        print("Characteristic subscription error: $error");
      },
    );
    print('Subscription started');
  }

  void _updateFirestore() async {
    if (mac != null && answer != null) {
      try {
        DocumentReference docRef = FirebaseFirestore.instance
            .collection('Sessions')
            .doc('SessionID1')
            .collection('responses')
            .doc(mac)
            .collection('questions_id')
            .doc((_currentIndex + 1).toString());

        Map<String, dynamic> data = {
          'answer': answer,
        };

        await docRef.set(data, SetOptions(merge: true));
        print("Data written to Firestore at index ${_currentIndex + 1}.");
      } catch (e) {
        print("Error writing to Firestore: $e");
      }
    } else {
      print("MAC or Answer is null, cannot update Firestore.");
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _valueSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeElapsed++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final baseFontSize = screenHeight * 0.02;

    return Scaffold(
      body: _isConnected
          ? Row(
              children: [
                Expanded(
                  flex: 5,
                  child: QuestionCardLiveExam(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    onIndexChanged: (newIndex) {
                      setState(() {
                        _currentIndex = newIndex;
                        _timeElapsed = 0;
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Card(
                    elevation: 4.0,
                    margin: EdgeInsets.all(screenWidth * 0.01),
                    child: Column(
                      children: [
                        Card(
                          elevation: 0.5,
                          margin: EdgeInsets.only(
                            top: 20,
                            bottom: screenWidth * 0.01,
                            left: 0,
                            right: 0,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                                horizontal: screenWidth * 0.02),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.timer_outlined,
                                            size: baseFontSize * 2.6),
                                        SizedBox(width: screenWidth * 0.01),
                                        Text(
                                          "$_timeElapsed s",
                                          style: TextStyle(
                                              fontSize: baseFontSize * 2.5,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.people,
                                          size: baseFontSize * 2.6,
                                        ),
                                        SizedBox(width: screenWidth * 0.01),
                                        Text(
                                          "14/36",
                                          style: TextStyle(
                                              fontSize: baseFontSize * 2.5,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Expanded(
                          child: StudentGrid(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            baseFontSize: baseFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : CircularProgressIndicator(),
    );
  }
}
