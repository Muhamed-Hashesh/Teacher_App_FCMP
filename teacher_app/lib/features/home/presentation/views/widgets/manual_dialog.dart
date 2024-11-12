import 'package:flutter/material.dart';

class QuestionCardGeneratingAi extends StatelessWidget {
  final int index;
  final Map<String, dynamic> questionData;
  final bool isCorrectAnswerVisible;
  final VoidCallback onVisibilityToggle;

  const QuestionCardGeneratingAi({
    super.key,
    required this.index,
    required this.questionData,
    required this.isCorrectAnswerVisible,
    required this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Extract data from questionData
    final String questionText = questionData['question_name'] ?? '';
    final String optionA = questionData['A'] ?? '';
    final String optionB = questionData['B'] ?? '';
    final String optionC = questionData['C'] ?? '';
    final String optionD = questionData['D'] ?? '';
    final String correctAnswer = questionData['correct_answer'] ?? '';

    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color.fromARGB(255, 219, 219, 219),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the numbered question
            Text(
              "${index + 1}. $questionText",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            // Display the options labeled as A, B, C, D
            Text("A. $optionA"),
            Text("B. $optionB"),
            Text("C. $optionC"),
            Text("D. $optionD"),
            // Display the correct answer if visible
            if (isCorrectAnswerVisible) ...[
              const SizedBox(height: 8.0),
              Text(
                "Correct Answer: $correctAnswer",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            isCorrectAnswerVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onVisibilityToggle,
        ),
      ),
    );
  }
}