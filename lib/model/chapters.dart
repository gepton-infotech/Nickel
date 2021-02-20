import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Chapter {
  String _name;
  List _topics;
  //List _chapters;

  Chapter(this._name, this._topics);

  //getters

  String get name => this._name;
  List get topics => this._topics;
  // List get chapters => this._chapters;

  Chapter.fromSnap(DocumentSnapshot snapshot) {
    this._name = snapshot['chapterName'];
    this._topics = snapshot['topics'];
    // this._chapters = snapshot['chapters'];
  }
}
