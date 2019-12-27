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

  void logout() {
    _loginController.logout();
    _loginController.showLogin();
  }
}