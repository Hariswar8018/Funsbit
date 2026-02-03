import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrosswordFirestoreService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> saveGame({
    required int gameNumber,
    required int coins,
    required List<String> hints,
    required List<List<String>> letters,
    required Set<String> solvedWords,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _db.collection("crossword_games").doc(uid).set({
      "gameNumber": gameNumber,
      "coins": coins,
      "hints": hints,
      "letters": letters,
      "solvedWords": solvedWords.toList(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  static Future<Map<String, dynamic>?> loadGame() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await _db.collection("crossword_games").doc(uid).get();
    return doc.data();
  }
}
