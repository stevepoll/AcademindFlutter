import 'package:flutter/material.dart';

class MyTextControl extends StatelessWidget {
  final Function buttonPressed;

  MyTextControl(this.buttonPressed);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Press Me"),
      onPressed: buttonPressed,
    );
  }
}
