import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn, this.isLoading);

  final bool isLoading;
  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  final picker = ImagePicker();

  void _pickImage(ImageSource imageSource) async {
    final pickedImageFile = await picker.getImage(
      source: imageSource,
      imageQuality: 70,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
    widget.imagePickFn(File(pickedImageFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.pink.withOpacity(
            0.7,
          ),
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage)
              : AssetImage(
                  'assets/boy.png',
                ),
        ),
        SizedBox(
          height: 10,
        ),
        if (!widget.isLoading)
          FlatButton.icon(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text(
                        "Complete your action using..",
                        style: GoogleFonts.lato(),
                      ),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                      content: Container(
                        height: 120,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Feather.camera),
                              title: Text(
                                "Camera",
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              onTap: () {
                                _pickImage(ImageSource.camera);
                                Navigator.of(context).pop();
                              },
                            ),
                            Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                            ListTile(
                              leading: Icon(Feather.image),
                              title: Text(
                                "Gallery",
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            icon: Icon(Icons.add),
            label: Text(
              'Add Image',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
      ],
    );
  }
}
