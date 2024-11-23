import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teacher_app/features/quiz/presentation/views/widgets/quiz_questions.dart';
import 'package:teacher_app/features/quiz/presentation/views/widgets/students_grid.dart';

class LiveExam extends StatefulWidget {
  const LiveExam({super.key});

  @override
  State<LiveExam> createState() => _LiveExamState();
}

class _LiveExamState extends State<LiveExam> {
  late Timer _timer;
  int _timeElapsed = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeElapsed++;
      });
    });
  }

  void _goToNextQuestion() {
    setState(() {
      if (_currentIndex < 9) {
        _currentIndex++;
        _timeElapsed = 0;
      } else {
        Navigator.pushReplacementNamed(context, '/resultsPage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final baseFontSize = screenHeight * 0.02;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: QuestionCardLiveExam(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      ),
    );
  }
}
