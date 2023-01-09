import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/UI/AppPages.dart';
import 'package:tic_tac_toe/UI/GameBoard.dart';

class PlayPage extends StatefulWidget implements AppPages{
  int widthBreakPoint;

  PlayPage({Key? key, required this.widthBreakPoint}) : super(key: key);

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  // Global Key for a game board
  final GlobalKey<GameBoardState> gameBoardKey = GlobalKey<GameBoardState>();

  // List for gamemode
  List<String> gamemodes = ["PVE", "EVE"];
  String selectedGamemode = "PVE";

  // List for difficulties
  List<String> difficulties = ["Beginner", "Intermediate", "Expert"];
  String seletedDifficulties = "Beginner";

    @override
    Widget build(BuildContext context) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constrains) {
          if (constrains.maxWidth > widget.widthBreakPoint) {
            return _widePage(constrains.maxWidth);
          } else {
            return _normalPage();
          }
        },
      );
    }

  Widget _widePage(double width) {
    double widthFactor = 0.18;

    return SingleChildScrollView(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _createGamemodeRadioButton(),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 10, bottom: 10),
                  child: _createDifficultiesDropdownList(),
                )
              ],
            ),
          ),
          Flexible(
              flex: 3 ,
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80, right: 80),
                    child: GameBoard(size: min(width *0.6, 500), gameMode: GameBoard.PVE, key: gameBoardKey,),
                  )
              )
          ),
        ],
      ),
    );
  }

  Widget _normalPage() {
    return Row(

    );
  }

  Widget _createDifficultiesDropdownList() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Difficulties", textAlign: TextAlign.center,),
          DropdownButton(
              value: seletedDifficulties,
              iconEnabledColor: Colors.greenAccent,
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
                  });
                }
              }),
        ],
      );
  }

  // Create a set of radio buttons that indicate the gamemode (PVE/EVE)
  Widget _createGamemodeRadioButton() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 18, top: 10, bottom: 8),
            child: Text("Game Mode", textAlign: TextAlign.center,),
          ),
          ListTile(
            visualDensity: VisualDensity(vertical: -4),
            title: Text(gamemodes[0]),
            leading: Radio<String>(
              value: gamemodes[0],
              groupValue: selectedGamemode,
              onChanged: (String? value) {
                setState(() {
                  if (value != null) {
                    selectedGamemode = value;
                  }
                });
              },
            ),
          ),
          ListTile(
            visualDensity: VisualDensity(vertical: -4),
            title: Text(gamemodes[1]),
            leading: Radio<String>(
              value: gamemodes[1],
              groupValue: selectedGamemode,
              onChanged: (String? value) {
                setState(() {
                  if (value != null) {
                    selectedGamemode = value;
                  }
                });
              },
            ),
          ),
        ],
      );
  }
}

