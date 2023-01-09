import 'package:flutter/material.dart';
import 'package:tic_tac_toe/UI/AppPages.dart';

class SupportPage extends StatelessWidget implements AppPages{
  int widthBreakingPoint;

  SupportPage({Key? key, required this.widthBreakingPoint}) : super(key: key);

  Widget _wide() {
    return Container(
      color: Colors.lightGreen,
    );
  }

  Widget _normal() {
    return Container(

    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constrains) {
        if (constrains.maxWidth > widthBreakingPoint) {
          return _wide();
        } else {
          return _normal();
        }
      },
    );
  }
}
