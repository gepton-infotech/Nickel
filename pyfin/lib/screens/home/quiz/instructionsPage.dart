import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pyfin/screens/home/quiz/questionPage.dart';

class InstructionsPage extends StatelessWidget {
  final DocumentSnapshot _quizData;
  InstructionsPage(this._quizData);

  @override
  Widget build(BuildContext context) {
    final _id = _quizData.id;
    return Scaffold(
        appBar: AppBar(
          title: Text(_quizData['quizName']),
        ),
        body: Container(
          child: Column(
            children: [
              Text('Instructions'),
              Text(_quizData['description']),
              ElevatedButton(
                child: Text('Continue'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionPage(_quizData.id),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
