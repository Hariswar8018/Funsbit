import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseCrosswordGemini {
  static GenerativeModel get _model {
    final ai = FirebaseAI.googleAI(auth: FirebaseAuth.instance);
    return ai.generativeModel(model: 'gemini-2.5-flash');
  }

  static Future<CrosswordAIResult> generateCrossword() async {
    const prompt = '''
Generate a 6x6 crossword puzzle.

RULES:
- Return ONLY valid JSON
- Matrix must be 6 rows x 6 columns
- Each cell contains ONE uppercase letter
- Words must appear horizontally or vertically
- Include these words:
  - FLUTTER
  - GAME
  - UI
  - THEMATRIX
- THEMATRIX must be continuous (no spaces)
- Fill empty cells with random letters

Return JSON in this exact format:
{
  "matrix": [["A","B","C","D","E","F"]],
  "words": ["FLUTTER","GAME","UI","THEMATRIX"]
}
''';

    final res = await _model.generateContent([Content.text(prompt)]);
    final raw = res.text ?? '{}';

    final cleaned = raw
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    final data = jsonDecode(cleaned);

    return CrosswordAIResult.fromJson(data);
  }
}
class CrosswordAIResult {
  final List<List<String>> matrix;
  final List<String> words;

  CrosswordAIResult({
    required this.matrix,
    required this.words,
  });

  factory CrosswordAIResult.fromJson(Map<String, dynamic> json) {
    return CrosswordAIResult(
      matrix: (json['matrix'] as List)
          .map<List<String>>(
              (r) => List<String>.from(r))
          .toList(),
      words: List<String>.from(json['words']),
    );
  }
}
