import 'dart:async';
import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class TetrisGame extends FlameGame with TapDetector, PanDetector {
  final VoidCallback onWin;

  static const int rows = 20;
  static const int cols = 10;

  late List<List<int>> grid;

  Vector2 blockSize = Vector2(25, 25);

  double timer = 0;

  int score = 0;

  late Tetromino current;

  TetrisGame({required this.onWin});

  @override
  Future<void> onLoad() async {
    grid = List.generate(
      rows,
          (_) => List.generate(cols, (_) => 0),
    );

    spawnBlock();
  }

  // Spawn new block
  void spawnBlock() {
    current = Tetromino.random();
    current.x = cols ~/ 2;
    current.y = 0;
  }
  bool fastDrop = false;

  @override
  void update(double dt) {
    super.update(dt);

    timer += dt;

    // Normal speed = 1s
    // Fast speed = 0.1s
    double speed = fastDrop ? 0.1 : 1.0;

    if (timer > speed) {
      timer = 0;
      moveDown();
    }
  }


  void moveDown() {
    if (!collision(current.x, current.y + 1)) {
      current.y++;
    } else {
      fixBlock();
      clearLines();
      spawnBlock();
    }
  }
  @override
  void onPanUpdate(DragUpdateInfo info) {
    final delta = info.delta.global;

    // Horizontal swipe
    if (delta.x.abs() > delta.y.abs()) {
      if (delta.x > 5) {
        moveRight();
      } else if (delta.x < -5) {
        moveLeft();
      }
    }

    // Vertical swipe (down)
    if (delta.y > 5) {
      fastDrop = true;
    }
  }
  @override
  void onPanEnd(DragEndInfo info) {
    fastDrop = false;
  }
  @override
  void onTapDown(TapDownInfo info) {
    rotate();
  }
  void moveLeft() {
    if (!collision(current.x - 1, current.y)) {
      current.x--;
    }
  }
  void moveRight() {
    if (!collision(current.x + 1, current.y)) {
      current.x++;
    }
  }

  bool collision(int x, int y) {
    for (var p in current.shape) {
      int nx = x + p.x.toInt();
      int ny = y + p.y.toInt();


      if (nx < 0 || nx >= cols || ny >= rows) return true;

      if (ny >= 0 && grid[ny][nx] == 1) return true;
    }

    return false;
  }

  void fixBlock() {
    for (var p in current.shape) {
      int x = current.x + p.x.toInt();
      int y = current.y + p.y.toInt();


      if (y >= 0) grid[y][x] = 1;
    }
  }

  void clearLines() {
    for (int i = rows - 1; i >= 0; i--) {
      if (grid[i].every((c) => c == 1)) {
        grid.removeAt(i);
        grid.insert(0, List.filled(cols, 0));

        score += 100;

        // Win condition
        if (score >= 500) {
          onWin();
          pauseEngine();
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()..color = Colors.blue;

    // Draw grid
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        if (grid[y][x] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              x * blockSize.x,
              y * blockSize.y,
              blockSize.x,
              blockSize.y,
            ),
            paint,
          );
        }
      }
    }

    // Draw current block
    for (var p in current.shape) {
      canvas.drawRect(
        Rect.fromLTWH(
          (current.x + p.x) * blockSize.x,
          (current.y + p.y) * blockSize.y,
          blockSize.x,
          blockSize.y,
        ),
        paint,
      );
    }
  }
  void rotate() {
    final oldShape = List<Vector2>.from(current.shape);

    current.rotate();

    if (collision(current.x, current.y)) {
      current.shape = oldShape;
    }
  }

}



class Tetromino {
  List<Vector2> shape;
  int x = 0;
  int y = 0;

  Tetromino(this.shape);

  static final _random = Random();

  static Tetromino random() {
    final shapes = [
      // Square
      [
        Vector2(0, 0),
        Vector2(1, 0),
        Vector2(0, 1),
        Vector2(1, 1),
      ],

      // Line
      [
        Vector2(0, 0),
        Vector2(1, 0),
        Vector2(2, 0),
        Vector2(3, 0),
      ],

      // L
      [
        Vector2(0, 0),
        Vector2(0, 1),
        Vector2(0, 2),
        Vector2(1, 2),
      ],
    ];

    return Tetromino(
      List.from(shapes[_random.nextInt(shapes.length)]),
    );
  }

  // Rotate 90 degrees
  void rotate() {
    shape = shape
        .map((p) => Vector2(-p.y, p.x))
        .toList();
  }
}
