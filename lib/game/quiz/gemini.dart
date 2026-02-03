import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:earning_app/model/quiz.dart';

class FirebaseGeminiService {
  static GenerativeModel get _model {
    final ai = FirebaseAI.googleAI(
      auth: FirebaseAuth.instance,
    );

    return ai.generativeModel(
      model: 'gemini-2.5-flash', // ✅ latest, supported
    );
  }

  static Future<List<QuizQuestion>> fetchQuiz() async {
    try {
      final prompt = '''
Generate exactly 10 quiz questions.

Rules:
- Each question has 4 options
- One correct answer
- correctIndex must be 0-3
- Return STRICT JSON ONLY (no markdown)

Format:
[
  {
    "question": "text",
    "options": ["a","b","c","d"],
    "correctIndex": 0
  }
]
''';

      final response =
      await _model.generateContent([Content.text(prompt)]);

      final text = response.text?.trim();
      if (text == null || text.isEmpty) return [];

      final cleaned = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final List decoded = jsonDecode(cleaned);
      return decoded.map((e) => QuizQuestion.fromMap(e)).toList();
    } catch (e) {
      print('🔥 Firebase Gemini failed: $e');
      return [];
    }
  }
}
