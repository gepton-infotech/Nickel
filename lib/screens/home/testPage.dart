import 'package:flutter/material.dart';
import 'package:pyfin/utils/constants.dart';
import 'package:pyfin/widgets/testCard.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = (MediaQuery.of(context).size);
    return Container(
      child: Column(
        children: [
          Container(
            height: size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Daily Quiz',
                  style: TextStyle(
                      fontSize: size.height * 0.04,
                      fontWeight: FontWeight.bold,
                      color: kTextDark),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TestCard(size: size),
                      TestCard(size: size),
                      TestCard(size: size),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Weekly Quiz',
                  style: TextStyle(
                      fontSize: size.height * 0.04,
                      fontWeight: FontWeight.bold,
                      color: kTextDark),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TestCard(size: size),
                      TestCard(size: size),
                      TestCard(size: size),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
