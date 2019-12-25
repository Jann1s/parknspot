import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:parknspot/view/Login.dart';
import 'package:parknspot/main.dart';

class LoginController {

  Main _main;
  Login _view;
  FirebaseUser _user;
  FirebaseAuth _auth;

  LoginController(Main main) {
    _main = main;
    _auth = FirebaseAuth.instance;
    _view = new Login(this);
  }

  Widget getView() {
    return _view.getView();
  }

  void successfulLogin() {
    _main.successfulLogin();
  }

  void showRegister() {
    _main.showRegister();
  }

  void showLogin() {
    _main.showLogin();
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
    if (checkInput(email, InputType.Mail)) {
      try {
        FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;

        if (user.isEmailVerified) {
          _user = user;
          return true;
        } else {
          Main.showToast('Please verify your e-mail.');
          return false;
        }
      }
      catch (e) {
        print(e.code);
        switch (e.code) {
          case 'ERROR_INVALID_EMAIL':
            Main.showToast('Invalid E-Mail address.');
            break;
          case 'ERROR_USER_NOT_FOUND':
            Main.showToast('User not found.');
            break;
          case 'ERROR_WRONG_PASSWORD':
            Main.showToast('Wrong password entered.');
            break;
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            Main.showToast('E-Mail address is already in use.');
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

  //Reset password
  Future resetPassword(String email) async {
    if(checkInput(email, InputType.Mail)){  
  try{
  await _auth.sendPasswordResetEmail(email: email);
    }    catch (e) {
        print(e.code);
        switch (e.code) {
          case 'ERROR_INVALID_EMAIL':
            Main.showToast('Invalid E-Mail address.');
            break;
          case 'ERROR_USER_NOT_FOUND':
            Main.showToast('User not found.');
            break;
          default:
          //authError = 'Error';
            break;
        }

        return false;
      }

    }
    
}

  void logout() async {
    await _auth.signOut();
  }

  FirebaseUser getUser() {
    return _user;
  }

  static bool checkInput(String input, InputType type) {
    if (InputType.Mail == type) {
      if (!input.contains('@')) {
        Main.showToast('E-Mail address is invalid.');
        return false;
      }
      if (!input.substring(input.indexOf('@')).contains('.')) {
        Main.showToast('E-Mail address is invalid.');
        return false;
      }
      if (input.endsWith('.')) {
        Main.showToast('E-Mail address is invalid.');
        return false;
      }

      return true;
    }
    else if (InputType.Password == type) {
      if (input.length < 8) {
        Main.showToast('Your password is weak.');
        return false;
      }

      return true;
    }
    else {
      return false;
    }
  }
}

enum InputType {
  Mail,
  Password
}