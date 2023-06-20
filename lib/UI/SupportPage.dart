import 'package:flutter/material.dart';
import 'package:tic_tac_toe/UI/AppPages.dart';
import 'package:url_launcher/url_launcher.dart';

TextStyle defTextStyle = const TextStyle(
  color: Colors.black87,
  fontWeight: FontWeight.w400,
);

class SupportPage extends StatelessWidget implements AppPages{
  final int widthBreakingPoint;

  SupportPage({Key? key, required this.widthBreakingPoint}) : super(key: key);

  Widget _createPersonalInfo(String name, String major, String github) {
    String githubLink = "github.com/$github";
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          const Divider(
            color: Colors.black,
          ),
          const Padding(
            padding: EdgeInsets.all(3.0),
            child: Icon(
              Icons.school_outlined,
              color: Colors.greenAccent,
              size: 24,
              semanticLabel: "Education",
            ),
          ),
          const Padding(
              padding: EdgeInsets.all(1),
              child: Text("University of British Columbia"),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text(major, textAlign: TextAlign.center,),
          ),
          const Padding(
            padding: EdgeInsets.all(3),
            child: Icon(
              Icons.link,
              color: Colors.greenAccent,
              size: 24,
              semanticLabel: "Github Link",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: InkWell(
              child: Text(githubLink),
              onTap: () => launchUrl(Uri.parse("https://$githubLink")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wide() {
    return Container(
      padding: const EdgeInsets.all(50),
      // DefaultTextStyle.merge()
      child: Center(
        child: DefaultTextStyle.merge(
            style: defTextStyle,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                    "Contributors",
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
                _createPersonalInfo("Donald Tsang", "BSc. Major in Integrated Science (Computer Science and Psychology)", "RocketDonald"),
                _createPersonalInfo("Titus Wong", "BSc. Major in Computer Science", "titus125"),
              ],
            )
        ),
      ),
    );
  }

  Widget _normal() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: DefaultTextStyle.merge(
            style: defTextStyle,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Contributors",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                _createPersonalInfo("Donald Tsang", "BSc. Major in Integrated Science (Computer Science and Psychology)", "rocketdonald"),
                _createPersonalInfo("Titus Wong", "BSc. Major in Computer Science", "titus125"),
              ],
            )
        ),
      ),
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
