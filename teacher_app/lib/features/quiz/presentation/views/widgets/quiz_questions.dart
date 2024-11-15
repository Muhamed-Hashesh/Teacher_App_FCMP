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
      final querySnapshot = await FirebaseFirestore.instance
          .collection('ai_generated_questions')
          .get();

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
      return Center(child: CircularProgressIndicator());
    }

    if (_questions!.isEmpty) {
      // Show error or empty state
      return const Center(child: Text("No questions available"));
    }

    final questionData = _questions![_currentIndex];
    final questionText = questionData['question'] ?? "Default question text";
    final options = questionData['options'] as List<String>;

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
                          _selectedOptions[_currentIndex] = firstOptionIndex;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedOptions[_currentIndex] == firstOptionIndex
                            ? Colors.blue
                            : const Color.fromARGB(255, 233, 233, 233),
                        padding: EdgeInsets.all(widget.screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        options[firstOptionIndex],
                        style: TextStyle(
                          fontSize: baseFontSize * 2,
                          color: _selectedOptions[_currentIndex] == firstOptionIndex
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
                            _selectedOptions[_currentIndex] = secondOptionIndex;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedOptions[_currentIndex] == secondOptionIndex
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
                            color: _selectedOptions[_currentIndex] == secondOptionIndex
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
                  : () => Navigator.pushReplacementNamed(context, '/resultsPage'),
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
    );
  }
}
