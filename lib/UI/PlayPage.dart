import 'package:flutter/material.dart';
import 'package:tic_tac_toe/UI/AppPages.dart';
import 'package:tic_tac_toe/UI/GameBoard.dart';

class PlayPage extends StatelessWidget implements AppPages{
  const PlayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GameBoard(gameMode: GameBoard.PVE, size: 600,),
    );
  }
}
