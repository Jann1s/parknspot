import 'package:firebase_auth/firebase_auth.dart';
import 'package:parknspot/controller/LoginController.dart';
import 'package:parknspot/main.dart';
import 'package:parknspot/view/Register.dart';
import 'package:flutter/widgets.dart';

class RegisterController {
  Main _main;
  Register _view;
  FirebaseAuth _auth;

  RegisterController(Main main) {
    _main = main;
    _auth = FirebaseAuth.instance;
    _view = new Register(this);
  }

  Widget getView() {
    return _view.getView();
  }

  void showLogin() {
    _main.showLogin();
  }

  Future<bool> registerUser(String email, String password, String passwordConfirm) async {

    if (password == passwordConfirm) {
      if (LoginController.checkInput(email, InputType.Mail) && LoginController.checkInput(password, InputType.Password)) {
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
    else {
      Main.showToast('Your passwords do not match.');
      return false;
    }
  }
}