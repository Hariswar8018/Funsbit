import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/game/crossword/gemini.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrosswordFirestoreService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> saveCrossword(CrosswordAIResult data) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    await _db.collection("crossword_cache").doc(uid).set({
      "matrix": data.matrix,
      "words": data.words,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  static Future<CrosswordAIResult?> loadCrossword() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
    await _db.collection("crossword_cache").doc(uid).get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    return CrosswordAIResult.fromJson(data);
  }
}
