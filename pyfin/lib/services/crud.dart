import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/global.dart';

class Pymaths {

  final _firestore = FirebaseFirestore.instance;

  Future<void> addpymaths(data, _phone) async {
    DocumentReference reference =
        FirebaseFirestore.instance.collection("students").doc(_phone);
    reference.set(data).catchError((e) {
      print(e);
    });
  }

  getInfo() async {
    return await FirebaseFirestore.instance
        .collection("students")
        .doc(phone.replaceAll(' ', ''))
        .get();
  }

  getdata(_phone) async {
    return await _firestore
        .collection("students")
        .doc(_phone).get();
  }

  getAvatar() async {
    return FirebaseFirestore.instance.collection("avatars").get();
  }

  getContent(_name) async {
    return await FirebaseFirestore.instance
        .collection("Papers")
        .doc(_name)
        .get();
  }

  getContent2(_name) async {
    return await FirebaseFirestore.instance
        .collection("Chapters")
        .doc(_name)
        .get();
  }

  getContent3(_name) async {
    return await FirebaseFirestore.instance
        .collection("Topics")
        .doc(_name)
        .get();
  }

  getdata2() async {
    return FirebaseFirestore.instance.collection("courses").get();
  }

  getdata3() async {
    return FirebaseFirestore.instance
        .collection("notifications")
        .orderBy("createdAt", descending: true)
        .get();
  }
}
