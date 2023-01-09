import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This class is a util class that reads a txt file and convert every line into a text widget.
/// Then combine all the text widgets into a block of widget.
///
/// After constructing this object, call getBlock for a block of widget or getFutureBuilder for a FutureBuilder widget.
///
/// Can be called within a sizedBox or a fractionallySizedBox to constraint the size
class FileToWidget {
  String filePath;
  double headerFontSize;
  double normalFontSize;

  FileToWidget({required this.filePath, this.headerFontSize = 24, this.normalFontSize = 14});

  // This function returns a FutureBuilder that builds the block.
  Widget getFutureBuilder() {
    return FutureBuilder(
      future: getBlock(),
      initialData: Container(color: Colors.brown,),
      builder: (BuildContext context, AsyncSnapshot<Widget> widget) {
        return Container(
          color: Colors.brown,
          child: widget.data,
        );
      },
    );
  }

  // This function returns a column that converted all the lines in a text file to customized widget.
  Future<Widget> getBlock() async{
    List<Widget> textWidgets = await _getLinesWidget();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: textWidgets,
    );
  }

  // This function reads the text file and convert the lines to text widgets
  Future<List<Widget>> _getLinesWidget() async {
    late List<String> lines;
    String textFile = await rootBundle.loadString(filePath);
    lines = textFile.split("\n");

    List<Widget> textWidgets = [];
    Future.forEach(lines, (String line) {
      textWidgets.add(_createLineWidget(line));
      print(line);
    });
    return textWidgets;
  }

  Widget _createLineWidget(String line) {
    late EdgeInsets padding;
    late FontWeight weight;
    late double fontSize;

    // If line starts with '###', this is a header line
    if(line.startsWith("###")) {
      padding = EdgeInsets.only(left: 30, right: 30, top: 60, bottom: 10);
      weight = FontWeight.w700;
      line = line.substring(3);
      fontSize = headerFontSize;
    } else {
      padding = EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10);
      weight = FontWeight.w400;
      fontSize = normalFontSize;
    }
    // Else this is not a heading
    return Padding(
      padding: padding,
      child: Text(line, style: TextStyle(fontWeight: weight, color: Colors.white, fontSize: fontSize),),
    );
  }

}