import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuestionGenerator {
  // Function to generate questions
  static Future<List<Map<String, dynamic>>> generateQuestions(String subject) async {
    String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('OpenAI API key not found');
    }

    String prompt = '''
Generate 10 multiple-choice questions about "$subject". For each question, provide:
- "question": The question text
- "options": An array of four options
- "answer": The correct answer

Format the response as a JSON array of objects.

Example:
[
  {
    "question": "What is the capital of France?",
    "options": ["Paris", "London", "Berlin", "Rome"],
    "answer": "Paris",
  },
  ...
]
''';

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 1000,
        'n': 1,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String content = data['choices'][0]['message']['content'];

      // Parse the content to JSON
      List<dynamic> questionsJson = jsonDecode(content);

      // Convert to List<Map<String, dynamic>>
      List<Map<String, dynamic>> questions = questionsJson.map((q) {
        return {
          'question': q['question'],
          'options': List<String>.from(q['options']),
          'answer': q['answer'],
        };
      }).toList();

      return questions;
    } else {
      throw Exception('Failed to generate questions');
    }
  }
}
