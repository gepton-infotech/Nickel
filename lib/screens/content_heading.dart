import 'package:flutter/material.dart';
import 'package:pyfin/model/topic.dart';

import 'package:pyfin/screens/content_screen.dart';
import 'package:pyfin/services/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../utils/global.dart';

class ContentHeading extends StatefulWidget {
  final String _sendName;
  final int _sendIndex;
  final List _subContent;
  final String _subContentName;
  ContentHeading(
      this._sendName, this._sendIndex, this._subContent, this._subContentName);
  @override
  _ContentHeadingState createState() => _ContentHeadingState();
}

class _ContentHeadingState extends State<ContentHeading> {
  var _icon = Icon(
    Icons.list,
  );
  List<String> _name = [];
  List<String> _content = [];
  // List<String> _completedTopics = List<String>();

  bool isloading = true;
  pymaths crudmethods = new pymaths();

  getContent3(name) {
    Topic topic;
    crudmethods.getContent3(name).then((result) {
      topic = Topic.fromSnap(result);

      setState(() {
        //print(topic.name);
        //print(topic.content);
        _name.add(topic.name);
        _content.add(topic.content);
        isloading = false;
      });
    });
  }

  // updateProfile() {
  //   //  addStringToSF();
  //   Firestore.instance.collection("students").document(phone).updateData({
  //     "completedTopics": this._completedTopics,
  //   });
  // }

  void initState() {
    super.initState();
    print("sub content.....!!!");

    for (int i = 0; i < widget._subContent.length; i++) {
      getContent3(widget._subContent[i]);
    }
    if (enrolled.contains(widget._sendName)) {
      add /= (widget._subContent.length);
      print("add:" + "$add");
    }
    print(this._name.length);
  }

  addStringToSF() async {
    print("SF INFO");

    //box.put('percentage', percentage);

    // //  var s = json.encode(visible);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setStringList('selectedjjjjjjjj', selectedjj);
    prefs.setStringList('percentageeeeeeeeeeee', percentage);
    box.put('selectedjjj', selectedjj);
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
                                "Syallabus",
                                style: kHeadingextStyle.copyWith(
                                    color: Colors.white),
                              ),
                              // Text("Topics",
                              //     style: kHeadingextStyle.copyWith(
                              //         color: Colors.white)),
                              SizedBox(
                                height: 20,
                              ),
                              Text(widget._subContentName + " " + ":",
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
                                      if (selectedjj[widget._sendIndex]
                                                  [index] ==
                                              "0" &&
                                          enrolled.contains(widget._sendName)) {
                                        print("in");
                                        percent += add;
                                        percentage[widget._sendIndex] =
                                            "$percent";
                                      }
                                      if (enrolled.contains(widget._sendName)) {
                                        selectedjj[widget._sendIndex][index] =
                                            "1";
                                      }

                                      // _completedTopics
                                      //     .add(widget._subContent[index]);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ContentScreen(_name, _content,
                                                      index, _name.length)));
                                    });
                                    //updateProfile();
                                    addStringToSF();
                                  },
                                  selected: selectedjj[widget._sendIndex]
                                          [index] ==
                                      "1"),
                            );
                          }),
                    ),
                  ),
                ])));
  }
}
