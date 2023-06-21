class Move {
  final String state;
  final int move;

  const Move({
    required this.state,
    required this.move
  });

  factory Move.fromJson(Map<dynamic, dynamic> json) {
    return Move(
      state: json.keys.first,
      move: json[json.keys.first] as int
    );
  }
}