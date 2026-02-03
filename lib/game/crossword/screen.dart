import 'dart:math' show Random;

import 'package:earning_app/game/crossword/firestore.dart';
import 'package:earning_app/game/crossword/gemini.dart';
import 'package:earning_app/global/color.dart';
import 'package:earning_app/global/widget.dart';
import 'package:flutter/material.dart';
import 'package:crossword/crossword.dart';

class CrosswordGamee extends StatefulWidget {
  const CrosswordGamee({super.key});

  @override
  State<CrosswordGamee> createState() => _CrosswordGameState();
}

class _CrosswordGameState extends State<CrosswordGamee> {

  int attempts = 0;
  int gameNumber = 1;
  int coins = 0;

  late  List<String> hints = [];

  late List<List<String>> letters;

  final int rows = 6;
  final int cols = 11; // bigger grid

  @override
  void initState() {
    super.initState();
    loadGame();
  }

  Future<void> loadGame() async {
    final saved = await CrosswordFirestoreService.loadGame();

    if (saved != null) {
      // ✅ ALWAYS prefer Firestore
      setState(() {
        gameNumber = saved["gameNumber"];
        coins = saved["coins"];
        hints = List<String>.from(saved["hints"]);
        solvedWords.clear();
        solvedWords.addAll(List<String>.from(saved["solvedWords"]));
        letters = List<List<String>>.from(
          saved["letters"].map((r) => List<String>.from(r)),
        );
        attempts = solvedWords.length;
      });
    } else {
      // ❌ No saved game → only now try Gemini
      await startNewGame();
    }
  }
  Future<void> saveGame() async {
    await CrosswordFirestoreService.saveGame(
      gameNumber: gameNumber,
      coins: coins,
      hints: hints,
      letters: letters,
      solvedWords: solvedWords,
    );
  }
  void onLineUpdate(String word, List<String> words, bool completed) async {
    if (completed && hints.contains(word) && !solvedWords.contains(word)) {
      setState(() {
        solvedWords.add(word);
        attempts++;
        coins += 10;
      });

      await saveGame();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ $word found! +10 coins")),
      );
    }
  }

  Future<void> startNewGame() async {
    List<String> words;

    try {
      words = await FirebaseCrosswordGemini.generateWords();
    } catch (_) {
      // 🔴 Gemini failed → use last saved words or defaults
      words = ["FLUTTER", "GAMES", "UI", "COLORS"];
    }

    final random = Random();
    letters = List.generate(rows, (_) {
      return List.generate(cols, (_) {
        return String.fromCharCode(65 + random.nextInt(26));
      });
    });

    setState(() {
      hints = words;
      solvedWords.clear();
      attempts = 0;
      gameNumber++;
    });

    await saveGame(); // 🔥 SAVE GENERATED DATA
  }


  void generateGrid() {
    final random = Random();

    letters = List.generate(rows, (r) {
      return List.generate(cols, (c) {
        return String.fromCharCode(65 + random.nextInt(26)); // A-Z
      });
    });
  }


  final Set<String> solvedWords = {};


  void resetGame() {
    setState(() {
      attempts = 0;
      solvedWords.clear();
      gameNumber++;
      generateGrid();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColor.black,
      body: Column(
        children: [
          GlobalWidget.appbar(context, "Crossword Game"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              stat("Attempts", attempts),
              stat("Game", gameNumber),
              stat("Coins", coins),
              stat("Solved", "${solvedWords.length}/${hints.length}"),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Crossword(
                letters: letters,
                spacing: const Offset(40, 40),
                hints: hints,

                onLineUpdate: onLineUpdate,

                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),

                lineDecoration: const LineDecoration(
                  lineGradientColors: [
                    [Colors.blue, Colors.purple],
                    [Colors.orange, Colors.red],
                  ],

                  correctGradientColors: [Colors.green, Colors.lightGreen],
                  incorrectGradientColors: [Colors.red, Colors.orange],
                  strokeWidth: 18,

                  lineTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                allowOverlap: false,
                addIncorrectWord: false,
              ),
            ),
          ),


          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: resetGame,
                child: const Text("NEW GAME"),
              ),
              const SizedBox(width: 20),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget stat(String label, dynamic value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value.toString(), style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
