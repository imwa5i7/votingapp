import 'dart:async';

import 'package:disney_voting/config/di.dart';
import 'package:disney_voting/config/palette.dart';
import 'package:disney_voting/config/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    instance<FirebaseAuth>().authStateChanges().listen((event) {
      print(event);
      if (event != null) {
        Navigator.popAndPushNamed(context, Routes.dashboard);
      } else {
        Navigator.pushNamed(context, Routes.login);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Palette.white,
        body: Center(
          child: Text('LOADING...'),
        ));
  }
}
