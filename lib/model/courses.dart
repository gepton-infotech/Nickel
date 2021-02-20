import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Course {
  String _name;
  List _chapters;

  Course(this._name, this._chapters);

  //getters

  String get name => this._name;
  List get chapters => this._chapters;

  //setters

  set name(String name) {
    _name = name;
  }

  Course.fromSnap(DocumentSnapshot snapshot) {
    this._name = snapshot['paperName'];
    this._chapters = snapshot['chapters'];
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';

// class Course {
//   String _name;
//   List _subTopics;

//   Course(this._name, this._subTopics);

//   //getters

//   String get name => this._name;
//   List get subTopics => this._subTopics;

//   //setters

//   set name(String name) {
//     _name = name;
//   }

//   Course.fromSnap(DocumentSnapshot snapshot) {
//     this._name = snapshot['name'];
//     this._subTopics = snapshot['subTopics'];
//   }
// }
