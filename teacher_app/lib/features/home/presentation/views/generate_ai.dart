import 'package:flutter/material.dart';
import 'package:teacher_app/features/quiz/presentation/views/live_exam.dart';
import 'package:teacher_app/question_generator.dart';
import 'package:teacher_app/widgets/ai_generated_question.dart';
import 'package:teacher_app/widgets/manual_question_form.dart';


class GeneratePage extends StatefulWidget {
  const GeneratePage({super.key});

  @override
  GeneratePageState createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {
  final List<Map<String, dynamic>> _manuallyAddedQuestions = [];
  final List<bool> _isCorrectAnswerVisible = [];
  bool generateQuestions = false;
  bool isGenerateMoreQuestions = false;
  bool _isLoading = false;
  List<Map<String, dynamic>> questions_AI = [];
  String _subject = '';

  Future<void> _fetchQuestions() async {
    if (_subject.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a subject')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      questions_AI = [];
    });

    try {
      List<Map<String, dynamic>> questions =
      await QuestionGenerator.generateQuestions(_subject);
      setState(() {
        questions_AI = questions;
        generateQuestions = true;
        isGenerateMoreQuestions = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error generating questions')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    double horizontalPadding = screenWidth * 0.05;
    double verticalPadding = screenHeight * 0.02;
    double fontSize = screenWidth * 0.045;
    double buttonFontSize = screenWidth * 0.04;

    fontSize = fontSize.clamp(14.0, 20.0);
    buttonFontSize = buttonFontSize.clamp(12.0, 18.0);

    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Colors.white,
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 151, 168),
        title: Text(
          "Generate Quiz using AI",
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Which lesson or topic do you want the questions to be about?",
              style: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: verticalPadding),
            Container(
              height: screenHeight * 0.1,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Outline lesson or topic",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: fontSize * 0.9,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    _subject = value;
                  },
                ),
              ),
            ),
            SizedBox(height: verticalPadding * 2),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _fetchQuestions,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: verticalPadding),
                    backgroundColor: const Color.fromARGB(255, 1, 151, 168),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Generate Questions Using AI",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: verticalPadding * 2),
            if (generateQuestions)
              ...List.generate(questions_AI.length, (index) {
                final question = questions_AI[index];
                final options = question['options'] as List<String>;
                return AiGeneratedQuestion(
                  question: question['question'],
                  options: options,
                  correctAnswer: question['answer'],
                  questionNumber: index,
                  selectedListItem: question['selected'],
                  onSelectionChanged: (bool isSelected) {
                    setState(() {
                      question['selected'] = isSelected;
                    });
                  },
                );
              }),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        generateQuestions = false;
                        isGenerateMoreQuestions = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding / 2,
                          vertical: verticalPadding),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Text(
                      "Generate more questions",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: horizontalPadding / 2),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final questionData =
                      await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (BuildContext context) {
                          return const ManualQuestionForm(
                            selectedFileName: '',
                          );
                        },
                      );

                      if (questionData != null) {
                        setState(() {
                          _manuallyAddedQuestions.add(questionData);
                          _isCorrectAnswerVisible.add(false);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding / 2,
                          vertical: verticalPadding * 1.66),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Text(
                      "Ask Manually",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: verticalPadding * 2),
            if (isGenerateMoreQuestions)
              ...questions_AI
                  .where((question) => question['selected'] == true)
                  .map((question) {
                final options = question['options'] as List<String>;
                return AiGeneratedQuestion(
                  question: question['question'],
                  options: options,
                  correctAnswer: question['answer'],
                  questionNumber: questions_AI.indexOf(question),
                  selectedListItem: question['selected'],
                  onSelectionChanged: (bool value) {},
                );
              }).toList(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LiveExam(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                  backgroundColor: const Color.fromARGB(255, 1, 151, 168),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Start Quiz",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: buttonFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (_manuallyAddedQuestions.isNotEmpty) ...[
              SizedBox(height: verticalPadding * 2),
              Text(
                "Questions:",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: verticalPadding),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _manuallyAddedQuestions.length,
                itemBuilder: (context, index) {
                  final question = _manuallyAddedQuestions[index];
                  final isCorrectAnswerVisible = _isCorrectAnswerVisible[index];
                  return QuestionCardgeneratingAi(
                    index: index,
                    questionData: question,
                    isCorrectAnswerVisible: isCorrectAnswerVisible,
                    onVisibilityToggle: () {
                      setState(() {
                        _isCorrectAnswerVisible[index] =
                        !_isCorrectAnswerVisible[index];
                      });
                    },
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}


class QuestionCardgeneratingAi extends StatelessWidget {
  final int index;
  final Map<String, dynamic> questionData;
  final bool isCorrectAnswerVisible;
  final VoidCallback onVisibilityToggle;

  const QuestionCardgeneratingAi({
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
