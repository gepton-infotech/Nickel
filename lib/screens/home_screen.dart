import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pyfin/global.dart';
import 'package:pyfin/screens/courses_screen.dart';
import 'package:pyfin/services/crud.dart';
import 'package:pyfin/widgets/nav_drawer.dart';
import 'package:slimy_card/slimy_card.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  pymaths crudmethods = new pymaths();

  Stream blogsStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(map);

    crudmethods.getInfo().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: kBlueColor,
      appBar: AppBar(
        backgroundColor: kBlueColor,
        title: Text("Home"),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: SideNavBar(),
      body: Container(
        child: ListView(
          children: [
            Container(
              //color: kBlueColor,
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Welcome $firstname $lastname".toUpperCase(),
                    style: kHeadingextStyle.copyWith(fontSize: 20),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: kBlueColor.withOpacity(0.7)),
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 25.0, bottom: 25),
                child: Scrollbar(
                  //isAlwaysShown: true,
                  //controller: _scrollController,
                  child: Column(
                    //shrinkWrap: true,
                    children: [
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Current Progress',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          new Column(
                            //    mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.close_fullscreen_rounded,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: StreamBuilder(
                            stream: blogsStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.active) {
                                return Container(
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )),
                                );
                              } else {
                                if (snapshot.data['enrolled'].length == 0) {
                                  return Container(
                                    height: 100,
                                    child: Center(
                                      child: Text(
                                        "Please enroll in some courses to see your progress here",
                                        style: kSubtitleTextSyule,
                                      ),
                                    ),
                                  );
                                } else {
                                  return ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    itemCount: snapshot.data['enrolled'].length,
                                    shrinkWrap: true,
                                    // controller: _scrollController,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          //color: Colors.redAccent,
                                          height: 120.0,
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 16.0,
                                            horizontal: 24.0,
                                          ),
                                          child: new Stack(
                                            children: <Widget>[
                                              card(snapshot.data['enrolled'],
                                                  index),
                                              thumbnail(
                                                  snapshot.data['enrolled'],
                                                  index),
                                            ],
                                          ));
                                    },
                                  );
                                }
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              //  height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            'List of enrolled courses',
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      new Column(
                        //    mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisSize: MainAxisSize.min,
                        children: <Widget>[Icon(Icons.download_done_outlined)],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // color: Colors.red,
                    height: 350,
                    child: StreamBuilder(
                        stream: blogsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.active) {
                            return Container(
                              child: Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )),
                            );
                          } else {
                            if (snapshot.data['enrolled'].length == 0) {
                              return Container(
                                height: 100,
                                child: Center(
                                  child: Text(
                                    "Please enroll in some courses to see your progress here",
                                    style: kSubtitleTextSyule,
                                  ),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data['enrolled'].length,
                                itemBuilder: (context, index) => _slimycard(
                                    snapshot.data['enrolled'], index),
                              );
                            }
                          }
                        }),
                  ),
                ],
              ),
            ),
            //start from here......
          ],
        ),
      ),
    );
  }

  myWidget01(String _name) {
    return Container(
      child: Center(
          child: Text(
        _name,
        style: kSubtitleTextSyule,
      )),
    );
  }

  myWidget02() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CoursesScreen()),
            );
          },
          color: kGreenColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14))),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'View courses',
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    //color: Colors.lightGreen,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 15,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  thumbnail(List<dynamic> _name, int index) => new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.centerLeft,
      child: CircularPercentIndicator(
        radius: 70.0,
        lineWidth: 7.0,
        percent: (double.parse(percentage[map[_name[index]]]) / 100),
        animation: true,
        circularStrokeCap: CircularStrokeCap.round,
        //progressColor: Colors.purple,
        center: new Text(
          double.parse(percentage[map[_name[index]]]).toStringAsFixed(1) + "%",
          //"%",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        progressColor: Colors.green,
      ));

  card(List<dynamic> _name, int _index) => new Container(
        height: 120.0,
        margin: new EdgeInsets.only(left: 46.0),
        decoration: new BoxDecoration(
          color: Colors.lightBlueAccent,
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: new Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Center(
            child: Text(
          _name[_index],
          style: kSubtitleTextSyule,
        )),
      );

  _slimycard(List<dynamic> _name, int _index) {
    return Container(
      // /color: Colors.white,
      height: 150,
      margin: EdgeInsets.all(10),
      child: SlimyCard(
        color: Colors.lightBlueAccent,
        width: 200,
        topCardHeight: 150,
        bottomCardHeight: 100,
        borderRadius: 15,
        topCardWidget: myWidget01(_name[_index]),
        bottomCardWidget: myWidget02(),
        slimeEnabled: true,
      ),
    );
  }
}
