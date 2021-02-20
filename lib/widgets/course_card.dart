import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pyfin/constants.dart';
import 'package:pyfin/global.dart';
import 'package:pyfin/model/courses.dart';
import 'package:pyfin/screens/sub_topics.dart';
import 'package:pyfin/services/crud.dart';

class CourseCard extends StatefulWidget {
  String _sendName;
  int _sendIndex;
  final String _items;
  CourseCard(this._sendName, this._sendIndex, this._items);
  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  String _name = "";
  List _chapters;
  bool isloading = true;
  pymaths crudmethods = new pymaths();
  Stream constream;

  getContent(name) {
    //print("hello");
    Course course;
    crudmethods.getContent(name).then((result) {
      course = Course.fromSnap(result);

      setState(() {
        _name = course.name;
        _chapters = course.chapters;
        isloading = false;
        //print(_chapters);
      });
    });
  }

  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    getContent(widget._items);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: () {
          if (enrolled.contains(widget._sendName)) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SubTopics(widget._sendName,
                    widget._sendIndex, this._chapters, this._name)));
          } else {
            showToast("Please Enroll to unlock the course", kBlueColor);
          }
        },
        child: Container(
          width: 202,
          // color: Colors.grey,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            // color: Colors.pink,
            elevation: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  //leading: Icon(Icons.album, size: 20),
                  title: Text(
                    _name,
                    style: kSubheadingextStyle,
                  ),
                  // subtitle: Text(
                  //   'this is some random message',
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
