import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:pyfin/model/profile.dart';
import 'package:pyfin/services/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../utils/global.dart';
import 'choose_avatar.dart';

class ProfilePage extends StatefulWidget {
  final String _phone;
  ProfilePage(this._phone);
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _photoUrl = '';
  String _photoCover = '';
  bool _isloading = false;
  bool isloading = true;
  bool emailValid = true;
  List<Map<dynamic, dynamic>> _courseExamDate = List<Map>();
  List _courses = List<String>();
  Pymaths crudmethods = new Pymaths();
  Stream infostream;
  var ans = 0;

  TextEditingController _fnController = TextEditingController();
  TextEditingController _lnController = TextEditingController();
  TextEditingController _eController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _courseController = TextEditingController();

  List _dates = List.generate(20, (i) => DateTime.now());
  DateTime selectedDate = DateTime.now();
  List<dynamic> _examDate;
  //var examdate = <Map>[];

  selectDate(BuildContext context, index, exam) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dates[index],
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        ans = 0;
        var map = {};
        //print(picked.toString().split(' ')[0]);
        print(index);
        _dates[index] = picked;
        map["exam"] = exam;
        map["date"] = _dates[index].toString().split(' ')[0];
        print(map);
        for (var x in _courseExamDate) {
          // print("in");
          if (x.containsKey("exam")) {
            print("in");
            if (x["exam"] == exam) {
              _courseExamDate[index] = map;
              ans = 1;
            }
          }
        }
        if (ans == 0) _courseExamDate.add(map);
        //else

        print(_courseExamDate);
      });
  }

  void showToast(message, Color color) {
    //print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  getProfile(_phone) {
    Contact contact;
    crudmethods.getdata(_phone).then((result) {
      contact = Contact.fromDocument(result);
      //print(result);
      _fnController.text = contact.firstName;
      _lnController.text = contact.lastName;
      _phoneController.text = contact.phone;
      _eController.text = contact.email;
      setState(() {
        _firstName = contact.firstName;
        _lastName = contact.lastName;
        _email = contact.email;
        _photoUrl = contact.photoUrl;
        _photoCover = contact.photoCover;
        _phone = contact.phone;
        _courses = contact.courses;
        isloading = false;
        _examDate = contact.courseExamDate;
        var i = 0;
        for (var x in _examDate) {
          var s = x["date"];
          _dates[i] = DateTime.parse(s);
          i++;
          //print(x);
        }
        print(_courses);
      });
    });
  }

  Stream blogsStream;

  void initState() {
    super.initState();
    //setState(() {});
    //print(photourl);
    print(widget._phone);
    print(courses);
    getProfile(widget._phone.replaceAll(' ', ''));
    crudmethods.getdata2().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
  }

  // navigateToNewScreen(context) {
  //   Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => HomeScreen()),
  //       (Route<dynamic> route) => false);
  // }

  addStringToSF() async {
    print("updated SF INFO");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', this._email);
    prefs.setString('firstName', this._firstName);
    prefs.setString('lastName', this._lastName);
    prefs.setString('photourl', photourl);
    prefs.setString('photocover', photourl);
    box.put('courses', courses);
  }

  updateProfile(_phone) {
    //print(photourl);
    print("in");
    setState(() {
      courses = _courses;
    });
    print(courses);
    if (_firstName.isNotEmpty && _lastName.isNotEmpty && _email.isNotEmpty) {
      if (EmailValidator.validate(_email)) {
        addStringToSF();
        FirebaseFirestore.instance
            .collection("students")
            .doc(_phone.replaceAll(' ', ''))
            .update({
          "firstName": this._firstName,
          "lastName": this._lastName,
          "email": this._email,
          "photoUrl": photourl,
          "photoCover": photocover,
          "courses": this._courses,
          "courseExamDate": this._courseExamDate,
        }).then(
          (value) => showToast("Values are updated", kPrimaryColor),
        );
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Invalid"),
                content: Text(
                  "Please enter a valid email.",
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Ok"))
                ],
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Attention!'),
              content: Text('All fields are required'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Profile"),
          ),
          body: isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : new Container(
                  color: Colors.white,
                  child: new ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          new Container(
                            height: 200.0,
                            //  color: Colors.blue,
                            child: new Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: new Stack(
                                      fit: StackFit.loose,
                                      children: <Widget>[
                                        new Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Container(
                                              width: 140.0,
                                              height: 140.0,
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  imageUrl: photourl,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 90.0, right: 100.0),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            new FocusNode());
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChooseAvatar()),
                                                    ).then(
                                                        (value) => setState(() {
                                                              print("refresh");
                                                              print(photourl);
                                                            }));
                                                  },
                                                  child: new CircleAvatar(
                                                    backgroundColor:
                                                        kPrimaryColor,
                                                    radius: 20.0,
                                                    child: new Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ]),
                                )
                              ],
                            ),
                          ),
                          new Container(
                            color: Color(0xffFFFFFF),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Parsonal Information',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              _status
                                                  ? _getEditIcon()
                                                  : new Container(),
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'First Name',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Flexible(
                                            child: new TextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  _firstName = value;
                                                  firstname = value;
                                                });
                                              },
                                              controller: _fnController,
                                              decoration: const InputDecoration(
                                                hintText: "Enter Your Name",
                                              ),
                                              enabled: !_status,
                                              autofocus: !_status,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Last Name',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Flexible(
                                            child: new TextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  _lastName = value;
                                                  lastname = value;
                                                });
                                              },
                                              controller: _lnController,
                                              decoration: const InputDecoration(
                                                hintText: "Enter Your Name",
                                              ),
                                              enabled: !_status,
                                              autofocus: !_status,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Email ID',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Flexible(
                                            child: new TextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  _email = value;
                                                  email = value;
                                                });
                                              },
                                              controller: _eController,
                                              decoration: const InputDecoration(
                                                  hintText: "Enter Email ID"),
                                              enabled: !_status,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Mobile',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Flexible(
                                            child: GestureDetector(
                                              onTap: () => {
                                                showToast(
                                                    "Please sign out to change phone number",
                                                    kPrimaryColor)
                                              },
                                              child: new TextField(
                                                controller: _phoneController,
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        "Enter Mobile Number"),
                                                enabled: false,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: StreamBuilder(
                                      stream: blogsStream,
                                      // initialData: initialData ,
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.data == null) {
                                          return Container(
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          );
                                        }
                                        return MultiSelectFormField(
                                          autovalidate: false,
                                          enabled: !_status,
                                          chipBackGroundColor: kPrimaryColor,
                                          chipLabelStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          dialogTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          checkBoxActiveColor: Colors.white,
                                          checkBoxCheckColor: Colors.black,
                                          dialogShapeBorder:
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              12.0))),
                                          title: Text(
                                            "Courses",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          dataSource: [
                                            for (int i = 0;
                                                i <
                                                    snapshot
                                                        .data.documents.length;
                                                i++)
                                              {
                                                //{
                                                "display": snapshot
                                                    .data
                                                    .documents[i]
                                                    .data['courseName'],
                                                "value": snapshot
                                                    .data
                                                    .documents[i]
                                                    .data['courseName'],
                                                //}
                                              }
                                          ],
                                          textField: 'display',
                                          valueField: 'value',
                                          okButtonLabel: 'OK',
                                          cancelButtonLabel: 'CANCEL',
                                          hintWidget:
                                              Text('Please choose one or more'),
                                          initialValue: _courses,
                                          onSaved: (value) {
                                            if (value == null) return;
                                            setState(() {
                                              _courses = value;
                                              courses = value;
                                              //print(_courses);
                                              //print(courses);
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  _courses.length > 0
                                      ? Container(
                                          margin: EdgeInsets.fromLTRB(
                                              20, 20, 20, 0),
                                          child: Wrap(
                                            spacing: 10.0,
                                            runSpacing: 5.0,
                                            children: [
                                              GridView.builder(
                                                  itemCount: _courses.length,
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          //childAspectRatio: 0.1,
                                                          //crossAxisSpacing: 20,
                                                          mainAxisSpacing: 20),
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Text(
                                                          "${_dates[index]}"
                                                              .split(' ')[0],
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        RaisedButton(
                                                          onPressed: () =>
                                                              selectDate(
                                                                  context,
                                                                  index,
                                                                  _courses[
                                                                      index]),
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          14))),
                                                          child: Text(
                                                            _courses[index] +
                                                                ' ' +
                                                                'EXAM DATE',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          color: kPrimaryColor,
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0,
                                          width: 0,
                                        ),
                                  !_status
                                      ? _getActionButtons()
                                      : new Container(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: RaisedButton(
          onPressed: () {
            updateProfile(phone);
          },
          color: kPrimaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14))),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'UPDATE',
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: kPrimaryColor,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: kPrimaryColor,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  multiselectformfield() {
    return MultiSelectFormField(
      autovalidate: false,
      chipBackGroundColor: kPrimaryColor,
      chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
      checkBoxActiveColor: Colors.white,
      checkBoxCheckColor: Colors.black,
      dialogShapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      title: Text(
        "Courses",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      dataSource: [
        {
          "display": "JEE",
          "value": "JEE",
        },
        {
          "display": "NEET",
          "value": "NEET",
        },
        {
          "display": "UPSC",
          "value": "UPSC",
        },
      ],
      textField: 'display',
      valueField: 'value',
      okButtonLabel: 'OK',
      cancelButtonLabel: 'CANCEL',
      hintWidget: Text('Please choose one or more'),
      initialValue: _courses,
      onSaved: (value) {
        if (value == null) return;
        setState(() {
          _courses = value;
          print(_courses);
        });
      },
    );
  }
}
