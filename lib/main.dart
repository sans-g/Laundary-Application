import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:laundary_application/screen/appLanding.dart';
import 'package:laundary_application/screen/loadingScreen.dart';
import 'package:laundary_application/screen/lockedBuilder.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:secure_application/secure_application.dart';
import 'package:secure_application/secure_application_provider.dart';
import 'package:secure_application/secure_application_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
     MyApp()
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _fingerPrintStatus;
  bool isAuth = false;
  bool _secureAppStatus;

  getFingerPrintStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _fingerPrintStatus =
          sharedPreferences.getBool('fingerPrintStatus') == null
              ? false
              : sharedPreferences.getBool('fingerPrintStatus');
    });
  }

  getSecureAppStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _secureAppStatus = sharedPreferences.getBool('secureAppStatus') == null
          ? false
          : sharedPreferences.getBool('secureAppStatus');
    });
  }

  @override
  Widget build(BuildContext context) {
    getFingerPrintStatus();
    getSecureAppStatus();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SecureApplication(
        nativeRemoveDelay: 100,
        autoUnlockNative: true,
        child: SecureGate(
          blurr: 30,
          opacity: 0.3,
          lockedBuilder: (context, secureNotifier) =>
              LockedBuilder(secureApplicationController: secureNotifier),
          child: Builder(builder: (context) {
            return ValueListenableBuilder<SecureApplicationState>(
                valueListenable: SecureApplicationProvider.of(context),
                builder: (context, state, _) {
                  if (_secureAppStatus != null)
                    _secureAppStatus
                        ? SecureApplicationProvider.of(context).secure()
                        : SecureApplicationProvider.of(context).open();
                  if (_fingerPrintStatus == null) return LoadingScreen();
                  if (_secureAppStatus == null) return LoadingScreen();
                  if ((state.secured && !_fingerPrintStatus) || isAuth)
                    return MyAppLanding();
                  if (_fingerPrintStatus && !isAuth)
                    return Scaffold(
                      body: Center(
                        child: MaterialButton(
                          onPressed: () async {
                            final LocalAuthentication auth =
                                LocalAuthentication();
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
                              availableBiometrics =
                                  await auth.getAvailableBiometrics();
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
                                      'Touch your finger on the sensor to login',
                                  useErrorDialogs: true,
                                  stickyAuth: false,
                                  androidAuthStrings: AndroidAuthMessages(
                                      signInTitle: "Login to HomePage"));
                            } catch (e) {
                              print("error using biometric auth: $e");
                            }
                            setState(() {
                              isAuth = authenticated ? true : false;
                            });
                          },
                          color: Colors.deepOrangeAccent,
                          child: Text(
                            'UNLOCK WITH FINGERPRINT',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  else
                    return MyAppLanding();
                });
          }),
        ),
      ),
    );
  }
}
