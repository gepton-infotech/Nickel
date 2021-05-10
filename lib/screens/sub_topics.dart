import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pyfin/model/chapters.dart';
import 'package:pyfin/screens/content_heading.dart';
import 'package:pyfin/services/crud.dart';

import '../utils/constants.dart';
import '../utils/global.dart';

class SubTopics extends StatefulWidget {
  final String _sendName;
  final int _sendIndex;
  final List _subtTopics;
  final String _subTopicName;
  SubTopics(
      this._sendName, this._sendIndex, this._subtTopics, this._subTopicName);
  @override
  _SubTopicsState createState() => _SubTopicsState();
}

class _SubTopicsState extends State<SubTopics> {
  var _icon = Icon(
    Icons.list,
  );
  List<String> _name = [];
  List<List> _topics = [];
  List<String> _completedTopics = List<String>();

  bool isloading = true;
  Pymaths crudmethods = new Pymaths();

  addStringToSF() async {
    print("SF INFO");
    //  var s = json.encode(visible);
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setStringList('selecteddddddd', selectedi);
    box.put('selectedii', selectedi);
  }

  updateProfile() {
    //  addStringToSF();
    Firestore.instance
        .collection("students")
        .document(phone.replaceAll(' ', ''))
        .updateData({
      "completedTopics": this._completedTopics,
    });
  }

  getContent2(name) {
    Chapter chapter;
    crudmethods.getContent2(name).then((result) {
      chapter = Chapter.fromSnap(result);

      setState(() {
        print(chapter.name);
        print(chapter.topics);
        _name.add(chapter.name);
        _topics.add(chapter.topics);
        isloading = false;
      });
    });
  }

  void initState() {
    super.initState();
    print(widget._subtTopics);
    print("hellllo");

    for (int i = 0; i < widget._subtTopics.length; i++) {
      getContent2(widget._subtTopics[i]);
    }
    if (enrolled.contains(widget._sendName)) {
      add = (100 / (widget._subtTopics.length));
      print("add:" + "$add");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBlueColor,
        appBar: AppBar(
          backgroundColor: kBlueColor,
          elevation: 0,
        ),
        body: isloading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Column(children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: kBlueColor,
                      image: DecorationImage(
                        alignment: Alignment.centerLeft,
                        image:
                            AssetImage("assets/images/undraw_pilates_gpdb.png"),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Modules And",
                                style: kHeadingextStyle.copyWith(
                                    color: Colors.white),
                              ),
                              Text("Topics",
                                  style: kHeadingextStyle.copyWith(
                                      color: Colors.white)),
                              SizedBox(
                                height: 20,
                              ),
                              Text(widget._subTopicName + " " + ":",
                                  style: kHeadingextStyle.copyWith(
                                      color: Colors.white))
                            ],
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: this._name.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: ListTile(
                                  leading: _icon,
                                  title: Text(
                                    _name[index],
                                    style: kSubtitleTextSyule.copyWith(
                                        fontSize: 20, color: null),
                                  ),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  onTap: () {
                                    setState(() {
                                      print(index);
                                      if (enrolled.contains(widget._sendName)) {
                                        selectedi[widget._sendIndex][index] =
                                            "1";
                                      }
                                      _completedTopics
                                          .add(widget._subtTopics[index]);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ContentHeading(
                                                      widget._sendName,
                                                      widget._sendIndex,
                                                      this._topics[index],
                                                      _name[index])));
                                    });
                                    updateProfile();
                                    addStringToSF();
                                  },
                                  selected: selectedi[widget._sendIndex]
                                          [index] ==
                                      "1"),
                            );
                          }),
                    ),
                  ),
                ])));
  }
}
