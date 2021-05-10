import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/global.dart';

class Pymaths {
  Future<void> addpymaths(data, _phone) async {
    DocumentReference reference =
        Firestore.instance.collection("students").document(_phone);
    reference.setData(data).catchError((e) {
      print(e);
    });
  }

  getInfo() async {
    return await Firestore.instance
        .collection("students")
        .document(phone.replaceAll(' ', ''))
        .snapshots();
  }

  getdata(_phone) async {
    return await Firestore.instance
        .collection("students")
        .document(_phone)
        .get();
  }

  getAvatar() async {
    return await Firestore.instance.collection("avatars").snapshots();
  }

  getContent(_name) async {
    return await Firestore.instance.collection("Papers").document(_name).get();
  }

  getContent2(_name) async {
    return await Firestore.instance
        .collection("Chapters")
        .document(_name)
        .get();
  }

  getContent3(_name) async {
    return await Firestore.instance.collection("Topics").document(_name).get();
  }

  getdata2() async {
    return await Firestore.instance.collection("courses").snapshots();
  }

  getdata3() async {
    return await Firestore.instance
        .collection("notifications")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}
