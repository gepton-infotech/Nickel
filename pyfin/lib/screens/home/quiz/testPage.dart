import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pyfin/screens/home/quiz/instructionsPage.dart';
import 'package:pyfin/utils/constants.dart';
import 'package:pyfin/widgets/testCard.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = (MediaQuery.of(context).size);
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('quizes').get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('Something Went Wrong');
        } else if (snapshot.hasData) {
          final List<DocumentSnapshot> dailyQuizDocuments = snapshot.data.docs
              .where((DocumentSnapshot documentSnapshot) =>
                  documentSnapshot['isDaily'] == true &&
                  documentSnapshot['isActive'] == true)
              .toList();
          final List<DocumentSnapshot> weeklyQuizDocuments = snapshot.data.docs
              .where((DocumentSnapshot documentSnapshot) =>
                  documentSnapshot['isDaily'] == false &&
                  documentSnapshot['isActive'] == true)
              .toList();
          return Column(
            children: [
              Container(
                height: size.height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Daily Quiz',
                      style: TextStyle(
                          fontSize: size.height * 0.04,
                          fontWeight: FontWeight.bold,
                          color: kTextDark),
                    ),
                    dailyQuizDocuments.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: dailyQuizDocuments
                                    .map(
                                      (doc) => TestCard(
                                        size: size,
                                        title: doc['quizName'],
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      InstructionsPage(doc)));
                                        },
                                      ),
                                    )
                                    .toList()),
                          )
                        : Text('No Active Quiz Found')
                  ],
                ),
              ),
              Container(
                height: size.height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Weekly Quiz',
                      style: TextStyle(
                          fontSize: size.height * 0.04,
                          fontWeight: FontWeight.bold,
                          color: kTextDark),
                    ),
                    weeklyQuizDocuments.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: weeklyQuizDocuments
                                    .map(
                                      (doc) => TestCard(
                                        size: size,
                                        title: doc['quizName'],
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      InstructionsPage(doc)));
                                        },
                                      ),
                                    )
                                    .toList()),
                          )
                        : Text('No Active Quiz Found')
                  ],
                ),
              ),
            ],
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
