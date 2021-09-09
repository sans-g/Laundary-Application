import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:laundary_application/globalWidgets/appBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class SettingWidget extends StatefulWidget {
  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  bool _fingerPrintStatus;
  bool _secureAppStatus;

  setFingerPrintStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('fingerPrintStatus', !_fingerPrintStatus);
    print(sharedPreferences.getBool('fingerPrintStatus'));
  }

  setSecureAppStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('secureAppStatus', !_secureAppStatus);
    print(sharedPreferences.getBool('secureAppStatus'));
  }

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getFingerPrintStatus();
    getSecureAppStatus();
    User user = FirebaseAuth.instance.currentUser;
    bool isLoading = false;
    return Scaffold(
      appBar: appBar(context, "Settings"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            DocumentSnapshot users = snapshot.data;
            return (snapshot.data == null || users.data() == null)
                ? Shimmer.fromColors(
                    highlightColor: Colors.white,
                    baseColor: Colors.grey[300],
                    child: ShimmerLayout(),
                    period: Duration(milliseconds: 1000),
                  )
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 3,
                          child: ListTile(
                            leading: Icon(
                              Icons.fingerprint,
                              color: Colors.blue,
                            ),
                            trailing: Switch(
                              value: _fingerPrintStatus,
                              onChanged: (value) {
                                setFingerPrintStatus();
                              },
                            ),
                            title: Text("Enable FingerPrint"),
                          ),
                        ),
                        Text(
                            "* This feature will add fingerprint authentication every time you open the app."),
                        Card(
                          elevation: 3,
                          child: ListTile(
                            leading: Icon(
                              Icons.security,
                              color: Colors.blue,
                            ),
                            title: Text("Secure App"),
                            trailing: Switch(
                              value: _secureAppStatus,
                              onChanged: (value) {
                                setSecureAppStatus();
                              },
                            ),
                          ),
                        ),
                        Text(
                            "* This feature will add the fingerprint authentication every time you close your app temporary and avoid unusual access to the data of the app."),
                        Card(
                          elevation: 3,
                          child: ListTile(
                            leading: Icon(
                              AntDesign.key,
                              color: Colors.blue,
                            ),
                            title: Text("Reset Password"),
                            onTap: () {
                              FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: user.email);
                            },
                          ),
                        ),
                        isLoading
                            ? CircularProgressIndicator()
                            : Card(
                                elevation: 3,
                                child: ListTile(
                                  leading: Icon(
                                    AntDesign.logout,
                                    color: Colors.blue,
                                  ),
                                  title: Text("Logout"),
                                  onTap: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    FirebaseAuth.instance.signOut();
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 60,
            ),
            SizedBox(height: 15),
            Container(
              height: 30,
              width: width,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Container(
              height: 30,
              width: width,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Container(
              height: 60,
              width: width,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Container(
              height: 60,
              width: width,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Container(
              height: 60,
              width: width,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Container(
              height: 60,
              width: width,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
