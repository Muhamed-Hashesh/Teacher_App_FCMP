import 'package:flutter/material.dart';

class AiGeneratedQuestion extends StatefulWidget {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final int questionNumber;
  bool? selectedListItem;
  final ValueChanged<bool> onSelectionChanged;

  AiGeneratedQuestion({
    super.key,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.questionNumber,
    this.selectedListItem = true,
    required this.onSelectionChanged,
  });

  @override
  AiGeneratedQuestionState createState() => AiGeneratedQuestionState();
}

class AiGeneratedQuestionState extends State<AiGeneratedQuestion> {
  bool _isSelected = true;
  bool _showCorrectAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                activeColor: const Color.fromARGB(255, 1, 151, 168),
                value: widget.selectedListItem,
                onChanged: (value) {
                  setState(() {
                    _isSelected = value ?? false;
                    widget.selectedListItem = _isSelected;
                    widget.onSelectionChanged(_isSelected);
                  });
                },
              ),
              Expanded(
                child: Text(
                  'Q${widget.questionNumber + 1}: ${widget.question}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isSelected ? Colors.black : Colors.grey,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _showCorrectAnswer ? Icons.visibility_off : Icons.visibility,
                  color: _showCorrectAnswer ? Colors.green : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _showCorrectAnswer = !_showCorrectAnswer;
                  });
                },
              ),
            ],
          ),
          ...widget.options.asMap().entries.map(
            (entry) {
              int index = entry.key;
              String option = entry.value;
              String label = String.fromCharCode(65 + index);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  '\t\t\t\t\t\t\t\t\t\t\t $label: $option',
                  style: TextStyle(
                    color: _isSelected ? Colors.black : Colors.grey,
                  ),
                ),
              );
            },
          ),
          if (_showCorrectAnswer)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Correct Answer: ${widget.correctAnswer}',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
