import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Utils/GameManager.dart';

/// This class represent a game board for tic tac toe.
/// The board will be constrained in a sizedBox, size specified as a parameter of the class.
/// Game board consists of 9 buttons, only enabling the buttons if available (i.e. disable when user or AI pressed the button (PvE) / disable in PvE mode).

class GameBoard extends StatefulWidget {
  GameBoard({
    Key? key,
    required this.size,
    required this.manager,
    required this.gameMode,
    this.difficulty = "beginner",
    required this.endGameCallBack,
    this.humanPlayerSide = 1
  }) : super(key: key);

  final double size;
  final int gameMode;
  final String difficulty;
  final GameManager manager;
  final Function endGameCallBack;
  final int humanPlayerSide;

  static const int PVE = 0; // Player vs Environment(AI)
  static const int EVE = 1; // Environment vs Environment (AI vs AI)

  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  // Global keys for 9 block states
  List<GlobalKey<BoardBlockState>> gameBoardStateKeys = [];

  List<String> playerSides = ["X", "O"];

  int _humanPlayerSide = 1;

  // Function that returns whether it is 'O''s turn or 'X''s turn.
  // Called by each block state.
  int getWhoseTurn() {
    return widget.manager.whoseTurn;
  }

  void setHumanPlayerSide(int side) {
    setState(() {
      _humanPlayerSide = side;
    });
  }


  /// This is a callback function for a blockState.
  /// Called whenever a player makes a move and activated onPress.
  ///
  /// This notifies the GameManager and record the move,
  /// also ask the GameManager to check for a win or tie.
  void setBlockState(int position) {
    widget.manager.playerMoved(position, widget.manager.whoseTurn);
    bool endGame = widget.manager.checkWin();

    // reset the board if the game is ended
    if (endGame) {
      endGameProtocol(2);
    }

    if (!endGame) {
      // PVE Mode
      if (widget.gameMode == 0) {
        // AI can move if it is not player's turn
        if (widget.manager.humanPlayerSide != widget.manager.whoseTurn) {
          aiMove(widget.difficulty);
        }
      } else {
        // EVE mode
        aiMove(widget.difficulty);
      }
    }
  }

  /// Called when the game is ended after check win.
  /// This protocol notify PlayPage to rebuild the scoreText widget, also reset the state in gameManager
  /// and clear each state.
  /// @param delayInSeconds represents how many seconds to wait for clearing the blocks, nice for visual appearance.
  void endGameProtocol(int delayInSeconds) async{
    widget.endGameCallBack();
    widget.manager.resetBoard();
    for (int i = 0; i < 9; i++) {
      gameBoardStateKeys[i].currentState!.blockInput();
    }

    // Separating no delay and having delay, as using Future.delay will cause other threads to run first
    if (delayInSeconds == 0) {
      // Clear each block immediately
      for (int i = 0; i < 9; i++) {
        gameBoardStateKeys[i].currentState!.clearBlock();
      }
      widget.endGameCallBack();
    } else {
      // Clear each block after 2 seconds delay
      await Future.delayed(Duration(seconds: delayInSeconds), () {
        // Clear each block state
        for (int i = 0; i < 9; i++) {
          gameBoardStateKeys[i].currentState!.clearBlock();
        }
        widget.endGameCallBack();
      });
    }

    aiMakesFirstMove();
  }

  int getMoveO() {
    String state = widget.manager.getState().toString();
    return widget.manager.bestMovesO[state];
  }

  int getMoveX() {
    String state = widget.manager.getState().toString();
    return widget.manager.bestMovesX[state];
  }


  /// This function is called after a player makes a move or an AI makes a move.
  /// This function will directly change the state of the block in order to display the correct value.
  // TODO - Implement this method and replace the stub code
  void aiMove(String difficulty) {
    print("AI Moving");
    // Stub code - remove the code below
    // List<int> possibleMoves = [];
    // for (int i = 0; i < 9; i++) {
    //   if (widget.manager.boardState[i] == 0) {
    //     possibleMoves.add(i);
    //   }
    // }
    // possibleMoves.add(getMoveO());

    // Keep the code below, but change the condition of the next line if needed.
    // Set the state of the desired button.
    // if (possibleMoves.isNotEmpty) {
    //   int move = possibleMoves[Random().nextInt(possibleMoves.length)];
      int move = getMoveO();
      // Delay 1 second for a better appearance
      // First, make every button disabled
      blockEnableDisableSwitch();

      // Second, delay for 1 second
      Future.delayed(const Duration(seconds: 1), (){
        // Third, make the temporally disabled button back to enabled
        blockEnableDisableSwitch();

        // Fourth, set the desired block to a played move
        gameBoardStateKeys[move].currentState!.changeState();
      });
  }

  /// Setting all empty blocks to disable if the block is enabled
  /// vice versa, setting all empty blocks to enable if the block is disabled
  void blockEnableDisableSwitch() {
    for (int i = 0; i < 9; i++) {
      if (widget.manager.boardState[i] == 0) {
        gameBoardStateKeys[i].currentState!.switchDisable();
      }
    }
  }

  /// The AI will make the first move if it is a AI vs AI game or the player selected 'O'
  void aiMakesFirstMove() async{
    if (_humanPlayerSide == 0 || _humanPlayerSide == 2) {
      // After 30ms, the AI makes its first move
      await Future.delayed(const Duration(milliseconds: 30), () {
        aiMove(widget.difficulty);
      });
    }
  }

  @override
  void initState() {
    // Instantiate the gameBoardStateKeys
    for (int i = 0; i < 9; i++) {
      gameBoardStateKeys.add(GlobalKey<BoardBlockState>());
    }

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_humanPlayerSide == 0 || _humanPlayerSide == 2) {
        print("AI's First Move");
        aiMove(widget.difficulty);
      }
    });
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

  @override
  BoardBlockState createState() => BoardBlockState();
}

class BoardBlockState extends State<BoardBlock> {
  bool enableInput = true;
  bool _disabled = false;
  bool x = true;

  void switchDisable() {
    if (_disabled) {
      _disabled = false;
    }
    else {
      _disabled = true;
    }
  }

  void changeState() {
    if (enableInput) {
      // Only allow user to click the button if enabled
      if (!_disabled) {
        // set state to disable the button
        setState(() {
          _disabled = true;

          // set 'O' or 'X'
          if (widget.getWhoseTurn() == 1) {
            x = false;
          } else {
            x = true;
          }

          widget.setBlockState(widget.position);

        });
      }
    }
  }

  void clearBlock() {
    setState(() {
      _disabled = false;
      enableInput = true;
    });
  }

  void blockInput() {
    enableInput = false;
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
        x? const Icon(Icons.circle_outlined, color: Colors.amberAccent, size: 30) : const Icon(Icons.close, color: Colors.lightBlueAccent, size: 30),
      )
    );
  }
}

