import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  Future<void> _submitAuthForm(
    String email,
    String password,
    String username,
    File userImage,
    bool isLogin,
  ) async {
    UserCredential userCredential;
    try {
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance.ref().child('user_image').child(userCredential.user.uid + '.jpg');

        await ref.putFile(userImage);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user.uid).set({
          'username': username,
          'email': email,
          'image_url': url,
        });
      }
    } on FirebaseAuthException catch (error) {
      var message = 'An error occurred, please check your credentials.';

      if (error.message != null) {
        message = error.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
          duration: Duration(seconds: 4),
        ),
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        onSubmitForm: _submitAuthForm,
      ),
    );
  }
}
