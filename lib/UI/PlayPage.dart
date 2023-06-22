import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/UI/AppPages.dart';
import 'package:tic_tac_toe/UI/GameBoard.dart';
import 'package:tic_tac_toe/Utils/GameManager.dart';

class PlayPage extends StatefulWidget implements AppPages{
  final int widthBreakPoint;
  final GlobalKey dialogScaffoldKey;

  PlayPage({Key? key, required this.widthBreakPoint, required this.dialogScaffoldKey}) : super(key: key);

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  // Global Key for a game board
  final GlobalKey<GameBoardState> gameBoardKey = GlobalKey<GameBoardState>();

  // List for player sides
  Icon iconX = const Icon(Icons.close, color: Colors.lightBlueAccent,);
  Icon iconO = const Icon(Icons.circle_outlined, color: Colors.amberAccent);
  late List<Icon> playerSide;
  late Icon selectedPlayerSide;

  // List for difficulties
  List<String> difficulties = ["Beginner", "Intermediate", "Expert"];
  String seletedDifficulties = "Intermediate";

  // Game Manager for the board
  late GameManager manager;

  // String for displaying the score
  late String _scoreText;
  String _restartingText = "";

  // Variables to handle the end game dialog
  bool _dialogPopped = false;
  BuildContext? dialogContext;

    @override
    void initState() {
      // Init options
      playerSide = [iconX, iconO];
      // Pre-selected player using X
      selectedPlayerSide = iconX;
      manager = GameManager(1);
      _setScoreText();
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constrains) {
          if (constrains.maxWidth > widget.widthBreakPoint) {
            return _widePage(constrains.maxWidth, constrains.maxHeight);
          } else {
            return _normalPage(constrains.maxWidth, constrains.maxHeight);
          }
        },
      );
    }


  Widget _widePage(double width, double height) {
    return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(
        flex: 1,
        fit: FlexFit.loose,
        child: Container(
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                _createPlayerSideRadioButton(false),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 10, bottom: 10),
                  child: _createDifficultiesDropdownList(false),
                ),
              ],
            ),
          ),
        ),
      ),
      Flexible(
          flex: 3 ,
          child: Center(
             child: _createGameBoard(width, height),
          )
      ),
    ],
      );
  }

  Widget _normalPage(double width, double height) {
    return Column(
      children: [
        Container(
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(flex: 1, child: _createPlayerSideRadioButton(true)),
                Flexible(flex: 1, child: _createDifficultiesDropdownList(true)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:18.0),
          child: _createGameBoard(width, height),
        ),
      ]
    );
  }

  void _setScoreText() {
    late String text;
    if (manager.humanPlayerSide == 1) { // 1 == 'X'
      text = "You  ${manager.playerOneScore} : ${manager.playerTwoScore}  $seletedDifficulties AI";
    } else if (manager.humanPlayerSide == 2) { // 2 == 'O'
      text = "$seletedDifficulties AI  ${manager.playerOneScore} : ${manager.playerTwoScore}  You";
    } else {
      // AI vs AI
      text = "AI-X ${manager.playerOneScore} : ${manager.playerTwoScore} AI-O";
    }
    text += "\n${manager.tie} Ties";
      setState(() {
        _scoreText = text;
      });
  }

  /// This function will pop a dialog that tells the player the game has ended and will restart soon
  void _setWinningText() {
    setState(() {
      if (_dialogPopped == false) {
        // Display the dialog and tell the user the game has ended
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              dialogContext = context;
              return WillPopScope(
                onWillPop: () async => false,
                child: Dialog(
                  child: SizedBox(
                    height: 180,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 400,
                            child: Container(
                                color: Colors.lightBlue
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text("Game Ends.", style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800, color: Colors.blue),),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("A New Game Will Begin in 2 Seconds"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
        );

        _dialogPopped = true;
      } else {
        // Close the dialog box
          Navigator.of(context!).pop();
        _dialogPopped = false;
      }
    });
  }

  /// This is a call back function that will be passed into the GameBoard
  /// When a game finished, this function will be called to change the scoreText and winningText in this class state
  void endGameCallBack() {
    setState(() {
      _setScoreText();
      _setWinningText();
    });
  }

  Widget _createGameBoard(double width, double height) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_scoreText, textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30),
            child: GameBoard(
              size: min(width *0.6, height * 0.6),
              manager: manager,
              gameMode: GameBoard.PVE,
              key: gameBoardKey,
              endGameCallBack: endGameCallBack,),
          ),
          Text(_restartingText, textAlign: TextAlign.center,),
        ],
      );
  }

  Widget _createDifficultiesDropdownList(bool normal) {
      if (!normal) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Difficulties", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            DropdownButton(
                value: seletedDifficulties,
                iconEnabledColor: Colors.greenAccent,
                isExpanded: true,
                underline: Container(
                  height: 2,
                  color: Colors.greenAccent,
                ),
                items: difficulties.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value){
                  if (value != null) {
                    setState(() {
                      seletedDifficulties = value;
                      // Reset the score and the board
                      gameBoardKey.currentState!.setDifficulty(seletedDifficulties);
                      gameBoardKey.currentState!.endGameProtocol(0);
                      manager.resetScores();
                      _setScoreText();
                    });
                  }
                }),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Difficulties", textAlign: TextAlign.left, style: TextStyle(fontSize: 16)),
            DropdownButton(
                value: seletedDifficulties,
                iconEnabledColor: Colors.greenAccent,
                isExpanded: true,
                underline: Container(
                  height: 2,
                  color: Colors.greenAccent,
                ),
                items: difficulties.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value){
                  if (value != null) {
                    setState(() {
                      seletedDifficulties = value;
                      // Reset the score and the board
                      gameBoardKey.currentState!.endGameProtocol(0);
                      manager.resetScores();
                      _setScoreText();
                    });
                  }
                }),
          ],
        );
      }

  }

  // Create a set of radio buttons that indicate the gamemode (PVE/EVE)
  Widget _createPlayerSideRadioButton(bool normal) {
      if(!normal) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 18, top: 10, bottom: 8),
              child: Text("Pick a side", textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
            ),
            ListTile(
              visualDensity: VisualDensity(vertical: -4),
              title: Align(alignment: Alignment.centerLeft, child: playerSide[0]),
              leading: Radio<Icon>(
                value: playerSide[0],
                groupValue: selectedPlayerSide,
                onChanged: (Icon? value) {
                  setState(() {
                    if (value != null) {
                      selectedPlayerSide = value;
                      manager.humanPlayerSwitchSide();
                      _setScoreText();
                      // Reset the score and the board
                      gameBoardKey.currentState!.endGameProtocol(0);
                      gameBoardKey.currentState!.setHumanPlayerSide(1);
                    }
                  });
                },
              ),
            ),
            ListTile(
              visualDensity: VisualDensity(vertical: -2),
              title: Align(alignment: Alignment.centerLeft, child: playerSide[1]),
              leading: Radio<Icon>(
                value: playerSide[1],
                groupValue: selectedPlayerSide,
                onChanged: (Icon? value) {
                  setState(() {
                    if (value != null) {
                      selectedPlayerSide = value;
                      manager.humanPlayerSwitchSide();
                      _setScoreText();
                      // Reset the score and the board
                      gameBoardKey.currentState!.endGameProtocol(0);
                      gameBoardKey.currentState!.setHumanPlayerSide(2);
                      gameBoardKey.currentState!.aiMakesFirstMove();
                    }
                  });
                },
              ),
            ),
          ],
        );
      } else {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Padding(
             padding: const EdgeInsets.only(left: 18),
             child: Text("Pick a side", textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
           ),
           Row(
             children: [
               Flexible(
                 child: ListTile(
                   visualDensity: VisualDensity(vertical: -4),
                   title: Align(alignment: Alignment.centerLeft, child: playerSide[0]),
                   leading: Radio<Icon>(
                     value: playerSide[0],
                     groupValue: selectedPlayerSide,
                     onChanged: (Icon? value) {
                       setState(() {
                         if (value != null) {
                           selectedPlayerSide = value;
                           manager.humanPlayerSwitchSide();
                           _setScoreText();
                           // Reset the score and the board
                           gameBoardKey.currentState!.endGameProtocol(0);
                           gameBoardKey.currentState!.setHumanPlayerSide(1);
                         }
                       });
                     },
                   ),
                 ),
               ),
               Flexible(
                 child: ListTile(
                   visualDensity: VisualDensity(vertical: 0),
                   title: Align(alignment: Alignment.centerLeft, child: playerSide[1]),
                   leading: Radio<Icon>(
                     value: playerSide[1],
                     groupValue: selectedPlayerSide,
                     onChanged: (Icon? value) {
                       setState(() {
                         if (value != null) {
                           selectedPlayerSide = value;
                           manager.humanPlayerSwitchSide();
                           _setScoreText();
                           // Reset the score and the board
                           gameBoardKey.currentState!.endGameProtocol(0);
                           gameBoardKey.currentState!.setHumanPlayerSide(2);
                           gameBoardKey.currentState!.aiMakesFirstMove();
                         }
                       });
                     },
                   ),
                 ),
               ),
             ],
           ),
         ],
       );
      }
  }


}

