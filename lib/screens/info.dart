import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:pyfin/constants.dart';
import 'package:pyfin/main.dart';
import 'package:pyfin/screens/choose_avatar.dart';
import 'package:pyfin/screens/new_homepage.dart';
import 'package:pyfin/services/crud.dart';
import 'package:pyfin/services/push_notification.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../global.dart';
import '../model/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class AddInfo extends StatefulWidget {
  final String _nphone;
  AddInfo(this._nphone);
  @override
  _AddInfoState createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  pymaths crudmethods = new pymaths();
  PushNotificationsManager _pushNotificationsManager =
      PushNotificationsManager();
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _photoUrl = '';
  String _phone = '';
  String _photoCover = '';
  bool yesORno = false;

  bool isloading = true;
  bool emailValid = true;
  List<dynamic> demo = ['upsc', 'neet', 'jee'];
  // bool pressed = true;

  List _courses;
  Stream blogsStream;

  //checking if user is already there
  TextEditingController _fnController = TextEditingController();
  TextEditingController _lnController = TextEditingController();
  TextEditingController _eController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _courseController = TextEditingController();

  getProfile(_phone) {
    Contact contact;
    crudmethods.getdata(_phone).then((result) {
      contact = Contact.fromSnap(result);
      if (result != null) {
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
          print(_courses);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print(photourl);
    _phone = widget._nphone;
    crudmethods.getdata2().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
    checkNumber();
  }

  checkNumber() async {
    DocumentSnapshot ds = await Firestore.instance
        .collection("students")
        .document(_phone.replaceAll(' ', ''))
        .get();
    this.setState(() {
      yesORno = ds.exists;
      print(yesORno);
    });
    if (yesORno) {
      print("in");
      getProfile(_phone.replaceAll(' ', ''));
    } else {
      isloading = false;
    }
  }

  addStringToSF() async {
    print("SF INFO");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phoneee', widget._nphone);
    prefs.setString('emaill', this._email);
    prefs.setString('firstNamee', this._firstName);
    prefs.setString('lastNamee', this._lastName);
    prefs.setString('photourll', photourl);
    prefs.setString('photocoverr', photocover);
    box.put('courses', courses);
  }

  navigateToNewScreen(context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false);
  }

  saveInfo(context) async {
    setState(() {
      courses = _courses;
    });
    if (_firstName.isNotEmpty && _lastName.isNotEmpty && _email.isNotEmpty) {
      if (EmailValidator.validate(_email)) {
        Contact contact = Contact(this._firstName, this._lastName, this._email,
            photourl, photocover, this._phone, this._courses, [], [], '');
        addStringToSF();
        crudmethods
            .addpymaths(contact.toJson(), _phone.replaceAll(' ', ''))
            .then((value) {
          navigateToNewScreen(context);
          _pushNotificationsManager.init();
        });
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
    return Scaffold(
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                margin:
                    EdgeInsets.only(bottom: 20, top: 30, left: 12, right: 10),
                child: ListView(
                  children: <Widget>[
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
                                "Please enter your",
                                style: kHeadingextStyle,
                              ),
                              Text("Information", style: kHeadingextStyle)
                            ],
                          ),
                          Icon(
                            Icons.info,
                            size: 30.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                    builder: (context) => ChooseAvatar()),
                              )
                              .then((value) => setState(() {
                                    _photoUrl = photourl;
                                  }));
                          setState(() {
                            _photoUrl = photourl;
                          });
                          // Navigator.pop(context);
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //       builder: (context) => AddInfo(widget._nphone)),
                          // );
                        }, // potention error
                        child: Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                imageUrl: photourl,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //first name
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextField(
                        controller: _fnController,
                        onChanged: (value) {
                          setState(() {
                            _firstName = value;
                            firstname = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    //last name
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextField(
                        controller: _lnController,
                        onChanged: (value) {
                          setState(() {
                            _lastName = value;
                            lastname = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    //email
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextField(
                        controller: _eController,
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                            email = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: multiselectformfield(),
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    //save
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: RaisedButton(
                        onPressed: () {
                          saveInfo(context);
                        },
                        color: kBlueColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(14))),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Continue',
                                style: TextStyle(color: Colors.white),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  color: kBlueColor,
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
                  ],
                ),
              ),
            ),
    );
  }

  multiselectformfield() {
    return StreamBuilder(
      stream: blogsStream,
      // initialData: initialData ,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return Container(
            child: Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            )),
          );
        }
        return MultiSelectFormField(
          autovalidate: false,
          chipBackGroundColor: kBlueColor,
          chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
          checkBoxActiveColor: Colors.white,
          checkBoxCheckColor: Colors.black,
          dialogShapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          title: Text(
            "Courses",
            style: TextStyle(fontSize: 16),
          ),
          dataSource: [
            for (int i = 0; i < snapshot.data.documents.length; i++)
              {
                //{
                "display": snapshot.data.documents[i].data['courseName'],
                "value": snapshot.data.documents[i].data['courseName'],
                //}
              }
          ],
          // dataSource: [
          //   {
          //     'display': "Running",
          //     "value": "Running",
          //   },
          //   {
          //     'display': "Climbing",
          //     "value": "Climbing",
          //   },
          //   {
          //     'display': "Walking",
          //     'value': "Walking",
          //   },
          // ],
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
              courses = value;
              //print(_courses);
              print(courses);
            });
          },
        );
      },
    );
  }
}
