import 'package:flutter/material.dart';
import 'package:tic_tac_toe/UI/AppPages.dart';

class AboutPage extends StatelessWidget implements AppPages{
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
    );
  }
}
