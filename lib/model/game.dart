class Games {
  final String id;
  final String name;
  final String image;
  final int totalplay;
  final int totalplaying;

  Games({
    required this.id,
    required this.name,
    required this.image,
    required this.totalplay,
    required this.totalplaying,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'totalplay': totalplay,
      'totalplaying': totalplaying,
    };
  }

  factory Games.fromMap(Map<String, dynamic> map) {
    return Games(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      totalplay: int.tryParse(map['totalplay'].toString()) ?? 0,
      totalplaying: int.tryParse(map['totalplaying'].toString()) ?? 0,
    );
  }
}

List<Games> games = [

  Games(id: "", name: "Tetris", image: "assets/tetris.png", totalplay: 122112, totalplaying: 577554),
  Games(id: "", name: "Quiz", image: "assets/quiz.png", totalplay: 532211, totalplaying: 45245),
  Games(id: "", name: "SpinWheel", image: "assets/spin.png", totalplay: 383989, totalplaying: 23536),
  Games(id: "", name: "Crossword", image: "assets/crossworord.png", totalplay: 2837292, totalplaying: 245425),

];