// excel_data_list.dart

import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> questionData;
  final bool isSelected;
  final bool isCorrectAnswerVisible;
  final ValueChanged<bool?> onCheckboxChanged;
  final VoidCallback onVisibilityToggle;

  const QuestionCard({
    super.key,
    required this.index,
    required this.questionData,
    required this.isSelected,
    required this.isCorrectAnswerVisible,
    required this.onCheckboxChanged,
    required this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Number the questions
    final String questionNumber = (index + 1).toString();

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
        leading: Checkbox(
          activeColor: const Color.fromARGB(255, 1, 151, 168),
          value: isSelected,
          onChanged: onCheckboxChanged,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the numbered question
            Text(
              "$questionNumber. $questionText",
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
