import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            child: QuestionCardLiveExam(screenWidth: screenWidth, screenHeight: screenHeight),
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
                          // Timer and students count row
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

class QuestionCardLiveExam extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  const QuestionCardLiveExam({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,    
  }) : super(key: key);

  @override
  State<QuestionCardLiveExam> createState() => _QuestionCardLiveExamState();
}

class _QuestionCardLiveExamState extends State<QuestionCardLiveExam> {
  int? _selectedOptionIndex;
  int _currentIndex = 0;
  List<DocumentSnapshot> _documents = [];

  void _showNextQuestion() {
    if (_currentIndex < _documents.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseFontSize = widget.screenHeight * 0.02;

    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(widget.screenWidth * 0.01),
      child: Padding(
        padding: EdgeInsets.all(widget.screenWidth * 0.01),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('your_question_list')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("An error occurred"));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            _documents = snapshot.data?.docs ?? [];

            if (_documents.isEmpty) {
              return const Center(child: Text("No questions available"));
            }

            final documentData =
                _documents[_currentIndex].data() as Map<String, dynamic>?;

            final questionText =
                documentData?['question_name'] ?? "What is the capital of France?";
            final options = [
              documentData?['A'] ?? "London",
              documentData?['B'] ?? "Berlin",
              documentData?['C'] ?? "Paris",
              documentData?['D'] ?? "Madrid"
            ];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Text(
                    questionText,
                    style: TextStyle(
                      fontSize: baseFontSize * 2.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: widget.screenHeight * 0.06),
                Column(
                  children: List.generate(
                    (options.length / 2).ceil(),
                    (rowIndex) {
                      int firstOptionIndex = rowIndex * 2;
                      int secondOptionIndex = firstOptionIndex + 1;
                      return Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedOptionIndex = firstOptionIndex;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedOptionIndex == firstOptionIndex
                                    ? Colors.blue
                                    : const Color.fromARGB(255, 233, 233, 233),
                                padding:
                                    EdgeInsets.all(widget.screenHeight * 0.02),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                options[firstOptionIndex],
                                style: TextStyle(
                                  fontSize: baseFontSize * 2,
                                  color: _selectedOptionIndex == firstOptionIndex
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          if (secondOptionIndex < options.length) ...[
                            SizedBox(width: widget.screenWidth * 0.01),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedOptionIndex = secondOptionIndex;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedOptionIndex ==
                                          secondOptionIndex
                                      ? Colors.blue
                                      : const Color.fromARGB(255, 233, 233, 233),
                                  padding: EdgeInsets.all(widget.screenHeight * 0.02),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  options[secondOptionIndex],
                                  style: TextStyle(
                                    fontSize: baseFontSize * 2,
                                    color: _selectedOptionIndex == secondOptionIndex
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.settings,
                        size: baseFontSize * 2,
                        color: Colors.black,
                      ),
                      label: Text(
                        "Options",
                        style: TextStyle(
                          fontSize: baseFontSize * 2,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: widget.screenHeight * 0.053,
                          horizontal: widget.screenHeight * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color.fromARGB(255, 220, 219, 219)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Text(
                      "Question ${_currentIndex + 1} of ${_documents.length}",
                      style: TextStyle(
                        fontSize: baseFontSize * 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed:
                          _currentIndex < _documents.length - 1 ? _showNextQuestion : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentIndex < _documents.length - 1
                            ? const Color.fromARGB(255, 1, 151, 168)
                            : Colors.grey,
                        padding: EdgeInsets.all(widget.screenHeight * 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Next",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: baseFontSize * 2,
                                color: Colors.white),
                          ),
                          Icon(Icons.arrow_forward,
                              color: Colors.white, size: baseFontSize * 1.8),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class StudentGrid extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final double baseFontSize;

  const StudentGrid({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.baseFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate a list of students and their response status
    List<Map<String, dynamic>> students = List.generate(26, (index) {
      return {
        'name': 'Student',
        'hasResponded': index % 2 == 0, // Example logic for responding students
      };
    });

    // Separate students based on their response status
    List<Map<String, dynamic>> respondedStudents =
        students.where((student) => student['hasResponded']).toList();
    List<Map<String, dynamic>> notRespondedStudents =
        students.where((student) => !student['hasResponded']).toList();

    // Combine lists with responded students at the top
    List<Map<String, dynamic>> orderedStudents = [
      ...respondedStudents,
      ...notRespondedStudents,
    ];

    return GridView.builder(
      padding: EdgeInsets.all(screenWidth * 0.01),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        crossAxisSpacing: screenWidth * 0.01,
        mainAxisSpacing: screenHeight * 0.01,
      ),
      itemCount: orderedStudents.length,
      itemBuilder: (context, index) {
        final student = orderedStudents[index];
        bool hasResponded = student['hasResponded'];

        return Container(
          decoration: BoxDecoration(
            color: hasResponded
                ? const Color.fromARGB(255, 1, 151, 168)
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/Male-Doctor.png",
                  fit: BoxFit.cover,
                ),
                Center(
                  child: Text(
                    student['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: baseFontSize * 1.6,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
