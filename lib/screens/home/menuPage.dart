import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
              child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text('Menu'),
              )
            ],
          )),
          ListTile(
            title: Text('Profile'),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                print('Hello');
              },
              child: Text('Logout'),
            ),
          )
        ],
      ),
    ));
  }
}
