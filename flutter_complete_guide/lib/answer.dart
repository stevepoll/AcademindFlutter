import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final Function answerSelected;
  final String answerText;

  Answer(this.answerSelected, this.answerText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: Text(answerText),
        onPressed: answerSelected,
      ),
    );
  }
}
