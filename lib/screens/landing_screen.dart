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
    String phone = prefs.getString('phoneee');
    String firstName = prefs.getString('firstName');
    String lastName = prefs.getString('lastName');
    String email = prefs.getString('emaill');
    String photoUrl = prefs.getString('photourl');
    String photoCover = prefs.getString('photocover');
    List<String> stringValue7 = prefs.getStringList('j'); //enrolled
    List<String> stringValue10 = prefs.getStringList('enrolledCoursesssssss');
    List<String> stringValue11 = prefs.getStringList('percentageeeeeeeeeeee');
    var name = box.get('map');
    List<dynamic> name2 = box.get('selectedii');

    List<dynamic> name3 = box.get('selectedjjj');

    List<dynamic> name4 = box.get('courses');

    setState(() {
      phone = phone;
      firstname = firstName;
      lastname = lastName;
      email = email;
      if (photoUrl != null) {
        photourl = photoUrl;
      }
      if (photoCover != null) {
        photocover = photoCover;
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
    return phone == null;
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
          return HomeScreen();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
}
