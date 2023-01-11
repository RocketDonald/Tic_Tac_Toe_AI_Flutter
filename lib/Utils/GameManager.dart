import 'package:flutter/material.dart';

/// This class manages the game and monitor the states
///
/// This class should be called in PlayPage only.
/// This class provides methods to check win, set player moves and calculate score

class GameManager {
  int _playerOneScore = 0;
  int _playerTwoScore = 0;
  int _tie = 0;
  int _humanPlayerSide = 1; // 0 = Not Playing / 1 = Player 1 ("X") / 2 = Player 2 ("O")

  // 0 = Nothing / 1 = Player 1 ("X") / 2 = Player 2 ("O")
  List<int> boardState = [0, 0, 0,
                          0, 0, 0,
                          0, 0, 0];
  int moves = 0;

  // List of all winning combinations, each int represent the position on board (0-8).
  List<List<int>> winningCombinations = [
    // Rows
    [0,1,2],
    [3,4,5],
    [6,7,8],
    // Columns
    [0,3,6],
    [1,4,7],
    [2,5,8],
    // Diagonals
    [0,4,8],
    [2,4,6]
  ];

  int get playerOneScore {
    return _playerOneScore;
  }

  int get playerTwoScore {
    return _playerTwoScore;
  }

  int get tie {
    return _tie;
  }

  int get humanPlayerSide {
    return _humanPlayerSide;
  }

  /// 1 = Player 1 ("X") / 2 = Player 2 ("O")
  int get whoseTurn {
    return (moves % 2) + 1;
  }

  /// 0 = Not Playing / 1 = Player 1 ("X") / 2 = Player 2 ("O")
  GameManager(int humanPlayerSide) {
    _humanPlayerSide = humanPlayerSide;
  }

  /// Only be called when the human player changes their side by pressing the radio button
  /// in the PlayPage.
  /// Will swap the score in order to match the position change.
  void humanPlayerSwitchSide() {
    // Do nothing if human is not playing
    if (_humanPlayerSide == 0) {
      return;
    }
    // Swap side
    if (_humanPlayerSide == 1) {
      _humanPlayerSide = 2;
    } else {
      _humanPlayerSide = 1;
    }
    // Swap the score
    int temp = _playerOneScore;
    _playerOneScore = _playerTwoScore;
    _playerTwoScore = temp;
  }

  /// Called if checkWin() returns true or remainMoves() returns false.
  /// 0 = Tie / 1 = Player 1 ("X") / 2 = Player 2 ("O")
  void playerWon(int playerNum) {
    if (playerNum == 1) {
      _playerOneScore ++;
    } else if (playerNum == 2) {
      _playerTwoScore ++;
    } else {
      _tie ++;
    }
  }

  /// Read the board state and check if a winner is out
  bool checkWin() {
    bool win = false;

    for (List<int> combination in winningCombinations) {
      // Record which player is on that position
      int player = boardState[combination[0]];
      if (player == 0) {
        continue;
      }
      // Check if all those positions are selected by the player
      if (boardState[combination[1]] == player && boardState[combination[2]] == player) {
        win = true;
        break;
      }
    }

    // Set a player win if it is a winning state, else check for a tie
    if (win) {
      moves++;
      playerWon(whoseTurn);
      return win;
    } else {
      // If there is no winner, check for the possibility of a tie.
      return !checkRemainMoves();
    }
  }

  /// Check if there are still available moves, aka a possibility of tie.
  /// Called everytime checkWin() is called
  bool checkRemainMoves() {
    if (9 - moves == 0) {
      // Set tie
      playerWon(0);
      return false;
    }
    return true;
  }

  /// Called when a player moves.
  /// Will check for illegal moves.
  ///
  /// Should call checkWin() to see if that is a winning move or last move after calling this function
  void playerMoved(int position, int playerNum) {
    // Check for illegal moves
    if (boardState[position] != 0) {
      return;
    }

    boardState[position] = playerNum;

    moves++;
  }

  /// Reset the board
  void resetBoard() {
    boardState = [0, 0, 0,
                  0, 0, 0,
                  0, 0, 0];

    moves = 0;
  }

  void resetScores() {
    _playerOneScore = 0;
    _playerTwoScore = 0;
    _tie = 0;
  }
}