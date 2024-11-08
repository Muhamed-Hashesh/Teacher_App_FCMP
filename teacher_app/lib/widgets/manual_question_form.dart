import 'package:flutter/material.dart';

class ManualQuestionForm extends StatefulWidget {
  final String? selectedFileName;

  const ManualQuestionForm({
    Key? key,
    required this.selectedFileName,
  }) : super(key: key);

  @override
  _ManualQuestionFormState createState() => _ManualQuestionFormState();
}

class _ManualQuestionFormState extends State<ManualQuestionForm> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController1 = TextEditingController();
  final _answerController2 = TextEditingController();
  final _answerController3 = TextEditingController();
  final _answerController4 = TextEditingController();
  String? _selectedCorrectAnswer;

  @override
  void dispose() {
    _questionController.dispose();
    _answerController1.dispose();
    _answerController2.dispose();
    _answerController3.dispose();
    _answerController4.dispose();
    super.dispose();
  }

  OutlineInputBorder _customBorder(Color borderColor) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 2.0),
      borderRadius: BorderRadius.circular(12.0),
    );
  }

  Map<String, dynamic> _getQuestionData() {
    return {
      'question_name': _questionController.text,
      'A': _answerController1.text,
      'B': _answerController2.text,
      'C': _answerController3.text,
      'D': _answerController4.text,
      'correct_answer': _selectedCorrectAnswer,
      'unit': widget.selectedFileName,
    };
  }

  void _submitQuestion() {
    if (_formKey.currentState!.validate()) {
      final questionData = _getQuestionData();
      Navigator.of(context).pop(questionData); // Return data to parent
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Question Name
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: 'Question Name',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 1, 151, 168),
                  ),
                  enabledBorder: _customBorder(
                    const Color.fromARGB(255, 218, 218, 218),
                  ),
                  focusedBorder: _customBorder(
                    const Color.fromARGB(255, 1, 151, 168),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Answers A and B
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _answerController1,
                      decoration: InputDecoration(
                        labelText: 'A',
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 1, 151, 168),
                        ),
                        enabledBorder: _customBorder(
                          const Color.fromARGB(255, 218, 218, 218),
                        ),
                        focusedBorder: _customBorder(
                          const Color.fromARGB(255, 1, 151, 168),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter answer A';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _answerController2,
                      decoration: InputDecoration(
                        labelText: 'B',
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 1, 151, 168),
                        ),
                        enabledBorder: _customBorder(
                          const Color.fromARGB(255, 218, 218, 218),
                        ),
                        focusedBorder: _customBorder(
                          const Color.fromARGB(255, 1, 151, 168),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter answer B';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Answers C and D
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _answerController3,
                      decoration: InputDecoration(
                        labelText: 'C',
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 1, 151, 168),
                        ),
                        enabledBorder: _customBorder(
                          const Color.fromARGB(255, 218, 218, 218),
                        ),
                        focusedBorder: _customBorder(
                          const Color.fromARGB(255, 1, 151, 168),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter answer C';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _answerController4,
                      decoration: InputDecoration(
                        labelText: 'D',
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 1, 151, 168),
                        ),
                        enabledBorder: _customBorder(
                          const Color.fromARGB(255, 218, 218, 218),
                        ),
                        focusedBorder: _customBorder(
                          const Color.fromARGB(255, 1, 151, 168),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter answer D';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Correct Answer Radio Buttons
              FormField<String>(
                validator: (value) {
                  if (_selectedCorrectAnswer == null ||
                      _selectedCorrectAnswer!.isEmpty) {
                    return 'Please select the correct answer';
                  }
                  return null;
                },
                builder: (FormFieldState<String> state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Correct Answer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 1, 151, 168),
                        ),
                      ),
                      Row(
                        children: ['A', 'B', 'C', 'D'].map((option) {
                          return Expanded(
                            child: Row(
                              children: [
                                Radio<String>(
                                  activeColor:
                                      const Color.fromARGB(255, 1, 151, 168),
                                  value: option,
                                  groupValue: _selectedCorrectAnswer,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedCorrectAnswer = value;
                                      state.didChange(value);
                                    });
                                  },
                                ),
                                Text(
                                  option,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                          child: Text(
                            state.errorText ?? '',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 1, 151, 168),
                  ),
                  child: const Text(
                    'Submit Question',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
