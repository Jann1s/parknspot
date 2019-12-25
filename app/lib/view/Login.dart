import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parknspot/controller/LoginController.dart';
import 'package:parknspot/ThemeGlobals.dart';


class Login {

  final LoginController _loginController;

  Login(this._loginController);

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  //bool _checkForUser = false;

  /*
  void _checkLogin(BuildContext context) async {
    LoginController loginController = new LoginController();
    bool loggedIn = await loginController.checkLoggedIn();

    if (loggedIn) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Navigation()));
    }
  }*/

  Widget getView() {
    return Center(
      child: Form(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ThemeGlobals.shadow,
                          blurRadius:
                          5.0, // has the effect of softening the shadow
                          spreadRadius:
                          0.5, // has the effect of extending the shadow
                          offset: Offset(
                            0.0, // horizontal, move right
                            0.0, // vertical, move down
                          ),
                        )
                      ],
                    ),
                    child: ThemeGlobals.animatedLogo,
                  ),
                ),
                ThemeGlobals.mediumSpacer,
                TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "email",
                        filled: true,
                        fillColor: ThemeGlobals.buttonFillColor,
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: ThemeGlobals.inputFieldRadius,
                            borderSide: BorderSide.none)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    }),
                ThemeGlobals.smallSpacer,
                TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: ThemeGlobals.inputFieldRadius,
                            borderSide: BorderSide.none)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    }),
                ThemeGlobals.smallSpacer,
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    color: ThemeGlobals.parknspotMain,
                    shape: RoundedRectangleBorder(
                      borderRadius: ThemeGlobals.buttonBorderRadius,
                    ),
                    child: Text('Login',
                        style: TextStyle(
                            fontSize: 25.0,
                            color: ThemeGlobals.secondaryTextColor,
                            fontWeight: ThemeGlobals.mediumWeight,
                            fontFamily: 'Montserrat')),
                    onPressed: () async {
                      bool loggedIn = await _loginController.loginUser(_emailController.text, _passwordController.text);
                      if (loggedIn) {
                        _loginController.successfulLogin();
                      }
                    },
                  ),
                ),
                ThemeGlobals.smallSpacer,
                SizedBox(
                  child: FlatButton(
                    onPressed: () {
                      _loginController.showRegister();
                    },
                    hoverColor: Colors.teal,
                    child: Center(
                      child: Text('Don\'t have an account? Sign up',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: ThemeGlobals.description,
                              fontFamily: 'Montserrat')),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
