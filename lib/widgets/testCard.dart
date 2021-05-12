import 'package:flutter/material.dart';
import 'package:pyfin/utils/constants.dart';

class TestCard extends StatelessWidget {
  const TestCard({
    @required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          print('Hello World');
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: kComplimentaryColor,
          ),
          height: size.height * 0.25,
          width: size.height * 0.25,
          child: Center(
            child: Text(
              'Demo Test',
              style: TextStyle(color: kTextLight, fontSize: 30.0),
            ),
          ),
        ),
      ),
    );
  }
}
