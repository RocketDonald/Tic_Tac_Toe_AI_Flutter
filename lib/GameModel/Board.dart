
import 'utils.dart';

class Board {
  List<String> boardState = [" ", " ", " ", " ", " ", " ", " ", " ", " "];

  List<int> winningCombinations = [
    // Rows
    7, 56, 448,
    // Columns
    292, 146, 73,
    // Diagonals
    273, 84
  ];

  Board() {
    boardState = [" ", " ", " ", " ", " ", " ", " ", " ", " "];
  }

  int getState() {
    return boardToDecminal(boardState);
  }

  /// Assumes move is legal (cell not yet occupied)
  int playMove(side, move) {
    boardState[move] = side;
    return move;
  }

  bool checkXWon() {
    int boardStateX = convertBoardToBinaryX(boardState);
    for (int winningPositions in winningCombinations) {
      if (boardStateX & winningPositions == winningPositions) {
        return true;
      }
    }
    return false;
  }

  bool checkOWon() {
    int boardStateO = convertBoardToBinaryO(boardState);
    for (int winningPositions in winningCombinations) {
      if (boardStateO & winningPositions == winningPositions) {
        return true;
      }
    }
    return false;
  }

  bool checkNoMoves() {
    for (int i = 0; i < 9; i++) {
      if (boardState[i] == " ") {
        return false;
      }
    }
    return true;
  }

  String checkGameOver() {
    if (checkXWon()) {
      return "X";
    } else if(checkOWon()) {
      return "O";
    } else if (checkNoMoves()) {
      return "DRAW";
    } else {
      return "FALSE";
    }
  }


  void printBoard() {
    for (int i = 0; i < 3; i++) {
      print("${("+${"-" * 3}") * 3}+");
      print("| ${boardState[i*3]} | ${boardState[i*3+1]} | ${boardState[i*3+2]} |");
      print("${("+${"-" * 3}") * 3}+");
    }
  }

}