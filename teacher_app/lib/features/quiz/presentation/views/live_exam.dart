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
  @override
  void initState() {
    super.initState();
    // Set the orientation to landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Reset the orientation to default
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final baseFontSize =
        screenHeight * 0.02; // Base font size relative to screen height

    return Scaffold(
      body: Row(
        children: [
          // Left Panel in a Card - Question Card
          Expanded(
            flex: 1,
            child: QuestionCardLiveExam(
                screenWidth: screenWidth, screenHeight: screenHeight),
          ),
          // Right Panel in a Card - Timer and Students Card
          Expanded(
            flex: 1,
            child: Card(
              elevation: 4.0,
              margin: EdgeInsets.all(screenWidth * 0.01),
              child: Column(
                children: [
                  // Timer and progress bar wrapped in a Card
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
                                    "43s",
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
                          SizedBox(height: screenHeight * 0.02),
                          // Horizontal line as progress bar
                          LinearProgressIndicator(
                            value: 0.5,
                            color: Colors.black,
                            backgroundColor: Colors.grey[300],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Student grid
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
