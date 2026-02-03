import 'dart:async';
import 'dart:math';

import 'package:flame/camera.dart' show FixedResolutionViewport;
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class TetrisGame extends FlameGame {
  final VoidCallback onWin;

  static const int rows = 13;
  static const int cols = 10;

  late List<List<Color?>> grid;

  Vector2 blockSize = Vector2(40, 40);

  double timer = 0;

  int score = 0;

  late Tetromino current;
  final VoidCallback onGameOver;

  TetrisGame({
    required this.onWin,
    required this.onGameOver,
  });

  late Vector2 worldSize;

  @override
  Future<void> onLoad() async {
    grid = List.generate(
      rows,
          (_) => List.generate(cols, (_) => null),
    );

    // ✅ Calculate exact board size
    worldSize = Vector2(
      cols * blockSize.x,
      rows * blockSize.y,
    );

    // ✅ FIXED viewport to board size
    camera.viewport = FixedResolutionViewport(
      resolution: worldSize,
    );

    spawnBlock();
  }




  // Spawn new block
  void spawnBlock() {
    current = Tetromino.random();
    current.x = (cols ~/ 2) - 1;
    current.y = 0;


    // GAME OVER CHECK
    if (collision(current.x, current.y)) {
      pauseEngine();
      onGameOver();
    }
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

      // wall or bottom
      if (nx < 0 || nx >= cols || ny >= rows) return true;

      // hit another block
      if (ny >= 0 && grid[ny][nx] != null) return true;
    }

    return false;
  }


  void fixBlock() {
    for (var p in current.shape) {
      int x = current.x + p.x.toInt();
      int y = current.y + p.y.toInt();

      if (y >= 0) {
        grid[y][x] = current.color;
      }
    }
  }


  void clearLines() {
    for (int i = rows - 1; i >= 0; i--) {

      // If every cell in row is filled (not null)
      if (grid[i].every((c) => c != null)) {

        grid.removeAt(i);
        grid.insert(0, List.filled(cols, null));

        score += 100;

        // WIN condition
        if (score >= 500) {
          onWin();
          pauseEngine();
        }

        i++; // recheck same row after shifting
      }
    }
  }

  void _drawGrid(Canvas canvas) {
    final linePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    for (int x = 0; x <= cols; x++) {
      canvas.drawLine(
        Offset(x * blockSize.x, 0),
        Offset(x * blockSize.x, rows * blockSize.y),
        linePaint,
      );
    }

    for (int y = 0; y <= rows; y++) {
      canvas.drawLine(
        Offset(0, y * blockSize.y),
        Offset(cols * blockSize.x, y * blockSize.y),
        linePaint,
      );
    }
  }


  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // BACKGROUND
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        cols * blockSize.x,
        rows * blockSize.y,
      ),
      Paint()..color = Colors.black.withOpacity(0.05),
    );

    _drawGrid(canvas);

    // Draw fixed blocks
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        final color = grid[y][x];
        if (color != null) {
          _drawBlock(canvas, x, y, color);
        }
      }
    }

    // Draw current block
    for (var p in current.shape) {
      _drawBlock(
        canvas,
        current.x + p.x.toInt(),
        current.y + p.y.toInt(),
        current.color,
      );
    }
  }
  void _drawBlock(Canvas canvas, int x, int y, Color color) {
    final rect = Rect.fromLTWH(
      x * blockSize.x,
      y * blockSize.y,
      blockSize.x,
      blockSize.y,
    );

    final paint = Paint()..color = color;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      paint,
    );

    // Highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(3),
        const Radius.circular(4),
      ),
      Paint()..color = Colors.white.withOpacity(0.2),
    );
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

  final Color color;

  Tetromino(this.shape, this.color);

  static final _random = Random();

  static Tetromino random() {
    final shapes = [
      [
        Vector2(0, 0),
        Vector2(1, 0),
        Vector2(0, 1),
        Vector2(1, 1),
      ],
      [
        Vector2(0, 0),
        Vector2(1, 0),
        Vector2(2, 0),
        Vector2(3, 0),
      ],
      [
        Vector2(0, 0),
        Vector2(0, 1),
        Vector2(0, 2),
        Vector2(1, 2),
      ],
    ];

    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.yellow,
    ];

    return Tetromino(
      List.from(shapes[_random.nextInt(shapes.length)]),
      colors[_random.nextInt(colors.length)],
    );
  }

  void rotate() {
    shape = shape.map((p) => Vector2(-p.y, p.x)).toList();
  }
}
