// 3) Split the app into three widgets: App, TextControl & Text
import 'package:flutter/material.dart';
import 'text_control.dart';
import 'my_text.dart';

void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}


class MyAppState extends State<MyApp> {
  var message = "Hello world!";

  void buttonPressed() {
    setState(() {
      message = "Goodbye cruel world!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("I am Data!"),
        ),
        body: Column(
          children: <Widget>[
            MyText(message),
            MyTextControl(buttonPressed),
          ],
        ),
      ),
    );
  }
}

