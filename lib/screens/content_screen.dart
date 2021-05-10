import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../utils/constants.dart';

class ContentScreen extends StatefulWidget {
  final List<String> _name;
  final List<String> _content;
  final _index;
  final _length;
  ContentScreen(this._name, this._content, this._index, this._length);
  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBlueColor,
        appBar: AppBar(
          backgroundColor: kBlueColor,
          elevation: 0,
        ),
        body: CupertinoScrollbar(
          child: ListView(
            // shrinkWrap: true,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  widget._name[widget._index] + "" + ":",
                  style: kHeadingextStyle.copyWith(color: Colors.white),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: widget._index == 0
                        ? SizedBox(
                            height: 1,
                            width: 1,
                          )
                        : RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => ContentScreen(
                                        widget._name,
                                        widget._content,
                                        widget._index - 1,
                                        widget._length)),
                              );
                            },
                            color: kGreenColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14))),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      //color: Colors.lightGreen,
                                    ),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                  Text(
                                    'Previous Topic',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: widget._index == widget._length - 1
                          ? SizedBox(
                              height: 1,
                              width: 1,
                            )
                          : RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => ContentScreen(
                                          widget._name,
                                          widget._content,
                                          widget._index + 1,
                                          widget._length)),
                                );
                              },
                              color: kGreenColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14))),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Next Topic',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
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
                            ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                //  / width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10,
                ),
                //height: MediaQuery.of(context).size.height,

                child: Markdown(
                    shrinkWrap: true,
                    selectable: true,
                    physics: NeverScrollableScrollPhysics(),
                    data: widget._content[widget._index],
                    styleSheet: MarkdownStyleSheet()),
              ),
            ],
          ),
        ));
  }
}
