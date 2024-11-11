import 'dart:convert';
import 'package:http/http.dart' as http;

class QuestionsAI {
  static Future<List<Map<String, dynamic>>> fetchAiQuestions(String topic) async {
    final url = 'https://your-ai-api-endpoint.com/generate_questions';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'topic': topic}),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((question) => {
        "question": question['question'],
        "options": question['options'],
        "correctAnswer": question['correctAnswer'],
        "selected": false,
      }).toList();
    } else {
      throw Exception('Failed to load AI questions');
    }
  }
}
