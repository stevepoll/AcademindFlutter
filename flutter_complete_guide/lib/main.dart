import 'package:flutter/material.dart';

import 'quiz.dart';
import 'result.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _questions = const [
    {
      "questionText": "What's your favorite color?",
      "answers": [
        {"text": "Black", "score": 10},
        {"text": "Blue", "score": 7},
        {"text": "Red", "score": 4},
        {"text": "Green", "score": 1},
      ],
    },
    {
      "questionText": "What's your favorite animal?",
      "answers": [
        {"text": "Giraffe", "score": 10},
        {"text": "Dog", "score": 7},
        {"text": "Cat", "score": 4},
        {"text": "Elephant", "score": 1},
      ],
    },
    {
      "questionText": "Who is your favorite author?",
      "answers": [
        {"text": "Stephen King", "score": 10},
        {"text": "Brandon Sanderson", "score": 7},
        {"text": "Frederick Backman", "score": 4},
        {"text": "Don Winslow", "score": 1},
      ],
    },
  ];

  var _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
    _questionIndex = 0;
    _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;

    setState(() {
      _questionIndex++;
    });
  }

  Widget getBody() {
    if (_questionIndex < _questions.length) {
      return Quiz(
        answerQuestion: _answerQuestion,
        questionIndex: _questionIndex,
        questions: _questions,
      );
    } else {
      return Result(_totalScore, _resetQuiz);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App'),
        ),
        body: getBody(),
      ),
    );
  }
}
