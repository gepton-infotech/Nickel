import 'package:flutter/material.dart';
import 'package:pyfin/utils/constants.dart';

class TestCard extends StatelessWidget {
  const TestCard({@required this.size, this.onTap, this.title});

  final Size size;
  final Function onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: kPrimaryColor,
          ),
          height: size.height * 0.25,
          width: size.height * 0.25,
          child: Center(
            child: Text(
              title,
              style: TextStyle(color: kTextLight, fontSize: 30.0),
            ),
          ),
        ),
      ),
    );
  }
}
