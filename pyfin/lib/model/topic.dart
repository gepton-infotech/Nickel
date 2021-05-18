import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  String _name;
  String _content;
  //List _chapters;

  Topic(this._name, this._content);

  //getters

  String get name => this._name;
  String get content => this._content;
  // List get chapters => this._chapters;

  Topic.fromSnap(DocumentSnapshot snapshot) {
    this._name = snapshot['topicName'];
    this._content = snapshot['content'];
    // this._chapters = snapshot['chapters'];
  }
}
