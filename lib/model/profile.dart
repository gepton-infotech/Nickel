import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Contact {
  String _id;
  String _firstName;
  String _lastName;
  String _email;
  String _photoUrl;
  String _photoCover;
  String _phone;
  List _courses;
  List<String> _enrolled;
  List<String> _completedTopics;
  String _deviceToken;

  //constructors

  Contact(
      this._firstName,
      this._lastName,
      this._email,
      this._photoUrl,
      this._photoCover,
      this._phone,
      this._courses,
      this._enrolled,
      this._completedTopics,
      this._deviceToken);
  Contact.withID(this._id, this._firstName, this._lastName, this._email,
      this._photoUrl, this._phone);
  Contact.withEnroll(this._enrolled);

  //getters

  String get id => this._id;
  String get firstName => this._firstName;
  String get lastName => this._lastName;
  String get email => this._email;
  String get phone => this._phone;
  String get photoUrl => this._photoUrl;
  String get photoCover => this._photoCover;
  List get courses => this._courses;
  List<String> get enrolled => this._enrolled;
  List<String> get completedTopics => this._completedTopics;

  //setters
  set firstName(String firstname) {
    _firstName = firstname;
  }

  set lastName(String lastname) {
    _lastName = lastname;
  }

  set email(String email) {
    _email = email;
  }

  set photoUrl(String url) {
    _photoUrl = url;
  }

  set phone(String phone) {
    _phone = phone;
  }

  Contact.fromSnap(DocumentSnapshot snapshot) {
    this._firstName = snapshot['firstName'];
    this._lastName = snapshot['lastName'];
    this._email = snapshot['email'];
    this._photoUrl = snapshot['photoUrl'];
    this._photoCover = snapshot['photoCover'];
    this._phone = snapshot['phone'];
    this._courses = snapshot['courses'];
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": _firstName,
      "lastName": _lastName,
      "email": _email,
      "photoUrl": _photoUrl,
      "phone": _phone,
      "courses": _courses,
      "enrolled": _enrolled,
      "completedTopics": _completedTopics,
      "AppdeviceToken": _deviceToken,
    };
  }
}
