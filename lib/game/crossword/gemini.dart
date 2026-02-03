import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCrosswordGemini {
  static GenerativeModel get _model {
    final ai = FirebaseAI.googleAI(auth: FirebaseAuth.instance);
    return ai.generativeModel(model: 'gemini-2.5-flash');
  }

  static Future<List<String>> generateWords() async {
    try {
      final prompt = '''
Generate 4 crossword words.
Rules:
- Uppercase only
- Length 2 to 8
- Simple English words
- Return JSON array ONLY

Example:
["FLUTTER","GAMES","UI","COLORS"]
''';

      final res = await _model.generateContent([Content.text(prompt)]);
      final text = res.text ?? '[]';

      final cleaned = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return List<String>.from(jsonDecode(cleaned));
    } catch (_) {
      // fallback words
      return ["FLUTTER", "GAMES", "UI", "COLORS"];
    }
  }
}
