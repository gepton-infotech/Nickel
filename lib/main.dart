import 'package:hive/hive.dart';
import 'package:pyfin/global.dart';
import 'package:flutter/material.dart';
import 'package:pyfin/screens/splash_page.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  box = await Hive.openBox('testBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pyfin',
      theme: ThemeData(
          //  primarySwatch: Colors.purple,
          ),
      home: SplashPage(),
    );
  }
}
