import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pyfin/screens/new_homepage.dart';
import 'package:pyfin/services/push_notification.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../global.dart';
import 'sign_up_screen.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  Future<bool> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('phoneee');
    String stringValue2 = prefs.getString('firstNamee');
    String stringValue3 = prefs.getString('lastNamee');
    String stringValue4 = prefs.getString('emaill');
    String stringValue5 = prefs.getString('photourll');
    String stringValue6 = prefs.getString('photocoverr');
    List<String> stringValue7 = prefs.getStringList('j'); //enrolled
    List<String> stringValue10 = prefs.getStringList('enrolledCoursesssssss');
    List<String> stringValue11 = prefs.getStringList('percentageeeeeeeeeeee');
    var name = box.get('map');
    List<dynamic> name2 = box.get('selectedii');

    List<dynamic> name3 = box.get('selectedjjj');

    List<dynamic> name4 = box.get('courses');

    setState(() {
      phone = stringValue;
      firstname = stringValue2;
      lastname = stringValue3;
      email = stringValue4;
      if (stringValue5 != null) {
        photourl = stringValue5;
      }
      if (stringValue6 != null) {
        photocover = stringValue6;
      }
      if (stringValue7 != null) {
        visible = stringValue7;
      }
      if (name2 != null) {
        selectedi = name2;
      }
      if (name3 != null) {
        selectedjj = name3;
        //print(selectedjj);
      }
      if (stringValue10 != null) {
        enrolled = stringValue10;
      }
      if (stringValue11 != null) {
        percentage = stringValue11;
        //   print(percentage);
      }

      if (name != null) {
        map = name;
      }
      if (name4 != null) {
        courses = name4;
        // print(courses);
      }

      //  print('Name: $name');
    });
    return stringValue == null;
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  PushNotificationsManager _pushNotificationsManager =
      PushNotificationsManager();

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token) {
      print("token=$token");
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: FutureBuilder<bool>(
      future: getStringValuesSF(),
      builder: (buildContext, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            // Return your login here

            return SignUpPage();
          }
          //_pushNotificationsManager.init();
          // Return your home here
          return HomeScreen();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
}
