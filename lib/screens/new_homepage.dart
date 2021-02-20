import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pyfin/global.dart';
import 'package:pyfin/model/category.dart';
import 'package:pyfin/screens/courses_screen.dart';
import 'package:pyfin/screens/notification_screen.dart';
import 'package:pyfin/services/crud.dart';
import 'package:pyfin/widgets/category_card.dart';
import 'package:pyfin/widgets/nav_drawer.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  pymaths crudmethods = new pymaths();

  var image = [];
  var hour = DateTime.now().hour;
  String greeting;

  Stream courseStream;
  Stream blogsStream;

  int _bottomNavBarSelectedIndex = 0;
  bool _newNotification = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void initState() {
    // TODO: implement initState
    super.initState();

    crudmethods.getdata2().then((result) {
      setState(() {
        courseStream = result;
      });
    });

    crudmethods.getInfo().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
    if (hour < 12) {
      greeting = 'good Morning';
    }
    if (hour < 17) {
      greeting = 'good afternoon';
    }
    greeting = 'good evening';

    //notifications
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        setState(() {
          _newNotification = true;
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _navigateToItemDetail(message);
      },
    );

    //Needed by iOS only
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(
      //backgroundColor: kBlueColor,
      appBar: AppBar(
        backgroundColor: kBlueColor,
        title: Text(
          "Home",
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
                _onItemTapped();
              },
              child: _newNotification
                  ? Stack(
                      children: <Widget>[
                        Container(
                            //color: Colors.blue,
                            padding: EdgeInsets.only(top: 15),
                            child: Icon(Icons.notifications)),
                        Positioned(
                          // right: 0,
                          top: 12,
                          child: Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 10,
                              minHeight: 10,
                            ),
                            child: Text(
                              '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    )
                  : Icon(Icons.notifications),
            ),
          ),
        ],
      ),
      drawer: SideNavBar(),
      // bottomNavigationBar: BottomNavBar(),
      body: Scrollbar(
        child: ListView(
          children: [
            Stack(
              children: <Widget>[
                Container(
                  // Here the height of the container is 45% of our total height
                  height: size.height * .45,
                  decoration: BoxDecoration(
                    color: kBlueColor,
                    image: DecorationImage(
                      alignment: Alignment.centerLeft,
                      image:
                          AssetImage("assets/images/undraw_pilates_gpdb.png"),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // TimeOfDay(hour: null, minute: null)
                        SizedBox(
                          height: 20,
                        ),

                        Text(
                          "$greeting $firstname $lastname".toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .display1
                              .copyWith(fontWeight: FontWeight.w900),
                        ),
                        //SearchBar(),
                        SizedBox(
                          height: 70,
                        ),
                        StreamBuilder(
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
                                  return Container(
                                    //color: Colors.blue,
                                    height: 250,
                                    child: GridView.builder(
                                        itemCount:
                                            snapshot.data['enrolled'].length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: .85,
                                                crossAxisSpacing: 20,
                                                mainAxisSpacing: 20),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return CategoryCard(
                                            name: snapshot.data['enrolled'],
                                            index: index,
                                            title: snapshot.data['enrolled']
                                                [index],
                                            svgSrc: "assets/icons/home4.png",
                                            press: () {},
                                          );
                                        }),
                                  );
                                }
                              }
                            }),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              height: 600,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 40, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Courses We Offer", style: kTitleTextStyle),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => CoursesScreen()),
                                );
                              },
                              child: Text(
                                "See All",
                                style: kSubtitleTextSyule.copyWith(
                                    color: kBlueColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        StreamBuilder(
                            stream: courseStream,
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return Container(
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                              return Expanded(
                                child: StaggeredGridView.countBuilder(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.all(0),
                                  crossAxisCount: 2,
                                  itemCount: courses.length <= 4
                                      ? courses.length
                                      : categories.length,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.all(20),
                                      height: index.isEven ? 200 : 240,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              categories[index].image),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data.documents[index]
                                                .data['courseName'],
                                            style: kSubtitleTextSyule,
                                          ),
                                          // Text(
                                          //   '${categories[index].numOfCourses} Courses',
                                          //   style: TextStyle(
                                          //     color: kTextColor.withOpacity(.5),
                                          //   ),
                                          //)
                                        ],
                                      ),
                                    );
                                  },
                                  staggeredTileBuilder: (index) =>
                                      StaggeredTile.fit(1),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //notifications////////////
  void _navigateToItemDetail(Map<String, dynamic> message) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationScreen()),
    );
  }

  //PRIVATE METHOD TO HANDLE TAPPED EVENT ON THE BOTTOM BAR ITEM
  void _onItemTapped() {
    setState(() {
      _newNotification = false;
    });
  }
}

final Map<String, MessageBean> _items = <String, MessageBean>{};
MessageBean _itemForMessage(Map<String, dynamic> message) {
  //If the message['data'] is non-null, we will return its value, else return map message object
  final dynamic data = message['data'] ?? message;
  final String itemId = data['id'];
  final MessageBean item = _items.putIfAbsent(
      itemId, () => MessageBean(itemId: itemId))
    ..status = data['status'];
  return item;
}

//Model class to represent the message return by FCM
class MessageBean {
  MessageBean({this.itemId});
  final String itemId;

  StreamController<MessageBean> _controller =
      StreamController<MessageBean>.broadcast();
  Stream<MessageBean> get onChanged => _controller.stream;

  String _status;
  String get status => _status;
  set status(String value) {
    _status = value;
    _controller.add(this);
  }

  static final Map<String, Route<void>> routes = <String, Route<void>>{};
  Route<void> get route {
    final String routeName = '/detail/$itemId';
    return routes.putIfAbsent(
      routeName,
      () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => NotificationScreen(),
      ),
    );
  }
}

//Detail UI screen that will display the content of the message return from FCM
// class DetailPage extends StatefulWidget {
//   DetailPage(this.itemId);
//   final String itemId;
//   @override
//   _DetailPageState createState() => _DetailPageState();
// }

// class _DetailPageState extends State<DetailPage> {
//   MessageBean _item;
//   StreamSubscription<MessageBean> _subscription;

//   @override
//   void initState() {
//     super.initState();
//     _item = _items[widget.itemId];
//     _subscription = _item.onChanged.listen((MessageBean item) {
//       if (!mounted) {
//         _subscription.cancel();
//       } else {
//         setState(() {
//           _item = item;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Item ${_item.itemId}"),
//       ),
//       body: Material(
//         child: Center(child: Text("Item status: ${_item.status}")),
//       ),
//     );
//   }
// }
