import 'package:flutter/material.dart';
import 'package:pyfin/screens/courses_screen.dart';
import 'package:pyfin/screens/new_homepage.dart';
import 'package:pyfin/screens/profile2.dart';
import 'package:pyfin/screens/sign_up_screen.dart';
import '../utils/global.dart';
import '../services/crud.dart';

class SideNavBar extends StatefulWidget {
  @override
  _SideNavBarState createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _photoUrl = '';

  pymaths crudmethods = new pymaths();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
                "$firstname".toUpperCase() + " " + "$lastname".toUpperCase()),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(photourl),
              backgroundColor: Colors.orange,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.video_call),
            title: Text('Courses'),
            onTap: () => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CoursesScreen()),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle),
            title: Text('Profile'),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(phone)),
            ).then((value) => setState(() {
                  print("refresh");
                  // print(photourl);
                })),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignUpPage())),
          ),
        ],
      ),
    );
  }
}
