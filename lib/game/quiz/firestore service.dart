import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:earning_app/model/quiz.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> saveQuiz(List<QuizQuestion> quiz) async {
    for (var q in quiz) {
      await _db.collection("Quiz").add(q.toMap());
    }
  }

  static Future<List<QuizQuestion>> fetchRandomQuiz() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("quiz")
        .limit(10)
        .get();

    if (snapshot.docs.isEmpty) {
      return []; // 🔥 NEVER throw
    }

    return snapshot.docs
        .map((d) => QuizQuestion.fromMap(d.data()))
        .toList();
  }

}
