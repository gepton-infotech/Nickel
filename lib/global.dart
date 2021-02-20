import 'package:flutter/material.dart';

String phone;
String firstname;
String lastname;
String email;
String photourl =
    'https://firebasestorage.googleapis.com/v0/b/halite-d0150.appspot.com/o/avatars%2Favatar%2FBatman.jpg?alt=media&token=d8e5e0d4-5156-4c8d-ade9-a0d00de8f87a';
String photocover =
    "https://firebasestorage.googleapis.com/v0/b/halite-d0150.appspot.com/o/avatars%2Fcover%2FBatman.jpg?alt=media&token=2bff9b59-8593-4c98-9873-75e80372db45";
List<String> visible = List.generate(20, (i) => "1");
// List<String> selectedi = List.generate(20, (i) => "0");
// List<String> selectedjj = List.generate(20, (i) => "0");
List<String> percentage = List.generate(20, (i) => "0");
List<String> updateEnrolled = List<String>();
List<dynamic> selectedi =
    List.generate(20, (i) => List.generate(20, (j) => "0"));
List<dynamic> selectedjj =
    List.generate(20, (i) => List.generate(20, (j) => "0"));
//var percentage=List.generate(20, (i) => List.generate(20, (j) => "0"));

List<String> enrolled = [];
List courses;
Map<dynamic, dynamic> map = new Map();
double percent = 0;
double add;
var box;
