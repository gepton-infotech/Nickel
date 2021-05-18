import 'package:flutter/material.dart';
import 'package:pyfin/widgets/course_card.dart';

class HorizontalView extends StatelessWidget {
  final String _sendName;
  final int _sendIndex;
  final int _itemcount;
  final List _items;
  HorizontalView(this._sendName, this._sendIndex, this._itemcount, this._items);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _itemcount,
        itemBuilder: (context, index) =>
            CourseCard(this._sendName, this._sendIndex, _items[index]),
      ),
    );
  }
}
