import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/models/user.dart';
import 'package:instagramclone/response/auth.dart';
import 'package:instagramclone/response/storage_method.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/image_picker_utility.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  final Function updateUser;

  EditProfileScreen({this.user, this.updateUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _bio = '';

  Uint8List _profileImage;
  final picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.username;
    _bio = widget.user.bio;
  }

  _handleImageFromGallery() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    if (im != null) {
      setState(() {
        _profileImage = im;
      });
    } else {
      print('No image selected.');
    }
  }

  _submit() async {
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      setState(() => _isLoading = true);
      String url;

      //Update user in database
      String _profileImageUrl = '';

      if (_profileImage == null) {
        _profileImageUrl = widget.user.photourl;
      } else {
        _profileImageUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', _profileImage, false);
      }

      User user = User(
        uid: widget.user.uid,
        username: _name.trim(),
        photourl: _profileImageUrl,
        bio: _bio.trim(),
      );

      //Database Update
      Auth().updateUser(user);

      widget.updateUser(user);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        title: Text(
          'Edit Profile',
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(widget.user.photourl),
                    ),
                    FlatButton(
                      onPressed: _handleImageFromGallery,
                      child: Text(
                        'Change Profile Image',
                        style: TextStyle(color: Colors.blue, fontSize: 16.0),
                      ),
                    ),
                    TextFormField(
                      initialValue: _name,
                      maxLength: 20,
                      textCapitalization: TextCapitalization.words,
                      style: kFontSize18TextStyle,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            size: 30.0,
                          ),
                          labelText: 'Name'),
                      validator: (input) => input.trim().length < 1
                          ? 'Please enter a valid name'
                          : input.trim().length > 20
                              ? 'Please enter name less than 20 characters'
                              : null,
                      onSaved: (input) => _name = input,
                    ),
                    TextFormField(
                      initialValue: _bio,
                      maxLines: 4,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      style: kFontSize18TextStyle,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.book,
                            size: 30.0,
                          ),
                          labelText: 'Bio'),
                      validator: (input) => input.trim().length > 150
                          ? 'Please enter a bio less than 150 characters'
                          : null,
                      onSaved: (input) => _bio = input,
                    ),
                    Container(
                      margin: const EdgeInsets.all(40.0),
                      height: 40.0,
                      width: 250.0,
                      child: FlatButton(
                        onPressed: _submit,
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text(
                          'Save Profile',
                          style: kFontSize18TextStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
