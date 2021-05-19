import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pyfin/utils/constants.dart';
import 'package:pyfin/widgets/testCard.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = (MediaQuery.of(context).size);
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('DailyQuiz').get(),
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
                                          print('Hello');
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
                                          print('Hello');
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
          // return Container(
          //   child: Column(
          //     children: [
          //       Container(
          //         height: size.height * 0.4,
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             Text(
          //               'Daily Quiz',
          //               style: TextStyle(
          //                   fontSize: size.height * 0.04,
          //                   fontWeight: FontWeight.bold,
          //                   color: kTextDark),
          //             ),
          //             ListView(
          //               scrollDirection: Axis.horizontal,
          //               children: documents.map((doc) => Card(
          //                 child: ListTile(
          //                   title: Text(doc['quizName']),
          //                 ),
          //               )).toList(),
          //             )
          //             // ListView.builder(
          //             //   scrollDirection: Axis.horizontal,
          //             //   itemCount: documents.length,
          //             //   itemBuilder: (context, index) {
          //             //     return Row(
          //             //         children: [
          //             //           TestCard(
          //             //             size: size,
          //             //             title: documents[index]['quizName'],
          //             //             onTap: () {
          //             //               print(documents[index]['quizName']);
          //             //             },
          //             //           ),
          //             //         ],
          //             //     );
          //             //   },
          //             // ),
          //           ],
          //         ),
          //       ),
          //       Container(
          //         height: MediaQuery.of(context).size.height * 0.4,
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             Text(
          //               'Weekly Quiz',
          //               style: TextStyle(
          //                   fontSize: size.height * 0.04,
          //                   fontWeight: FontWeight.bold,
          //                   color: kTextDark),
          //             ),
          //             SingleChildScrollView(
          //               scrollDirection: Axis.horizontal,
          //               child: Row(
          //                 children: [
          //                   TestCard(
          //                     size: size,
          //                     title: 'Demo Test',
          //                     onTap: () {
          //                       print('h');
          //                     },
          //                   ),
          //                   TestCard(
          //                     size: size,
          //                     title: 'Demo Test',
          //                     onTap: () {
          //                       print('h');
          //                     },
          //                   ),
          //                   TestCard(
          //                     size: size,
          //                     title: 'Demo Test',
          //                     onTap: () {
          //                       print('h');
          //                     },
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // );
        }
        return Text("loading");
      },
    );
  }
}
