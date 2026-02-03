import 'dart:async';
import 'package:earning_app/global/color.dart';
import 'package:earning_app/global/notify.dart';
import 'package:earning_app/global/widget.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/navigation/user/service/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'logic.dart';
import 'package:audioplayers/audioplayers.dart';

class TetrisScreen extends StatefulWidget {
  const TetrisScreen({super.key});

  @override
  State<TetrisScreen> createState() => _TetrisScreenState();
}

class _TetrisScreenState extends State<TetrisScreen> {
  int coins = 0;
  int secondsPlayed = 0;

  int buttonPressCount = 0;
  final AudioPlayer _player = AudioPlayer();

  late TetrisGame _game;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _game = TetrisGame(
      onWin: _onGameWin,
      onGameOver: _onGameOver,
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsPlayed++;

        // Every 10 seconds reward check
        if (secondsPlayed % 10 == 0) {
          if (buttonPressCount >= 2) {
            coins += 10;
          }

          buttonPressCount = 0; // reset activity counter
        }
      });
    });
  }

  void _onGameWin() {
    _timer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Level Completed 🎉"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Time Played: $secondsPlayed seconds"),
            Text("Coins Earned: 🪙 $coins"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartGame();
            },
            child: const Text("Next Round"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Close App"),
          ),
        ],
      ),
    );
  }

  void _restartGame() {
    setState(() {
      secondsPlayed = 0;
      buttonPressCount = 0;
      _game = TetrisGame(
        onWin: _onGameWin,
        onGameOver: _onGameOver,
      );

      _startTimer();
    });
  }
  Future<void> giveUserReward(int coinss) async {

    await TransactionService.updateTransaction(
        id: DateTime.now().toString(), name: 'Tetris Game Win', coins: coinss,
        status: 'Credited', debit: false, userId: GlobalUser.user.id
    );
    await Send.addcoins(context, coinss);
  }
  void _onGameOver(){
    _timer?.cancel();
    giveUserReward(coins);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Game Over ❌"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Coins Earned: 🪙 $coins"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartGame();
            },
            child: const Text("Restart"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Close Game"),
          ),
        ],
      ),
    );
  }


  void _registerAction() {
    buttonPressCount++;
  }
  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60; // integer division
    int seconds = totalSeconds % 60;

    String minStr = minutes.toString().padLeft(2, '0');
    String secStr = seconds.toString().padLeft(2, '0');

    return "$minStr:$secStr";
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: GlobalColor.gameback,
      body: Column(
        children: [
          GlobalWidget.appbar(context, "Tetris Game"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: w/3+40,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app_outlined),
                      Text("Time Played : ${formatTime(secondsPlayed)}",
                        style: TextStyle(fontWeight: FontWeight.w900),),
                    ],
                  ),
                ),
                Container(
                  width: w/3+40,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.diamond_outlined),
                      Text(" Coins : ${coins}",
                        style: TextStyle(fontWeight: FontWeight.w900),),
                    ],
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: TetrisGame.cols / TetrisGame.rows,
                child: GameWidget(game: _game),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _controlBtn("⬅", () {
                  _game.moveLeft();
                  _registerAction();
                }),

                _controlBtn("🔄", () {
                  _game.rotate();
                  _registerAction();
                }),
                _controlBtn("⬇", () {
                  _game.moveDown();
                  _registerAction();
                }),
                _controlBtn("➡", () {
                  _game.moveRight();
                  _registerAction();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlBtn(String text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Text(text, style: const TextStyle(fontSize: 20)),
    );
  }
}
