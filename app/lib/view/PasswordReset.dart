import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parknspot/ThemeGlobals.dart';
import 'package:parknspot/controller/LoginController.dart';

class PasswordReset {
  final LoginController _loginController;
  TextEditingController _emailController = new TextEditingController();

  PasswordReset(this._loginController);

  Widget getView() {
    return Center(
      child: Form(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                        return 'Email is required';
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
                    child: Text('Reset',
                        style: TextStyle(
                            fontSize: 25.0,
                            color: ThemeGlobals.secondaryTextColor,
                            fontWeight: ThemeGlobals.mediumWeight,
                            fontFamily: 'Montserrat')),
                    onPressed: () async {
                      await _loginController
                          .resetPassword(_emailController.text);
                      _loginController.showLogin();
                    },
                  ),
                ),
                SizedBox(
                  child: FlatButton(
                    onPressed: () {
                      _loginController.showLogin();
                    },
                    hoverColor: Colors.teal,
                    child: Center(
                      child: Text('Back to Login',
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
