import 'dart:io';

import 'AIStrategy.dart';
import 'Board.dart';

abstract class Player {
  // fields
  late String side;

  // methods
  int getMove(Board board);
}

class HumanPlayer extends Player {
  HumanPlayer(String side) {
    this.side = side;
  }

  @override
  int getMove(Board board) {
    print("Choose your move:");
    String? move = stdin.readLineSync();
    int moveConverted = int. parse(move!);
    while (board.boardState[moveConverted] == " ") {
      print("Please choose a legal move");
      move = stdin.readLineSync();
    }
    return moveConverted;
  }
}

class AIPlayer extends Player {
  AIStrategy strategy;
  AIPlayer(String side, var this.strategy) {
    this.side = side;
  }

  @override
  int getMove(Board board) {
    int state = board.getState();
    if (side == "X") {
      return strategy.getAIMoveX(state);
    } else {
      return strategy.getAIMoveO(state);
    }
  }
}