import 'package:flutter/material.dart';
import 'package:pyfin/utils/constants.dart';
import 'package:pyfin/utils/global.dart';
import 'package:pyfin/widgets/category_card.dart';

class DashboardPage extends StatelessWidget {
  final Stream blogsStream;
  DashboardPage({this.blogsStream});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // TimeOfDay(hour: null, minute: null)
                SizedBox(
                  height: 20,
                ),

                Text(
                  "Hello $firstname $lastname".toUpperCase(),
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
                      if (snapshot.connectionState != ConnectionState.active) {
                        return Container(
                          child: Center(
                              child: CircularProgressIndicator(
                            backgroundColor: kPrimaryColor,
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
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: GridView.builder(
                                primary: false,
                                itemCount: snapshot.data['enrolled'].length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: .85,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20),
                                itemBuilder: (BuildContext context, int index) {
                                  return CategoryCard(
                                    name: snapshot.data['enrolled'],
                                    index: index,
                                    title: snapshot.data['enrolled'][index],
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
        ],
      ),
    );
  }
}
