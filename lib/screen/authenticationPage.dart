import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:laundary_application/widgets/authForm.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  var errorMessage;

  void _submitAuthForm(
    String email,
    String password,
    String confirmPassword,
    String username,
    String laundryBagNo,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else if (password == confirmPassword) {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(userCredential.user.uid + '.jpg');

        await ref.putFile(image).whenComplete(
              () => print("complete"),
            );

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set({
          'username': username,
          'email': email,
          'laundryBagNo': laundryBagNo,
          'image_url': url,
          'userId': userCredential.user.uid
        });
      } else {
        setState(() {
          _isLoading = false;
          errorMessage = "password does not match";
          Scaffold.of(ctx).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
        setState(() {
          errorMessage = message;
        });
        print(message);
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        errorMessage = error.toString();
      });
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AuthForm(
          _submitAuthForm,
          _isLoading,
        ),
      ),
    );
  }
}
