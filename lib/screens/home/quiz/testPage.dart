import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pyfin/utils/constants.dart';
import 'package:pyfin/widgets/testCard.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = (MediaQuery.of(context).size);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('DailyQuiz').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('Something Went Wrong');
        }
        // if ( && !snapshot.data.exists) {
        //   return Text('No Active Test Found');
        // }
        if (snapshot.hasData) {
          return Container(
            child: Column(
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
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              TestCard(
                                size: size,
                                title: snapshot.data.docs.data()['quizName'],
                                onTap: () {
                                  print(snapshot.data.docs.data()['quizName']);
                                },
                              ),
                              TestCard(
                                size: size,
                                title: 'Daily Quiz',
                                onTap: () {
                                  print('h');
                                },
                              ),
                              TestCard(
                                size: size,
                                title: 'Daily Quiz',
                                onTap: () {
                                  print('h');
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            TestCard(
                              size: size,
                              title: 'Demo Test',
                              onTap: () {
                                print('h');
                              },
                            ),
                            TestCard(
                              size: size,
                              title: 'Demo Test',
                              onTap: () {
                                print('h');
                              },
                            ),
                            TestCard(
                              size: size,
                              title: 'Demo Test',
                              onTap: () {
                                print('h');
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Text("loading");
      },
    );
  }
}
