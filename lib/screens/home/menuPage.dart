import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pyfin/screens/profile2.dart';
import 'package:pyfin/screens/sign_up_screen.dart';
import 'package:pyfin/utils/global.dart';
import 'package:pyfin/utils/urlLauncher.dart';
import 'package:pyfin/widgets/menuTile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(photocover),
                    foregroundImage: NetworkImage(photourl),
                    radius: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Text(
                    '$firstname $lastname',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03),
                  ),
                ],
              )),
          MenuTile(
            leadingIcon: Icons.person,
            title: 'Your Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(phone)),
              );
            },
          ),
          MenuTile(
            leadingIcon: Icons.contact_page,
            title: 'Contact Us',
            onPressed: () {
              launchURL('https://pyfinacademy.com/contact');
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          MenuTile(
            leadingIcon: Icons.people,
            title: 'Developer Info',
            onPressed: () {
              launchURL('https://gepton.com');
            },
          ),
          MenuTile(
            leadingIcon: Icons.policy,
            title: 'Privacy Policy',
            onPressed: () {
              launchURL('https://pyfinacademy.com/privacy');
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          ElevatedButton(
            onPressed: () {
              _removeUserData(context);
            },
            child: Text('Logout'),
          )
        ],
      ),
    );
  }

  _removeUserData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getKeys();
    prefs.clear();
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage()),
        (Route<dynamic> route) => false);
  }
}
