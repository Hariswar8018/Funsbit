import 'package:earning_app/game/tetris/logic.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class TetrisScreen extends StatefulWidget {
  const TetrisScreen({super.key});

  @override
  State<TetrisScreen> createState() => _TetrisScreenState();
}

class _TetrisScreenState extends State<TetrisScreen> {
  int coins = 0;
  bool gameCompleted = false;
  bool fastDrop = false;

  late TetrisGame _game;

  @override
  void initState() {
    super.initState();

    _game = TetrisGame(
      onWin: _onGameWin,
    );
  }


  void _onGameWin() {
    _updateCoins();
    _loadNextGame();
  }

  void _updateCoins() {
    setState(() {
      coins += 10;
    });
  }

  void _loadNextGame() {
    setState(() {
      gameCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tetris"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text("🪙 $coins"),
          ),
        ],
      ),
      body: gameCompleted
          ? _buildNextGameUI()
          : GameWidget(game: _game),
    );
  }

  Widget _buildNextGameUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Level Completed 🎉",
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              setState(() {
                gameCompleted = false;
                _game = TetrisGame(onWin: _onGameWin);
              });
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }
}
