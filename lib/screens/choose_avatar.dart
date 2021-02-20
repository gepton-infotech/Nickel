import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pyfin/global.dart';
import 'package:pyfin/model/category.dart';
import 'package:pyfin/services/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ChooseAvatar extends StatefulWidget {
  @override
  _ChooseAvatarState createState() => _ChooseAvatarState();
}

class _ChooseAvatarState extends State<ChooseAvatar> {
  pymaths crudmethods = new pymaths();
  Stream avastream;

  void initState() {
    // TODO: implement initState
    super.initState();

    crudmethods.getAvatar().then((result) {
      setState(() {
        avastream = result;
        print(avastream);
      });
    });
  }

  addStringToSF() async {
    print("updated SF INFO");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('photourll', photourl);
    prefs.setString('photocoverr', photocover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
          //color: Colors.red,
          child: Padding(
              padding: EdgeInsets.only(top: 20, left: 12, right: 10),
              child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Choose Your Own ",
                                style: kHeadingextStyle,
                              ),
                              Text("Avatar", style: kHeadingextStyle)
                            ],
                          )
                        ])),
                Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: StreamBuilder(
                        stream: avastream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.active) {
                            return Container(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else {
                            return ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              itemCount: snapshot.data.documents.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      photourl = snapshot
                                          .data.documents[index].data['URL'];
                                      photocover = snapshot
                                          .data.documents[index].data['cover'];
                                      addStringToSF();
                                    });

                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 50),
                                    //color: Colors.black,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        // background image and bottom contents
                                        Column(
                                          // mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              color: Colors.red,
                                              height: 200.0,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      'assets/gifs/loading.gif',
                                                  placeholderScale: 100,
                                                  image: snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['cover'],
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      5,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Profile image
                                        Positioned(
                                          top:
                                              110.0, // (background container size) - (circle height / 2)
                                          child: Container(
                                            //color: Colors.red,
                                            height: 100.0,
                                            width: 100.0,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                imageUrl: snapshot
                                                    .data
                                                    .documents[index]
                                                    .data['URL'],
                                                // width: MediaQuery.of(context)
                                                //     .size
                                                //     .width,
                                                // fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        })),
              ]))),
    );
  }
}
