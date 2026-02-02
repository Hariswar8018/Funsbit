import 'dart:convert';
import 'package:earning_app/api.dart';
import 'package:earning_app/model/quiz.dart';
import 'package:googleai_dart/googleai_dart.dart';

class GeminiService {
  static late final GoogleAIClient _client;

  GeminiService() {
    _client = GoogleAIClient(
      config: GoogleAIConfig.googleAI(
        authProvider: ApiKeyProvider(Api.gemini),
      ),
    );
  }

  static Future<List<QuizQuestion>> fetchQuiz() async {
    try {
      final response = await _client.models.generateContent(
        model: "gemini-3-flash-preview",
        request: GenerateContentRequest(
          contents: [
            Content.text(
                """
Generate exactly 10 quiz questions.

Rules:
- Each must have 4 options
- One correct answer
- Provide correctIndex (0-3)

Return STRICT JSON ONLY:

[
  {
    "question": "text",
    "options": ["a","b","c","d"],
    "correctIndex": 0
  }
]
"""
            )
          ],
        ),
      );

      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception("Empty Gemini response");
      }

      final List decoded = jsonDecode(text);

      return decoded.map((e) => QuizQuestion.fromMap(e)).toList();
    } catch (e) {
      throw Exception("Gemini Quiz Generation Failed: $e");
    }
  }

  void dispose() {
    _client.close();
  }
}
