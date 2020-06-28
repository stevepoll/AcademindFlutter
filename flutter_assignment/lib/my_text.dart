import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String message;

  MyText(this.message);

  @override
  Widget build(BuildContext context) {
    return Text(message);
  }
}