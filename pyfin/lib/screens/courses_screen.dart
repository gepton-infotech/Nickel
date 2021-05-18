import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pyfin/model/profile.dart';
import 'package:pyfin/widgets/horizontal_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../utils/global.dart';
import '../services/crud.dart';

class CoursesScreen extends StatefulWidget {
  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  Pymaths crudmethods = new Pymaths();
  bool isloading = true;

  void showToast(message, Color color) {
    //print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  addStringToSF() async {
    print("SF INFO");
    //var s = json.encode(visible);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //var s = json.encode(map);
    prefs.setStringList('j', visible);
    prefs.setStringList('enrolledCoursesssssss', enrolled);
    box.put('map', map);
    print("done");
  }

  updateProfile() {
    //  addStringToSF();
    FirebaseFirestore.instance
        .collection("students")
        .doc(phone.replaceAll(' ', ''))
        .update({
      "enrolled": enrolled,
    });
  }

  getProfile(_phone) {
    Contact contact;
    crudmethods.getdata(_phone).then((result) {
      contact = Contact.fromDocument(result);
      //print(result)
      setState(() {
        print("in");
        // = contact.enrolled;
        isloading = false;
        //print(_courses);
      });
    });
  }

  Stream blogsStream;
  void initState() {
    super.initState();
    print(courses);
    crudmethods.getdata2().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              alignment: Alignment.center,
              child: Text(
                "Learn Anytime, Anywhere",
                style: TextStyle(
                    color: kTextDark,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                  //margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                      stream: blogsStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Container(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        // if (courses.contains(snapshot
                        //     .data.documents[index].data['courseName'])) {
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: snapshot.data.documents.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          //  primary: false,
                          itemBuilder: (context, index) {
                            //  print(snapshot
                            //    .data.documents[index].data['courseName']);
                            //if (courses.contains(snapshot
                            //  .data.documents[index].data['courseName'])) {
                            return Visibility(
                              visible: courses.contains(snapshot
                                  .data.documents[index].data['courseName']),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          snapshot.data.documents[index]
                                              .data['courseName'],
                                          style: kSubheadingextStyle.copyWith(
                                              color: kBlueColor),
                                        ),
                                      ),
                                      Container(
                                        //padding: EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: _enroll(
                                          index,
                                          snapshot.data.documents[index]
                                              .data['courseName'],
                                        ),
                                      )
                                    ],
                                  ),
                                  HorizontalView(
                                      snapshot.data.documents[index]
                                          .data['courseName'],
                                      index,
                                      snapshot.data.documents[index]
                                          .data['papers'].length,
                                      snapshot.data.documents[index]
                                          .data['papers']),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            );
                            //}
                            //return null;
                          },
                        );
                      })),
            )
          ],
        ),
      ),
    );
  }

  Widget _enroll(int index, String name) {
    if (!enrolled.contains(name)) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: kBlueColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14))),
        ),
        onPressed: () {
          //print("in");
          setState(() {
            visible[index] = "0";
            enrolled.add(name);
            percentage.add("0");
            map[name] = index;
            print(map);
            print(map[name]);
            print(percentage);
            print(enrolled);
            //print(double.parse(percentage[0]) / 100);
          });
          updateProfile();
          addStringToSF();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Enroll',
                style: TextStyle(color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  //color: Colors.lightGreen,
                ),
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 16,
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return RaisedButton(
        onPressed: () {
          //print("in");
          showToast("You are already enrolled to this course", kBlueColor);
        },
        color: kBlueColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Enrolled',
                style: TextStyle(color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  //color: Colors.lightGreen,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
