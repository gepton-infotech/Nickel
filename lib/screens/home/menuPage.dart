import 'package:flutter/material.dart';
import 'package:pyfin/screens/home/contactPage.dart';
import 'package:pyfin/screens/home/developerInfo.dart';
import 'package:pyfin/screens/profile2.dart';
import 'package:pyfin/utils/global.dart';
import 'package:pyfin/widgets/menuTile.dart';

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
            child: CircleAvatar(
              child: Icon(
                Icons.supervised_user_circle,
                size: MediaQuery.of(context).size.height * 0.15,
              ),
            ),
          ),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactPage()),
              );
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          MenuTile(
            leadingIcon: Icons.people,
            title: 'Developer Info',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Gepton()),
              );
            },
          ),
          MenuTile(
            leadingIcon: Icons.policy,
            title: 'Privacy Policy',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(phone)),
              );
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          ElevatedButton(
            onPressed: () {
              print('Hello');
            },
            child: Text('Logout'),
          )
        ],
      ),
    );
  }
}
