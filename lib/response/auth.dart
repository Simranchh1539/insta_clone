import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/response/storage_method.dart';
import 'package:instagramclone/models/user.dart' as model;

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  void updateUser(model.User user) {
    _firestore.collection('users').doc(user.uid).update({
      'name': user.username,
      'photoUrl': user.photourl,
      'bio': user.bio,
    });
  }

  Future<String> signup({
    @required String email,
    @required String password,
    @required String username,
    @required String bio,
    @required Uint8List file,
  }) async {
    String error = "Error encountered !!";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential usercred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        model.User _user = model.User(
          username: username,
          uid: usercred.user.uid,
          photourl: photoUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(usercred.user.uid)
            .set(_user.toJson());
        error = "Success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        error = 'The email is badly formatted';
      } else if (err.code == 'weak-password') {
        error = 'Password Should be atleast 6 characters';
      }
    } catch (err) {
      error = err.toString();
    }
    return error;
  }

  Future<String> Login({
    @required String email,
    @required String password,
  }) async {
    String error = "Some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        error = "success";
      } else {
        error = "Please enter all the fields";
      }
    } catch (err) {
      error = err.toString();
    }
    return error;
  }

  Future<void> signOutt() async {
    await _auth.signOut();
  }
}
