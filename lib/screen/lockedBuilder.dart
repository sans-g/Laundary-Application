import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:secure_application/secure_application_controller.dart';

// ignore: must_be_immutable
class LockedBuilder extends StatelessWidget {
  SecureApplicationController secureApplicationController;

  LockedBuilder({
    @required this.secureApplicationController,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        color: Colors.cyan,
        child: Text(
          'UNLOCK WITH FINGERPRINT',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          final LocalAuthentication auth = LocalAuthentication();
          bool canCheckBiometrics = false;
          try {
            canCheckBiometrics = await auth.canCheckBiometrics;
          } catch (e) {
            print("error biometrics $e");
          }

          print("biometric is available: $canCheckBiometrics");

          // enumerate biometric technologies
          List<BiometricType> availableBiometrics;
          try {
            availableBiometrics = await auth.getAvailableBiometrics();
          } catch (e) {
            print("error enumerate biometrics $e");
          }

          print("following biometrics are available");
          if (availableBiometrics.isNotEmpty) {
            availableBiometrics.forEach((ab) {
              print("\ttech: $ab");
            });
          } else {
            print("no biometrics are available");
          }

          // authenticate with biometrics
          bool authenticated = false;
          try {
            authenticated = await auth.authenticateWithBiometrics(
                localizedReason:
                    'Please pass fingerprint authentication to access the app.',
                useErrorDialogs: true,
                stickyAuth: false,
                androidAuthStrings:
                    AndroidAuthMessages(signInTitle: "Login to HomePage"));
          } catch (e) {
            print("error using biometric auth: $e");
          }
          authenticated
              // ignore: unnecessary_statements
              ? secureApplicationController.authSuccess(unlock: true)
              : print("fail");
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
