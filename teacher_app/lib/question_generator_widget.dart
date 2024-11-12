import 'package:flutter/material.dart';
import 'question_generator.dart';

class QuestionGeneratorWidget extends StatefulWidget {
  const QuestionGeneratorWidget({super.key});

  @override
  QuestionGeneratorWidgetState createState() => QuestionGeneratorWidgetState();
}

class QuestionGeneratorWidgetState extends State<QuestionGeneratorWidget> {
  String _subject = '';
  List<Map<String, dynamic>> questions_AI = [];
  bool _isLoading = false;

  Future<void> _generateQuestions() async {
    if (_subject.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a subject')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      questions_AI = [];
    });

    try {
      List<Map<String, dynamic>> questions = await QuestionGenerator.generateQuestions(_subject);
      setState(() {
        questions_AI = questions;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating questions')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildQuestionList() {
    if (questions_AI.isEmpty) {
      return Center(child: Text('No questions generated yet.'));
    }
    return ListView.builder(
      itemCount: questions_AI.length,
      itemBuilder: (context, index) {
        var question = questions_AI[index];
        print(questions_AI);
        return ExpansionTile(
          title: Text(question['question']),
          children: [
            ...question['options'].map<Widget>((option) {
              return ListTile(
                title: Text(option),
                leading: Radio<String>(
                  value: option,
                  groupValue: question['answer'],
                  onChanged: null, // Disabled, since we're just displaying
                ),
              );
            }).toList(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Correct Answer: ${question['answer']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Generator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter subject',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                _subject = text;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _generateQuestions,
              child: _isLoading ? CircularProgressIndicator() : Text('Generate Questions'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildQuestionList(),
            ),
          ],
        ),
      ),
    );
  }
}
