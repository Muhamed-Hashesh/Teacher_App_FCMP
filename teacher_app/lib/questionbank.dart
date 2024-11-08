import 'package:flutter/material.dart';
import 'package:teacher_app/live_exam.dart';
import 'package:teacher_app/widgets/custombutton.dart';
import 'package:teacher_app/widgets/customdropdown.dart';
import 'package:teacher_app/utils/quistions_ai.dart';
import 'package:teacher_app/widgets/ai_generated_question.dart';

class QuestionBankPage extends StatefulWidget {
  const QuestionBankPage({super.key});

  @override
  State<QuestionBankPage> createState() => _QuestionBankPageState();
}

class _QuestionBankPageState extends State<QuestionBankPage> {
  String? _selectedUnit;
  String? _selectedLesson;

  final List<String> _units = [
    'Unit 1: Introduction',
    'Unit 2: Basics',
    'Unit 3: Advanced Concepts',
    'Unit 4: Expert Topics'
  ];

  final List<String> _lessons = [
    'Lesson 1: Overview',
    'Lesson 2: Fundamentals',
    'Lesson 3: Applications',
    'Lesson 4: Deep Dive'
  ];
  bool generateQuestions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Colors.white,
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 151, 168),
        title: const Text(
          "Question Bank",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [

           Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reusable Dropdown for selecting unit with label
                  ReusableDropdown(
                    label: "Choose a unit     ",
                    items: _units,
                    selectedItem: _selectedUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedUnit = newValue;
                      });
                    }, hint: 'Choose a unit',
                  ),
                  const SizedBox(height: 17),

                  // Reusable Dropdown for selecting lesson with label
                  ReusableDropdown(
                    label: "Choose a lesson",
                    items: _lessons,
                    selectedItem: _selectedLesson,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLesson = newValue;
                      });
                    }, hint: 'Choose a lesson',
                  ),
                  const SizedBox(height: 24),

                  // Reusable Search Button
                  Center(
                    child: ReusableButton(
                      label: "Search",
                      onPressed: () {
                        // Handle search action
                      },
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reusable Add using AI and Add Manually Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReusableButton(
                        label: "Add using AI",
                        onPressed: () {
                          setState(() {
                            generateQuestions = true;
                          });
                        },
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                      ),
                      const SizedBox(width: 16), // Space between the buttons
                      ReusableButton(
                        label: "Add Manually",
                        onPressed: () {
                          // Handle add manually action
                        },
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),



          ... generateQuestions ? List.generate(aiQuestionsList.length, (index) {
            final question = aiQuestionsList[index];
            final options = question['options'] as List<String>;
            return AiGeneratedQuestion(question: question['question'], options: options, correctAnswer: question['correctAnswer'], questionNumber: index, onSelectionChanged: (bool value) {  },);
          }) : [],

          // Reusable Start Button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ReusableButton(
              label: "Start Quiz",
              onPressed: () {
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => LiveExam()));
              },
              backgroundColor: const Color.fromARGB(255, 1, 151, 168),
              textColor: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

