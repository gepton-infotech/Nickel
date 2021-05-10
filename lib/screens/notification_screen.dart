import 'package:flutter/material.dart';
import 'package:pyfin/services/crud.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constants.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  pymaths crudmethods = new pymaths();
  Stream blogsStream;

  _launchURL(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    crudmethods.getdata3().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBlueColor,
        appBar: AppBar(
          backgroundColor: kBlueColor,
          title: Text("Notifications"),
          centerTitle: true,
          elevation: 0,
        ),
        //drawer: SideNavBar(),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start,
            //scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: kBlueColor,
                  image: DecorationImage(
                    alignment: Alignment.centerLeft,
                    image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
                  ),
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Missed Messages",
                      style: kSubheadingextStyle.copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  //margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                      stream: blogsStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Container(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: snapshot.data.documents.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            //  primary: false,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: kShadowColor)),
                                child: ListTile(
                                  onTap: () {
                                    _launchURL(snapshot
                                        .data.documents[index].data['link']);
                                  },
                                  leading: Container(
                                    padding: EdgeInsets.only(right: 12.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            right: new BorderSide(
                                                width: 1.0,
                                                color: kTextColor))),
                                    child: Icon(Icons.notifications_none,
                                        color: kTextColor),
                                  ),
                                  title: Text(
                                    snapshot
                                        .data.documents[index].data['title'],
                                    style: TextStyle(
                                        color: kTextColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle:
                                      //Icon(Icons.linear_scale, color: Colors.yellowAccent),
                                      Text(
                                          snapshot.data.documents[index]
                                              .data['body'],
                                          style: TextStyle(color: kTextColor)),
                                ),
                              );
                            });
                      }),
                ),
              )
            ]));
  }
}
