import 'dart:math';

/// This function converts the board state to decimal form
int boardToDecminal(boardState) {
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += boardState[i] * pow(3, i) as int;
  }
  return sum;
}

int convertBoardToBinaryX(boardState) {
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    if (boardState[i] == "X") {
      sum += boardState[i] * pow(2, i) as int;
    }
  }
  return sum;
}

int convertBoardToBinaryO(boardState) {
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    if (boardState[i] == "O") {
      sum += boardState[i] * pow(2, i) as int;
    }
  }
  return sum;
}

/// This function converts a decimal to the board
List<int> getBoard(int state) {
  List<int> boardState = [];
  if (state == 0) {
    return boardState;
  } else {
    while (state > 0) {
      boardState.add(state % 3);
      state = (state/3).floor();
    }
  }
  return List.from(boardState.reversed);
}