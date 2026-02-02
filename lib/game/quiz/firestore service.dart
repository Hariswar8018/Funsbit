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
    final snapshot = await _db.collection("Quiz").get();

    if (snapshot.docs.length < 10) {
      throw Exception("Not enough Firestore quiz");
    }

    final all = snapshot.docs
        .map((e) => QuizQuestion.fromMap(e.data()))
        .toList();

    all.shuffle(Random());

    return all.take(10).toList();
  }
}
