import 'package:flutter/material.dart';
import 'package:tic_tac_toe/UI/AboutPage.dart';
import 'package:tic_tac_toe/UI/AppPages.dart';
import 'package:tic_tac_toe/UI/HomePage.dart';
import 'package:tic_tac_toe/UI/PageViewScrollBehavior.dart';
import 'package:tic_tac_toe/UI/PlayPage.dart';
import 'package:tic_tac_toe/UI/SupportPage.dart';
import 'package:url_launcher/url_launcher.dart';

Container footer = Container(
  color: Colors.blueGrey,
  child: Row(
    children: [
      Expanded(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: const Text("© 2023 Donald Tsang, Titus Wong. All rights reserved", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white),),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: InkWell(
                  child: const Text("https://github.com/RocketDonald/Tic_Tac_Toe_AI_Flutter", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.white),),
                  onTap: () => launchUrl(Uri.parse("https://github.com/RocketDonald/Tic_Tac_Toe_AI_Flutter")),
                ),
              )
            ],
          ),
      ),
    ],
  ),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicTacToe.AI',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.greenAccent,
        fontFamily: 'Montserrat',
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueGrey,
            textStyle: const TextStyle(fontSize: 17, fontFamily: 'Montserrat'),
          )
        )
      ),
      scrollBehavior: PageViewScrollBehavior(),
      home: const Foundation(),
    );
  }
}

class Foundation extends StatefulWidget {
  const Foundation({Key? key}) : super(key: key);
  @override
  _FoundationState createState() => _FoundationState();
}

class _FoundationState extends State<Foundation> {
  String pageTitle = "";
  String homePageTitle = "Home";
  String playPageTitle = "Play Against";
  String aboutPageTitle = "About";
  String supportPageTitle = "Support Us";

  static const HOME = 0;
  static const ABOUT = 1;
  static const PLAY = 2;
  static const SUPPORT = 3;

  // Create a key for the widget to open drawer
  final  GlobalKey<ScaffoldState> _key = GlobalKey();
  int sizeBreakingPoint = 800;

  // Lists of pages that the user can be redirected to
  late List<AppPages> appPages = [HomePage(widthBreakPoint: sizeBreakingPoint, goToNextPage: changePageTo,), AboutPage(),
    PlayPage(widthBreakPoint: sizeBreakingPoint, dialogScaffoldKey: _key,), SupportPage(widthBreakingPoint: sizeBreakingPoint)];

  int currentIndex = 0;
  late AppPages currentPage = HomePage(widthBreakPoint: sizeBreakingPoint, goToNextPage: changePageTo,);


  void changePageTo(int index) {
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
        currentPage = appPages[currentIndex];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Determines the width of the screen
          // If the size is larger then the breaking point, then web page format will be used, else phone format
          if (constraints.maxWidth > sizeBreakingPoint) {
            return _buildWideContainers(_key);
          } else {
            return _buildNormalContainers(_key);
          }
        },
      ),
    );
  }

  Widget _buildWideContainers(GlobalKey key) {
    return SafeArea(
      child: Scaffold(
        key: key,
        appBar: AppBar(
          foregroundColor: Colors.greenAccent,
          backgroundColor: Colors.white,
          leading: const Padding(
            padding: EdgeInsets.only(left: 12, top: 12),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              children: [
                Icon(Icons.circle_outlined, size: 16,),
                Icon(Icons.close, size: 16),
                Icon(Icons.circle_outlined, size: 16),
              ],
            ),
          ),
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextButton(
                  onPressed: () => {
                    changePageTo(HOME)
                  },
                  child: Text(homePageTitle),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextButton(
                  onPressed: () {
                    changePageTo(ABOUT);
                  },
                  child: Text(aboutPageTitle),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextButton(
                  onPressed: () {
                    changePageTo(PLAY);
                  },
                  child: Text(playPageTitle),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextButton(
                  onPressed: () {
                    changePageTo(SUPPORT);
                  },
                  child: Text(supportPageTitle),
                ),
              )
            ],
          ),
        ),
        body: currentPage,
        bottomSheet: footer,
      ),
    );
  }

  // Container for smaller screens (e.g. phone)
  Widget _buildNormalContainers(GlobalKey<ScaffoldState> key) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(pageTitle),
        leading: IconButton(
          onPressed: () {
            key.currentState!.openDrawer();
          },
          icon: const Icon(Icons.menu, color: Colors.greenAccent,),
        ),
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const ListTile(
              tileColor: Colors.greenAccent,
              title: Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Center(child: Text("Tic Tac Toe")),
              )
            ),
            ListTile(
              leading: const Icon(Icons.arrow_back_ios_outlined, color: Colors.greenAccent,),
              title: const Text("back"),
              contentPadding: EdgeInsets.only(right: 30, left: 30),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(homePageTitle),
              leading: const Icon(Icons.home_outlined, color: Colors.greenAccent),
              contentPadding: EdgeInsets.only(right: 30, left: 30),
              onTap: () {
                changePageTo(HOME);
              },
            ),
            ListTile(
              title: Text(playPageTitle),
              leading: const Icon(Icons.play_arrow_outlined, color: Colors.greenAccent),
              contentPadding: EdgeInsets.only(right: 30, left: 30),
              onTap: () {
                changePageTo(PLAY);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.greenAccent,),
              title: Text(aboutPageTitle),
              contentPadding: EdgeInsets.only(right: 30, left: 30),
              onTap: () {
                changePageTo(ABOUT);
              },
            ),
            ListTile(
              leading: const Icon(Icons.support, color: Colors.greenAccent,),
              title: Text(supportPageTitle),
              contentPadding: EdgeInsets.only(right: 30, left: 30),
              onTap: () {
                changePageTo(SUPPORT);
              },
            ),
          ],
        ),
      ),
      body: currentPage,
      bottomSheet: footer,
    );
  }
}

