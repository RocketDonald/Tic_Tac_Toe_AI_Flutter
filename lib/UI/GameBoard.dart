import 'dart:math';

import 'package:flutter/material.dart';

/// This class represent a game board for tic tac toe.
/// The board will be constrained in a sizedBox, size specified as a parameter of the class.
/// Game board consists of 9 buttons, only enabling the buttons if available (i.e. disable when user or AI pressed the button (PvE) / disable in PvE mode).

class GameBoard extends StatefulWidget {
  GameBoard({Key? key, required this.size, required this.gameMode, this.playerChoseO = "O"}) : super(key: key);
  final double size;
  final int gameMode;
  final String playerChoseO;

  static const int PVE = 0; // Player vs Environment(AI)
  static const int EVE = 1; // Environment vs Environment (AI vs AI)

  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  // Global keys for 9 block states
  List<GlobalKey<BoardBlockState>> gameBoardStateKeys = [];

  List<String> whoseTurn = ["O", "X"];
  int turn = 0;

  // A list to store the state of each board block (i.e., button)
  List<String> stateList = ["", "", "",
                            "", "", "",
                            "", "", ""];

  // Function that returns whether it is 'O''s turn or 'X''s turn.
  // Called by each block state.
  String getWhoseTurn() {
    return whoseTurn[turn % 2];
  }

  // Set the stateList in this state.
  // Called by the block if someone pressed it (can be player or AI).
  void setBlockState(int position) {
    stateList[position] = whoseTurn[turn % 2];

    // next turn
    turn++ ;

    // PVE Mode
    if (widget.gameMode == 0) {
      // AI can move if it is not player's turn
      if (widget.playerChoseO != getWhoseTurn()) {
        aiMove();
      }
    } else {
      // EVE mode
      aiMove();
    }
  }

  // This function is called after a player makes a move or an AI makes a move.
  // This function will directly change the state of the block in order to display the correct value.
  // TODO - Implement this method and replace the stub code
  void aiMove() {
    // Stub code - remove the code below
    List<int> possibleMoves = [];
    for (int i = 0; i < 9; i++) {
      if (stateList[i] == "") {
        possibleMoves.add(i);
      }
    }

    // Keep the code below, but change the condition of the next line if needed.
    // Set the state of the desired button.
    if (possibleMoves.isNotEmpty) {
      int move = possibleMoves[Random().nextInt(possibleMoves.length)];

      // Delay 1 second for a better appearance
      // First, make every button disabled
      for (int i = 0; i < 9; i++) {
        if (stateList[i] == "") {
          gameBoardStateKeys[i].currentState!.switchDisable();
        }
      }

      // Second, delay for 1 second
      Future.delayed(const Duration(seconds: 1), (){
        // Third, make the temporally disabled button back to enabled
        for (int i = 0; i < 9; i++) {
          if (stateList[i] == "") {
            gameBoardStateKeys[i].currentState!.switchDisable();
          }
        }
        // Fourth, set the desired block to a played move
        gameBoardStateKeys[move].currentState!.changeState();
      });
    }
  }

  // Called to begin an AI vs AI game
  void beginEVE() {
    if (widget.gameMode == 1) {
      aiMove();
    }
  }

  @override
  void initState() {
    // Instantiate the gameBoardStateKeys
    for (int i = 0; i < 9; i++) {
      gameBoardStateKeys.add(GlobalKey<BoardBlockState>());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Each block size is one-third of the game board
    double _blockSize = widget.size / 3;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      // 3 Rows and 3 Columns, placing 9 board blocks in total
      child: Column(
        children: [
          Row(
            children: [
              BoardBlock(position: 0, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize, key: gameBoardStateKeys[0],),
              BoardBlock(position: 1, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize, key: gameBoardStateKeys[1],),
              BoardBlock(position: 2, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize, key: gameBoardStateKeys[2],),
            ],
          ),
          Row(
            children: [
              BoardBlock(position: 3, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize, key: gameBoardStateKeys[3],),
              BoardBlock(position: 4, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize, key: gameBoardStateKeys[4],),
              BoardBlock(position: 5, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize, key: gameBoardStateKeys[5],),
            ],
          ),
          Row(
            children: [
              BoardBlock(position: 6, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize, key: gameBoardStateKeys[6],),
              BoardBlock(position: 7, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize, key: gameBoardStateKeys[7],),
              BoardBlock(position: 8, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize, key: gameBoardStateKeys[8],),
            ],
          ),
        ],
      ),
    );
  }
}

class BoardBlock extends StatefulWidget {
  // Field
  const BoardBlock({Key? key, required this.position, required this.setBlockState, required this.getWhoseTurn, required this.blockSize}) : super(key: key);
  final int position;
  final double blockSize;

  // Call back functions
  final Function setBlockState;
  final Function getWhoseTurn;

  void setAIMove() {

  }

  @override
  BoardBlockState createState() => BoardBlockState();
}

class BoardBlockState extends State<BoardBlock> {
  bool _disabled = false;
  bool o = false;

  void switchDisable() {
    if (_disabled) {
      _disabled = false;
    }
    else {
      _disabled = true;
    }
  }

  void changeState() {
    // Only allow user to click the button if enabled
    if (!_disabled) {
      // set state to disable the button
      setState(() {
        _disabled = true;
        widget.setBlockState(widget.position);

        // set 'O' or 'X'
        if (widget.getWhoseTurn() == "O") {
          o = true;
        } else {
          o = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.blockSize,
      height: widget.blockSize,
      child: OutlinedButton(
        onPressed: () {
          changeState();
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.greenAccent)
                )
            )
        ),
        child: !_disabled? const Text("") :
        o? const Icon(Icons.circle_outlined, color: Colors.amberAccent, size: 30) : const Icon(Icons.close, color: Colors.lightBlueAccent, size: 30),
      )
    );
  }
}

