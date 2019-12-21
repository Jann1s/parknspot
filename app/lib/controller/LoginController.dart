import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginController {

  final FlutterSecureStorage _storage = new FlutterSecureStorage();
  FirebaseUser _user;
  FirebaseAuth _auth;

  LoginController() {
    _auth = FirebaseAuth.instance;
  }

  Future<bool> checkLoggedIn() async {
    FirebaseUser user = await _auth.currentUser();

    if (user != null) {
      _user = user;
      return true;
    }
    else {
      return false;
    }
  }



  Future<bool> loginUser(String email, String password) async {
    if (_checkInput(email, InputType.Mail)) {
      try {
        FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;

        if (user.isEmailVerified) {
          _user = user;
          return true;
        } else {
          _showToast('Please verify your e-mail.');
          return false;
        }
      }
      catch (e) {
        print(e.code);
        switch (e.code) {
          case 'ERROR_INVALID_EMAIL':
            _showToast('Invalid E-Mail address.');
            break;
          case 'ERROR_USER_NOT_FOUND':
            _showToast('User not found.');
            break;
          case 'ERROR_WRONG_PASSWORD':
            _showToast('Wrong password entered.');
            break;
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            _showToast('E-Mail address is already in use.');
            break;
          default:
          //authError = 'Error';
            break;
        }

        return false;
      }

    }
    else {
      return false;
    }
  }

  Future<bool> registerUser(String email, String password, String passwordConfirm) async {

    if (password == passwordConfirm) {
      if (_checkInput(email, InputType.Mail) && _checkInput(password, InputType.Password)) {
        try {
          FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).user;

          user.sendEmailVerification();

          return true;
        }
        catch (e) {
          print(e.code);
          switch (e.code) {
            case 'ERROR_INVALID_EMAIL':
              _showToast('Invalid E-Mail address.');
              break;
            case 'ERROR_USER_NOT_FOUND':
              _showToast('User not found.');
              break;
            case 'ERROR_WRONG_PASSWORD':
              _showToast('Wrong password entered.');
              break;
            case 'ERROR_EMAIL_ALREADY_IN_USE':
              _showToast('E-Mail address is already in use.');
              break;
            default:
            //authError = 'Error';
              break;
          }

          return false;
        }
      }
      else {
        return false;
      }
    }
    else {
      _showToast('Your passwords do not match.');
      return false;
    }
  }

  void logout() async {
    await _auth.signOut();
  }

  bool _checkInput(String input, InputType type) {
    if (InputType.Mail == type) {
      if (!input.contains('@')) {
        _showToast('E-Mail address is invalid.');
        return false;
      }
      if (!input.substring(input.indexOf('@')).contains('.')) {
        _showToast('E-Mail address is invalid.');
        return false;
      }
      if (input.endsWith('.')) {
        _showToast('E-Mail address is invalid.');
        return false;
      }

      return true;
    }
    else if (InputType.Password == type) {
      if (input.length < 8) {
        _showToast('Your password is weak.');
        return false;
      }

      return true;
    }
    else {
      return false;
    }
  }

  void _showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        fontSize: 16.0
    );
  }
}

enum InputType {
  Mail,
  Password
}