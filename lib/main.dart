import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pyfin/utils/constants.dart';
import 'package:pyfin/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:pyfin/screens/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:pyfin/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: kSecondaryColor,
      statusBarColor: kPrimaryColor,
    ),
  );
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  box = await Hive.openBox('testBox');
  Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pyfin',
      theme: appTheme(),
      home: SplashPage(),
    );
  }
}
