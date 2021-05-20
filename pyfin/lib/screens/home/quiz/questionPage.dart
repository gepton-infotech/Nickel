import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pyfin/widgets/quizButton.dart';

class QuestionPage extends StatefulWidget {
  final String _quizID;
  QuestionPage(this._quizID);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Questions'),
          leading: Container(),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('quizes')
              .doc(widget._quizID)
              .collection('questions')
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> questions =
                  snapshot.data.docs.toList();
              return index < questions.length
                  ? Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(questions[index]['question']),
                          Text(questions[index]['answer']),
                          QuizButton(
                            onSubmission: () {
                              setState(() {
                                index++;
                              });
                            },
                            onPressed: () {
                              setState(() {
                                index++;
                              });
                            },
                            index: index,
                            length: questions.length,
                          )
                        ],
                      ),
                    )
                  : Text('Results');
            } else if (snapshot.hasError) {
              return Text('Error');
            }
            return CircularProgressIndicator();
          },
        ));
  }
}
