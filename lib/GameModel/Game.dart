import 'dart:io';

import 'Board.dart';
import 'Player.dart';

class Game {
  late Player playerX;
  late Player playerO;
  late Board board;

  Game(this.playerX, this.playerO, this.board);

  void startGame() {
    print("Choose your side (X/O): ");
    String? humanSide = stdin.readLineSync();
    assert (humanSide == "X" || humanSide == "O");

    String turn = "X";

    board.printBoard();

    while (true) {
      if (turn == "X") {
        int xMove = playerX.getMove(board);
        board.playMove("X", xMove);
      } else {
        int oMove = playerO.getMove(board);
        board.playMove("O", oMove);
      }
      String winner = board.checkGameOver();

      if (winner == "DRAW") {
        print("Game is a draw");
        return;
      } else if (winner == "X") {
        print("Winner is X");
        return;
      } else if (winner == "O") {
        print("Winner is O");
        return;
      }

      turn == "X" ? "O" : "X";
    }
  }
}