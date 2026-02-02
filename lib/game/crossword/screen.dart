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

  final List<String> hints = ["FLUTTER", "GAMES", "UI", "COLORS"];

  final List<List<String>> letters = const [
    ["F","L","U","T","T","E","R"],
    ["G","A","M","E","S","A","B"],
    ["U","I","C","D","E","F","G"],
    ["C","O","L","O","R","S","X"],
  ];

  final Set<String> solvedWords = {};

  void onLineUpdate(String word, List<String> words, bool completed) {

    if (completed) {
      setState(() {
        attempts++;
        if (hints.contains(word)) {
          solvedWords.add(word);
        }
      });

      if (solvedWords.length == hints.length) {
        redeemCoins();
      }
    }
  }

  void redeemCoins() {
    setState(() {
      coins += 50;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🎉 Puzzle Completed! +50 coins")),
    );
  }

  void resetGame() {
    setState(() {
      attempts = 0;
      solvedWords.clear();
      gameNumber++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crossword Game"),
        centerTitle: true,
      ),
      body: Column(
        children: [

          const SizedBox(height: 10),

          /// 📊 STATS BAR
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

          /// 🧩 CROSSWORD CENTER
          Expanded(
            child: Center(
              child: Crossword(
                letters: letters,
                spacing: const Offset(40, 40),
                hints: hints,

                onLineUpdate: onLineUpdate,

                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),

                /// ⚠ REQUIRED PARAMETER
                lineDecoration: const LineDecoration(
                  lineGradientColors: [
                    [Colors.blue, Colors.purple],
                    [Colors.orange, Colors.red],
                  ],

                  correctGradientColors: [Colors.green, Colors.lightGreen],
                  incorrectGradientColors: [Colors.red, Colors.orange],
                  strokeWidth: 22,

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

          /// 🎮 CONTROLS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              ElevatedButton(
                onPressed: resetGame,
                child: const Text("NEW GAME"),
              ),

              const SizedBox(width: 20),

              ElevatedButton(
                onPressed: solvedWords.length == hints.length
                    ? redeemCoins
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text("REDEEM"),
              ),
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
