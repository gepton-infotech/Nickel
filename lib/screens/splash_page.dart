import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:page_transition/page_transition.dart';
import 'package:pyfin/screens/landing_screen.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = "SplashPage";
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Clean Code',
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: Container(
              height: 4000,
              //width: MediaQuery.of(context).size.width,
              // color: Colors.deepOrange,
              child: Lottie.network(
                'https://assets4.lottiefiles.com/packages/lf20_rwqsNq.json',
                repeat: true,
                reverse: true,
                animate: true,
              ),
            ),
            nextScreen: LandingScreen(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: Colors.white));
  }
}
