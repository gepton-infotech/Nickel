import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:email_validator/email_validator.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:pyfin/utils/constants.dart';
import 'package:pyfin/screens/choose_avatar.dart';
import 'package:pyfin/screens/new_homepage.dart';
import 'package:pyfin/services/crud.dart';
import 'package:pyfin/services/push_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/global.dart';
import '../model/profile.dart';
import 'package:flutter/material.dart';

class AddInfo extends StatefulWidget {
  final String _nphone;
  AddInfo(this._nphone);
  @override
  _AddInfoState createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  Pymaths crudmethods = new Pymaths();
  PushNotificationsManager _pushNotificationsManager =
      PushNotificationsManager();
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _photoUrl = '';
  String _phone = '';
  String _photoCover = '';
  String _country = 'India';
  List<Map<dynamic, dynamic>> _courseExamDate = List<Map>();
  bool yesORno = false;

  bool isloading = false;
  bool emailValid = true;
  // List<dynamic> demo = ['upsc', 'neet', 'jee'];
  // bool pressed = true;

  List _courses;
  Stream blogsStream;
  var ans = 0;

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

  //checking if user is already there
  TextEditingController _fnController = TextEditingController();
  TextEditingController _lnController = TextEditingController();
  TextEditingController _eController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _courseController = TextEditingController();

  getProfile(_phone) {
    Contact contact;
    FirebaseFirestore.instance.collection("students").doc(_phone).get().then((result) {
      if (result != null) {
          _fnController.text = result.data()['firstName'];
          _lnController.text = result.data()['lastName'];

          _phoneController.text = result.data()['phone'];
          _eController.text = result.data()['email'];
        }

      setState(() {
        _firstName = _fnController.text;
        _lastName = _lnController.text;
        _email = _eController.text;
        _photoUrl = contact.photoUrl;
        _photoCover = contact.photoCover;
        _phone = _phoneController.text;
        _courses = contact.courses;
        _examDate = contact.courseExamDate;
        _country = contact.country;
        print(_examDate);

        // var i = 0;
        // for (var x in _examDate) {
        //   var s = x["date"];
        //   _dates[i] = DateTime.parse(s);
        //   i++;
        //   //print(x);
        // }

        //_courseExamDate = contact.courseExamDate;
        isloading = false;
        print(_courses);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    print(photourl);
    _phone = (widget._nphone).replaceAll(' ', '');
    print(_phone);
    crudmethods.getdata2().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
    checkNumber();
  }

  checkNumber() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("students")
        .doc(_phone.replaceAll(' ', ''))
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
        Contact contact = Contact(
            this._firstName,
            this._lastName,
            this._email,
            photourl,
            photocover,
            this._phone,
            this._courses,
            [],
            [],
            '',
            this._courseExamDate,
            this._country);
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

                    //country
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Row(
                        children: [
                          CountryListPick(
                            appBar: AppBar(
                              backgroundColor: kBlueColor,
                              title: Text('Choose your country'),
                            ),
                            theme: CountryTheme(
                              isShowFlag: true,
                              isShowTitle: true,
                              //isShowCode: true,
                              isDownIcon: true,
                              showEnglishName: true,
                            ),
                            initialSelection: '+91',
                            onChanged: (CountryCode code) {
                              print(code.name);
                              setState(() {
                                _country = code.name;
                              });
                              //print(code.code);
                              //print(code.dialCode);
                              //print(code.flagUri);
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: multiselectformfield(),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    (_courses != null)
                        ? Container(
                            // color: Colors.black,
                            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            "${_dates[index]}".split(' ')[0],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          RaisedButton(
                                            onPressed: () => selectDate(context,
                                                index, _courses[index]),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14))),
                                            child: Text(
                                              _courses[index] +
                                                  ' ' +
                                                  'EXAM DATE',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            color: kBlueColor,
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

                    SizedBox(
                      height: 5,
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
              //print(courses.length);
              //print(courses);
            });
          },
        );
      },
    );
  }
}
