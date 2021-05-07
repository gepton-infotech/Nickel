import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pyfin/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

import 'info.dart';

class OtpPage extends StatefulWidget {
  //const OtpPage({Key key}) : super(key: key);
  final String _phone;
  OtpPage(this._phone);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String _verificationcode;
  String text = '';
  int c = 1;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void _onKeyboardTap(String value) {
    if (c <= 6) {
      setState(() {
        //print(c);
        text = text + value;
        c++;
      });
    } else
      return;
  }

  addStringToSF() async {
    print("SF");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phoneee', widget._phone);
  }

  @override
  void initState() {
    super.initState();
    print(widget._phone);
    print(photourl);
    setState(() {
      phone = widget._phone;
    });
    print("hello" + phone);
    _verifyPhone();
  }

  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          text[position],
          style: TextStyle(color: Colors.black),
        )),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // key: loginStore.otpScaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              //color: kBlueColor,
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 25,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                                'Enter 6 digits verification code sent to your number',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500))),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              otpNumberWidget(0),
                              otpNumberWidget(1),
                              otpNumberWidget(2),
                              otpNumberWidget(3),
                              otpNumberWidget(4),
                              otpNumberWidget(5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: RaisedButton(
                      onPressed: () async {
                        try {
                          final AuthCredential credential =
                              PhoneAuthProvider.getCredential(
                            verificationId: _verificationcode,
                            smsCode: text,
                          );
                          final AuthResult result =
                              await _auth.signInWithCredential(credential);
                          print(result);
                          final FirebaseUser currentUser =
                              await _auth.currentUser();
                          assert(currentUser != null);
                          addStringToSF();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddInfo(widget._phone)
                                //builder: (context) => HomeScreen(),
                                ),
                          );
                        } catch (e) {
                          //print("in");
                          showToast(
                              "Error validating OTP, try again", Colors.red);
                        }
                      }

                      // FirebaseAuth.instance
                      //     .signInWithCredential(
                      //         PhoneAuthProvider.getCredential(
                      //             verificationId: _verificationcode,
                      //             smsCode: text))
                      //     .then((value) async {
                      //   if (value.user != null) {
                      //     Navigator.pushAndRemoveUntil(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => DetailsScreen()),
                      //         (route) => false);
                      //   } else {
                      //     print("in");
                      //     Navigator.pushAndRemoveUntil(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => HomeScreen()),
                      //         (route) => false);
                      //     showToast(
                      //         "Error validating OTP, try again", Colors.red);
                      //   }
                      // }).catchError((error) {
                      //   print(error.message);
                      //   print("in2");

                      //   showToast(
                      //       "Error validating OTP, try again", Colors.red);
                      // });

                      //  loginStore.validateOtpAndLogin(context, text);
                      ,
                      color: kBlueColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Confirm',
                              style: TextStyle(color: Colors.white),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
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
                  NumericKeyboard(
                    onKeyboardTap: _onKeyboardTap,
                    textColor: kBlueColor,
                    rightIcon: Icon(
                      Icons.backspace,
                      color: kBlueColor,
                    ),
                    rightButtonFn: () {
                      setState(() {
                        text = text.substring(0, text.length - 1);
                        c--;
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        // phoneNumber: '+91${widget._phone}',
        phoneNumber: widget._phone,
        verificationCompleted: (AuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              print("user inside");
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddInfo(widget._phone)),
                  (route) => false);
            } else {
              showToast("Error validating OTP, try again", Colors.red);
            }
          }).catchError((error) {
            showToast("Something went wrong", Colors.red);
          });
        },
        verificationFailed: (AuthException e) {
          print(e.message);
          print("inside");
        },
        codeSent: (String verficationID, [int resendToken]) {
          setState(() {
            _verificationcode = verficationID;
          });
          // final _codeController = TextEditingController();
          // showDialog(
          //   context: context,
          //   barrierDismissible: false,
          //   builder: (context) => AlertDialog(
          //     title: Text("Enter Verification Code From Text Message"),
          //     content: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: <Widget>[TextField(controller: _codeController)],
          //     ),
          //     actions: <Widget>[
          //       FlatButton(
          //         child: Text("submit"),
          //         textColor: Colors.white,
          //         color: Colors.green,
          //         onPressed: () {
          //           var _credential = PhoneAuthProvider.getCredential(
          //               verificationId: _verificationcode,
          //               smsCode: _codeController.text.trim());
          //           FirebaseAuth.instance
          //               .signInWithCredential(_credential)
          //               .then((AuthResult result) {
          //             Navigator.of(context).pushReplacementNamed('/home');
          //           }).catchError((e) {
          //             return "error";
          //           });
          //         },
          //       )
          //     ],
          //   ),
          // );
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationcode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }
}
