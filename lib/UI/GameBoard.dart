import 'package:flutter/material.dart';

/// This class represent a game board for tic tac toe.
/// The board will be constrained in a sizedBox, size specified as a parameter of the class.
/// Game board consists of 9 buttons, only enabling the buttons if available (i.e. disable when user or AI pressed the button (PvE) / disable in PvE mode).
/// In order to support AI, this class provides methods to check win and reset board
///

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key, required this.size, required this.gameMode}) : super(key: key);
  final int size;
  final int gameMode;

  static const int PVP = 0;
  static const int PVE = 1;

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<String> whoseTurn = ["O", "X"];
  int turn = 0;

  // A list to store the state of each board block (i.e., button)
  List<String> stateList = ["", "", "",
                            "", "", "",
                            "", "", ""];

  String getWhoseTurn() {
    return whoseTurn[turn % 2];
  }

  // Called by the block if someone pressed it (can be player or AI)
  void setBlockState(int position) {
    stateList[position] = whoseTurn[turn % 2];

    // next turn
    turn++ ;
  }

  @override
  Widget build(BuildContext context) {
    double _blockSize = widget.size / 3;

    return SizedBox(
      width: widget.size.toDouble(),
      height: widget.size.toDouble(),
      child: Column(
        children: [
          Row(
            children: [
              BoardBlock(position: 0, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize,),
              BoardBlock(position: 1, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize,),
              BoardBlock(position: 2, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize,),
            ],
          ),
          Row(
            children: [
              BoardBlock(position: 3, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize,),
              BoardBlock(position: 4, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize,),
              BoardBlock(position: 5, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize,),
            ],
          ),
          Row(
            children: [
              BoardBlock(position: 6, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize,),
              BoardBlock(position: 7, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize,),
              BoardBlock(position: 8, setBlockState: setBlockState, getWhoseTurn: getWhoseTurn, blockSize: _blockSize,),
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

  @override
  BoardBlockState createState() => BoardBlockState();
}

class BoardBlockState extends State<BoardBlock> {
  bool _disabled = false;
  bool o = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.blockSize,
      height: widget.blockSize,
      child: OutlinedButton(
        onPressed: () {
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
        },
        child: !_disabled? const Text("") : o? const Icon(Icons.circle_outlined, color: Colors.amberAccent,) : const Icon(Icons.close, color: Colors.lightBlueAccent),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.greenAccent)
                )
            )
        ),
      )
    );
  }
}

