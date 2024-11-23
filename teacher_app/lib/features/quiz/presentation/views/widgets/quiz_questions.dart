import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionCardLiveExam extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  const QuestionCardLiveExam({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<QuestionCardLiveExam> createState() => _QuestionCardLiveExamState();
}

class _QuestionCardLiveExamState extends State<QuestionCardLiveExam> {
  List<Map<String, dynamic>>? _questions;
  List<int?> _selectedOptions = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchQuestions(); // Fetch questions when the widget is initialized
  }

  Future<void> _fetchQuestions() async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Fetch all SessionIDs
      final sessionsSnapshot = await firestore.collection('Sessions').get();
      final sessionIDs = sessionsSnapshot.docs
          .map((doc) => doc.id)
          .where((id) => id.startsWith('SessionID'))
          .map((id) => int.tryParse(id.replaceFirst('SessionID', '')))
          .whereType<int>()
          .toList();
      sessionIDs.sort(); // Sort the IDs to find the biggest

      if (sessionIDs.isEmpty) {
        throw Exception('No SessionIDs found.');
      }

      // Get the biggest SessionID
      final biggestSessionID = sessionIDs.last;
      final questionListsCollection = firestore
          .collection('Sessions')
          .doc('SessionID$biggestSessionID')
          .collection('QuestionLists');

      final querySnapshot = await questionListsCollection.get();
      final questions = querySnapshot.docs.map((doc) {
        return {
          'question': doc['question_name'],
          'options': [
            doc['A'] as String,
            doc['B'] as String,
            doc['C'] as String,
            doc['D'] as String,
          ],
          'answer': doc['correct_answer'],
        };
      }).toList();

      setState(() {
        _questions = questions;
        _selectedOptions = List<int?>.filled(questions.length, null);
      });
    } catch (e) {
      // Handle errors
      setState(() {
        _questions = [];
      });
      debugPrint('Error fetching questions: $e');
    }
  }

  void _showNextQuestion() {
    if (_currentIndex < _questions!.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseFontSize = widget.screenHeight * 0.02;

    if (_questions == null) {
      // Show loading indicator while fetching
      return const Center(child: CircularProgressIndicator());
    }

    if (_questions!.isEmpty) {
      // Show error or empty state
      return const Center(child: Text("No questions available"));
    }

    final questionData = _questions![_currentIndex];
    final questionText = questionData['question'] ?? "Default question text";
    final options = questionData['options'] as List<String>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
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
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: widget.screenWidth * 0.01,
                mainAxisSpacing: widget.screenHeight * 0.02,
                childAspectRatio: 3,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                String letterPrefix = "${String.fromCharCode(65 + index)})";
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedOptions[_currentIndex] = index;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 233, 233, 233),
                    padding: EdgeInsets.all(widget.screenHeight * 0.01),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Letter Prefix
                      SizedBox(width: 8),
                      Text(
                        letterPrefix,
                        style: TextStyle(
                          fontSize: baseFontSize * 1.6,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between letter and option
                      // Option Text
                      Expanded(
                        child: Text(
                          options[index],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: baseFontSize * 1.6,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 217, 217, 217),
                  padding: EdgeInsets.all(widget.screenHeight * 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "Options",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: baseFontSize * 2,
                        color: Colors.white,
                      ),
                    ),
                    Icon(Icons.settings,
                        color: Colors.white, size: baseFontSize * 2.5),
                  ],
                ),
              ),
              Text(
                "Question ${_currentIndex + 1} of ${_questions!.length}",
                style: TextStyle(
                  fontSize: baseFontSize * 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: _currentIndex < _questions!.length - 1
                    ? _showNextQuestion
                    : () =>
                        Navigator.pushReplacementNamed(context, '/resultsPage'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 1, 151, 168),
                  padding: EdgeInsets.all(widget.screenHeight * 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      _currentIndex < _questions!.length - 1
                          ? "Next"
                          : "End Quiz",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: baseFontSize * 2,
                        color: Colors.white,
                      ),
                    ),
                    Icon(Icons.arrow_forward,
                        color: Colors.white, size: baseFontSize * 1.8),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
