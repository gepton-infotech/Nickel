import 'package:flutter/material.dart';
import 'package:pyfin/utils/constants.dart';

class MenuTile extends StatelessWidget {
  final onPressed;
  final IconData leadingIcon;
  final String title;
  MenuTile({this.leadingIcon, this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onPressed,
        leading: CircleAvatar(
          backgroundColor: kComplimentaryColor,
          child: Icon(
            leadingIcon,
            color: kTextLight,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
