import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'authenticationPage.dart';
import 'homePage.dart';

class MyAppLanding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) return MyHomePage();
        return AuthScreen();
      },
    );
  }
}
