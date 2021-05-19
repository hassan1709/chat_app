import 'dart:io';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final Future<void> Function(
    String email,
    String password,
    String username,
    File userImage,
    bool isLogin,
  ) onSubmitForm;

  const AuthForm({
    Key key,
    this.onSubmitForm,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _isAuthenticating = false;
  File _userImage;

  void _selectedUserImage(File image) {
    _userImage = image;
  }

  String validateEmail(String value) {
    if (!EmailValidator.validate(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty || value.length < 7) {
      return 'Password must be at least 7 characters long';
    }
    return null;
  }

  String validateUserName(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Username must be at least 4 characters';
    }
    return null;
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState.validate();

    if (_userImage == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      FocusScope.of(context).unfocus(); //Close soft keyboard

      setState(() {
        _isAuthenticating = true;
      });

      await widget.onSubmitForm(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImage,
        _isLogin,
      );

      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(selectedImage: _selectedUserImage),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: validateUserName,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: validatePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  ElevatedButton(
                    onPressed: _isAuthenticating ? null : _trySubmit,
                    child: _isAuthenticating ? CircularProgressIndicator() : Text(_isLogin ? 'Login' : 'Signup'),
                  ),
                  TextButton(
                    onPressed: _isAuthenticating
                        ? null
                        : () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                    child: Text(_isLogin ? 'Create new account' : 'I already have an account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
