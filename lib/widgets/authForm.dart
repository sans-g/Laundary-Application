import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundary_application/widgets/userImagePicker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String confirmPassword,
    String userName,
    String laundryagNo,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _laundryBagNo = '';
  var _userPassword = '';
  var _confirmPassword = '';
  File _userImageFile;
  bool hidePassword = true;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _confirmPassword.trim(),
        _userName.trim(),
        _laundryBagNo.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                !_isLogin
                    ? SizedBox(
                        height: 0,
                      )
                    : Image.asset(
                        "assets/app_icon.png",
                        height: height * 0.2,
                      ),
                if (!_isLogin) UserImagePicker(_pickedImage, widget.isLoading),
                Container(
                  width: width,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'Email address',
                        prefixIcon: Icon(Entypo.mail),
                        border: InputBorder.none),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                ),
                SizedBox(height: 12),
                if (!_isLogin)
                  Container(
                    width: width,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      key: ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Username',
                        prefixIcon: Icon(Icons.edit),
                        border: InputBorder.none,
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  ),
                SizedBox(height: 12),
                if (!_isLogin)
                  Container(
                    width: width,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      key: ValueKey('laundry bag number'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter correct laundry bag number.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Laundry bag number(Eg. B-001)',
                        prefixIcon: Icon(Icons.edit),
                        border: InputBorder.none,
                      ),
                      onSaved: (value) {
                        _laundryBagNo = value;
                      },
                    ),
                  ),
                SizedBox(height: 12),
                Container(
                  width: width,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                              hidePassword ? Entypo.eye_with_line : Entypo.eye),
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                        hintText: 'Password',
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.vpn_key,
                        )),
                    obscureText: hidePassword,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                ),
                SizedBox(height: 12),
                if (!_isLogin)
                  Container(
                    width: width,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters long.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.vpn_key,
                          )),
                      obscureText: hidePassword,
                      onSaved: (value) {
                        _confirmPassword = value;
                      },
                    ),
                  ),
                SizedBox(height: 12),
                widget.isLoading
                    ? CircularProgressIndicator()
                    : InkWell(
                        onTap: _trySubmit,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: width,
                          child: Center(
                              child: Text(
                            _isLogin ? 'Login' : 'Sign Up',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          )),
                        ),
                      ),
                if (!widget.isLoading)
                  FlatButton(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: _isLogin
                                ? "Don't have an account? "
                                : "Already have an account?",
                            style: GoogleFonts.lato(
                              color: Colors.black54,
                            )),
                        TextSpan(
                            text: _isLogin ? "Sign Up" : "Log In",
                            style: GoogleFonts.lato(
                              color: Colors.blue,
                              fontWeight: FontWeight.w900,
                            )),
                      ]),
                    ),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                Image.asset(
                  "assets/demo1.png",
                  height: height * 0.26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
