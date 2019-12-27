import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class ProfileController {
  LoginController _loginController;

  ProfileController(LoginController loginController) {
    _loginController = loginController;
  }

  Future<bool> changeEmail(String currentEmail, String newEmail) async {
    if (currentEmail == _loginController.getUser().email) {
      if (!LoginController.checkInput(currentEmail, InputType.Mail)) {
        Main.showToast('Your current E-Mail input is invalid.');
        return false;
      }
      else if (!LoginController.checkInput(newEmail, InputType.Mail)) {
        Main.showToast('Your new E-Mail input is invalid.');
        return false;
      }
      else {
        await _loginController.getUser().updateEmail(newEmail);
        await _loginController.getUser().sendEmailVerification();
        _loginController.logout();
        _loginController.showLogin();

        return true;
      }
    }
    else {
      Main.showToast('Please enter your current E-Mail.');
      return false;
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    try {
      if (newPassword == confirmPassword) {
        if (!LoginController.checkInput(newPassword, InputType.Password)) {
          Main.showToast('Password should be at least 8 char long');
          return false;
        } else if (!LoginController.checkInput(
            confirmPassword, InputType.Password)) {
          Main.showToast('Password should be at least 8 char long');
          return false;
        } else {
          FirebaseUser user = await FirebaseAuth.instance.currentUser();
          String email = user.email;
          AuthResult result = await user.reauthenticateWithCredential(
              EmailAuthProvider.getCredential(
                  email: email, password: currentPassword));
          await result.user.updatePassword(newPassword);
          Main.showToast('Password changed successfully');

          return true;
        }
      } else {
        Main.showToast('Passwords do nomatch');
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }
  
  void logout() {
    _loginController.logout();
    _loginController.showLogin();
  }
}
