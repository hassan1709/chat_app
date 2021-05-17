import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  final void Function(File image) selectedImage;

  const UserImagePicker({Key key, this.selectedImage}) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 150,
    );

    if (pickedFile == null) {
      return;
    }

    setState(() {
      _image = File(pickedFile.path);
    });

    widget.selectedImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40.0,

          /// add a dummy image when no image is picked
          backgroundImage: _image != null ? FileImage(_image) : null,
        ),
        TextButton.icon(
          style: TextButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
          onPressed: getImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
