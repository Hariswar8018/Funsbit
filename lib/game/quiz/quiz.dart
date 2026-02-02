import 'package:earning_app/game/quiz/firestore%20service.dart';
import 'package:earning_app/game/quiz/gemini.dart';
import 'package:earning_app/model/quiz.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuizQuestion> quiz = [];

  int current = 0;
  int correct = 0;
  int wrong = 0;

  bool loading = true;
  bool answered = false;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    loadQuiz();
  }

  Future<void> loadQuiz() async {
    try {
      final geminiQuiz = await GeminiService.fetchQuiz();
      quiz = geminiQuiz;

      await FirestoreService.saveQuiz(geminiQuiz);
    } catch (e) {
      quiz = await FirestoreService.fetchRandomQuiz();
    }

    setState(() {
      loading = false;
    });
  }

  void selectAnswer(int index) {
    if (answered) return;

    setState(() {
      answered = true;
      selectedIndex = index;

      if (index == quiz[current].correctIndex) {
        correct++;
      } else {
        wrong++;
      }
    });

    Future.delayed(const Duration(seconds: 1), nextQuestion);
  }

  void nextQuestion() {
    if (current < quiz.length - 1) {
      setState(() {
        current++;
        answered = false;
        selectedIndex = -1;
      });
    } else {
      reward(correct);
    }
  }

  void reward(int i) {
    debugPrint("User got $i correct answers!");
  }

  Color optionColor(int index) {
    if (!answered) return Colors.blue;

    if (index == quiz[current].correctIndex) {
      return Colors.green;
    }

    if (index == selectedIndex) {
      return Colors.red;
    }

    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final q = quiz[current];

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz ${current + 1}/${quiz.length}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              q.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ...List.generate(4, (index) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: optionColor(index),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () => selectAnswer(index),
                  child: Text(
                    q.options[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),

            const Spacer(),

            Text(
              "Correct: $correct   Wrong: $wrong",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
