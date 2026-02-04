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

  Games(id: "tetris", name: "Tetris", image: "assets/tetris.png", totalplay: 122112, totalplaying: 577554),
  Games(id: "quiz", name: "Quiz", image: "assets/quiz.png", totalplay: 532211, totalplaying: 45245),
  Games(id: "spin", name: "SpinWheel", image: "assets/spin.png", totalplay: 383989, totalplaying: 23536),

];