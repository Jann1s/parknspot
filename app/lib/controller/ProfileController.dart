import 'package:firebase_auth/firebase_auth.dart';
import 'package:parknspot/controller/LoginController.dart';
import 'package:parknspot/main.dart';

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
      } else if (!LoginController.checkInput(newEmail, InputType.Mail)) {
        Main.showToast('Your new E-Mail input is invalid.');
        return false;
      } else {
        await _loginController.getUser().updateEmail(newEmail);
        await _loginController.getUser().sendEmailVerification();
        _loginController.logout();
        _loginController.showLogin();

        return true;
      }
    } else {
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
        } else {
          FirebaseUser user = _loginController.getUser();
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

  //Delete User account from Firebase Auth
  Future<bool> deleteUser() async {
    FirebaseUser user = _loginController.getUser();
    try {
      await user.delete();
      Main.showToast('Your account was successfuly deleted');
      _loginController.logout();
      _loginController.showLogin();
      return true;
    }
    catch(e) {
      switch (e.code) {
          case 'ERROR_REQUIRES_RECENT_LOGIN':
            Main.showToast('Logout and Login again to verify yourself!');
            break;
        }
    }

    return false;
  }

  void logout() {
    _loginController.logout();
    _loginController.showLogin();
  }
}
