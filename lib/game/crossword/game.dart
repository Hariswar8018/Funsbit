import 'dart:math';

import 'package:earning_app/game/crossword/firestore.dart';
import 'package:earning_app/game/crossword/gemini.dart';
import 'package:flutter/material.dart';

class CustomCrossword extends StatefulWidget {
  const CustomCrossword({super.key});

  @override
  State<CustomCrossword> createState() => _CustomCrosswordState();
}

class _CustomCrosswordState extends State<CustomCrossword> {
  static const int rows = 6;
  static const int cols = 6;

  final List<String> words = ["FLUTTER", "GAME", "UI"];
  final Set<String> solved = {};

  late List<List<Cell>> grid;

  Cell? startCell;
  Cell? endCell;

  @override
  void initState() {
    super.initState();
    loadGame();
  }

  Future<void> loadGame() async {
    final result = await CrosswordLoader.load();

    setState(() {
      words
        ..clear()
        ..addAll(result.words);

      grid = List.generate(6, (r) {
        return List.generate(6, (c) {
          return Cell(r, c, result.matrix[r][c]);
        });
      });
    });
  }

  void generateGrid() {
    final rand = Random();
    grid = List.generate(rows, (r) {
      return List.generate(cols, (c) {
        return Cell(
          r,
          c,
          String.fromCharCode(65 + rand.nextInt(26)),
        );
      });
    });
  }

  Offset snap(Offset p) {
    final size = MediaQuery.of(context).size.width / cols;
    return Offset(
      (p.dx ~/ size) * size + size / 2,
      (p.dy ~/ size) * size + size / 2,
    );
  }
  Cell? currentCell;
  Offset cellToOffset(Cell cell, double cellSize) {
    return Offset(
      cell.col * cellSize + cellSize / 2,
      cell.row * cellSize + cellSize / 2,
    );
  }
  void checkWord() {
    if (selectedCells.isEmpty) return;

    final word =
    selectedCells.map((c) => c.letter).join();

    if (words.contains(word)) {
      setState(() {
        solved.add(word);
        coins += 10; // 🔥 update coins
      });
    } else {
      setState(() {
        selectedCells.clear();
      });
    }
  }
  List<Cell> selectedCells = [];
  bool isHorizontal = false;
  bool isVertical = false;

  int coins = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Crossword : ${words.toString()}")),
      body: GestureDetector(
        onPanStart: (d) {
          final cell = getCell(d.localPosition);
          if (cell == null) return;

          setState(() {
            startCell = cell;
            selectedCells = [cell];
            isHorizontal = false;
            isVertical = false;
          });
        },

        onPanUpdate: (d) {
          if (startCell == null) return;

          final cell = getCell(d.localPosition);
          if (cell == null) return;

          final dr = cell.row - startCell!.row;
          final dc = cell.col - startCell!.col;

          // Lock direction
          if (!isHorizontal && !isVertical) {
            if (dr.abs() > dc.abs()) {
              isVertical = true;
            } else {
              isHorizontal = true;
            }
          }

          final cells = <Cell>[];

          if (isHorizontal) {
            final row = startCell!.row;
            final start = min(startCell!.col, cell.col);
            final end = max(startCell!.col, cell.col);
            for (int c = start; c <= end; c++) {
              cells.add(grid[row][c]);
            }
          }

          if (isVertical) {
            final col = startCell!.col;
            final start = min(startCell!.row, cell.row);
            final end = max(startCell!.row, cell.row);
            for (int r = start; r <= end; r++) {
              cells.add(grid[r][col]);
            }
          }

          setState(() => selectedCells = cells);
        },

        onPanEnd: (_) => checkWord(),

        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
          ),
          itemCount: rows * cols,
          itemBuilder: (context, index) {
            final r = index ~/ cols;
            final c = index % cols;
            final cell = grid[r][c];

            final selected = selectedCells.contains(cell);
            final solvedCell =
            solved.any((w) => w.contains(cell.letter));

            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.all(4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: solvedCell
                    ? Colors.green.shade700
                    : selected
                    ? Colors.greenAccent.withOpacity(0.7)
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(6),
              ),
              child: AnimatedScale(
                scale: (selected || solvedCell) ? 1.3 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Text(
                  cell.letter,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Offset? start;
  Offset? current;
  void _startDraw(DragStartDetails d) {
    setState(() {
      start = d.localPosition;
      current = start;
    });
  }

  void _updateDraw(DragUpdateDetails d) {
    setState(() {
      current = d.localPosition;
    });
  }

  void _endDraw(DragEndDetails d) {
    setState(() {
      start = null;
      current = null;
    });
  }


  Cell? getCell(Offset pos) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return null;

    final size = box.size.width / cols;
    final col = (pos.dx / size).floor();
    final row = (pos.dy / size).floor();

    if (row < 0 || col < 0 || row >= rows || col >= cols) return null;
    return grid[row][col];
  }
}

class CrosswordLoader {
  static Future<CrosswordAIResult> load() async {
    try {
      // 1️⃣ Try Gemini
      final ai = await FirebaseCrosswordGemini.generateCrossword();

      // 2️⃣ Cache result
      await CrosswordFirestoreService.saveCrossword(ai);

      return ai;
    } catch (e) {
      debugPrint("Gemini failed, loading Firestore");

      // 3️⃣ Firestore fallback
      final cached =
      await CrosswordFirestoreService.loadCrossword();

      if (cached != null) return cached;

      // 4️⃣ Hard fallback
      return CrosswordAIResult(
        matrix: List.generate(
          6,
              (_) => List.generate(6, (_) => "A"),
        ),
        words: ["FLUTTER", "GAME", "UI", "THEMATRIX"],
      );
    }
  }
}

class LinePainter extends CustomPainter {
  final Cell? start;
  final Cell? end;
  final double cellSize;

  LinePainter(this.start, this.end, this.cellSize);

  @override
  void paint(Canvas canvas, Size size) {
    if (start == null || end == null) return;

    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final p1 = Offset(
      start!.col * cellSize + cellSize / 2,
      start!.row * cellSize + cellSize / 2,
    );

    final p2 = Offset(
      end!.col * cellSize + cellSize / 2,
      end!.row * cellSize + cellSize / 2,
    );

    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}

class Cell {
  final int row;
  final int col;
  final String letter;

  Cell(this.row, this.col, this.letter);
}
