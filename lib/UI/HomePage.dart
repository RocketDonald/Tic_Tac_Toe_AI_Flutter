import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_toe/UI/AppPages.dart';
import 'package:tic_tac_toe/Utils/FileToWidget.dart';

class HomePage extends StatelessWidget implements AppPages{
  HomePage({Key? key, required this.widthBreakPoint, required this.goToNextPage}) : super(key: key);

  late Function goToNextPage;
  late int widthBreakPoint;

  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constrains) {
        if (constrains.maxWidth > widthBreakPoint) {
          return _wide();
        } else {
          return _normal();
        }
      },
    );
  }

  Widget _wide() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Block_1(widthBreakPoint: widthBreakPoint, goToNextPage: goToNextPage,),
          Block_2(sizeBreakingPoint: widthBreakPoint,),
        ],
      ),
    );
  }

  Widget _normal() {
    return PageView(
      controller: controller,
      children: [
        Block_1(widthBreakPoint: widthBreakPoint, goToNextPage: goToNextPage,),
        Block_2(sizeBreakingPoint: widthBreakPoint,),
      ],
    );
  }
}

class Block_1 extends StatelessWidget {
  Block_1({Key? key, required this.widthBreakPoint, required this.goToNextPage}) : super(key: key);
  final double _width =  WidgetsBinding.instance.window.physicalSize.width;
  late int widthBreakPoint;
  late Function goToNextPage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > widthBreakPoint) {
            return _createWideWidget();
          } else {
            return _createNormalWidget();
          }
        }
    );
  }

  Widget _createWideWidget() {
    return Container(
      color: Colors.blueGrey,
      child: SizedBox(
        height: 600,
        child: Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.fill,
                child: Image.asset("images/Home_Page_Background.jpg"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: _width * 0.06, top: 220),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12, top: 12, bottom: 6),
                    child: Text("AI designed for Tic Tac Toe", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 32),),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 12),
                    child: Text("This AI is a reinforcement-learning-based AI. Unbeatable, Fast, Tricky.", style: TextStyle(color: Colors.white, fontSize: 14),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: TextButton(
                        onPressed: () {
                          goToNextPage(2);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Play", style: TextStyle(color: Colors.white),),
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createNormalWidget() {
    return Container(
      child: SizedBox(
        height: 600,
        child: Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.fill,
                child: Image.asset("images/Home_Page_Background.jpg"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:200, bottom: 200),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 12, top: 12, bottom: 6),
                      child: Text("AI designed for Tic Tac Toe", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 32),),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12, bottom: 12),
                      child: Text("This AI is a reinforcement-learning-based AI. Unbeatable, Fast, Tricky.", style: TextStyle(color: Colors.white, fontSize: 14),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: TextButton(
                          onPressed: () {
                            goToNextPage(2);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Play", style: TextStyle(color: Colors.white),),
                          )),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Block_2 extends StatelessWidget {
  Block_2({Key? key, required this.sizeBreakingPoint}) : super(key: key);
  int sizeBreakingPoint;
  String textFilePath = "texts/homePageBlock2.txt";
  List<Widget> widgetList = [];

  Widget _createWideBlock() {
    return Container(
      color: Colors.brown,
      child: SizedBox(
        height: 600,
        child: SizedBox.expand(
            child: FileToWidget(filePath: textFilePath).getFutureBuilder()),
      )
    );
  }

  Widget _createNormalBlock() {
    return Container(
      color: Colors.brown,
      child: FileToWidget(filePath: textFilePath).getFutureBuilder()
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Determines the width of the screen
          // If the size is larger then the breaking point, then web page format will be used, else phone format
          if (constraints.maxWidth > sizeBreakingPoint) {
            return _createWideBlock();
          } else {
            return _createNormalBlock();
          }
        },
    );
  }
}


