import 'package:flutter/material.dart';
import 'package:parknspot/controller/LoginController.dart';
import 'package:parknspot/controller/ProfileController.dart';
import 'package:parknspot/view/Login.dart';
import 'package:parknspot/ThemeGlobals.dart';

class Profile extends StatefulWidget {
  final LoginController _loginController;

  Profile(this._loginController);

  State<StatefulWidget> createState() {
    return ProfileState(_loginController);
  }
}

class ProfileState extends State<Profile> {
  final LoginController _loginController;
  ProfileController _profileController;

  ProfileState(this._loginController) {
    _profileController = new ProfileController(_loginController);
  }

  final TextEditingController _currentEmailController = new TextEditingController();
  final TextEditingController _newEmailController = new TextEditingController();
  final TextEditingController _currentPasswordController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _passwordConfirmController = new TextEditingController();
  
  final _passwordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 50, 15, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Text(
                  'Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: ThemeGlobals.heading,
                      fontFamily: 'Montserrat'),
                ),
              ),
              Container(
                child: Card(
                  elevation: 1.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.album),
                        title: Text(_loginController.getUser().email),
                        subtitle: Text('You sad bro?'),
                      )
                    ],
                  ),
                ),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    color: ThemeGlobals.primaryButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: ThemeGlobals.buttonBorderRadius,
                    ),
                    child: Text('Change email',
                        style: TextStyle(
                            fontSize: 25.0,
                            color: ThemeGlobals.secondaryTextColor,
                            fontWeight: ThemeGlobals.mediumWeight,
                            fontFamily: 'Montserrat')),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(

                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0))),
                            content: Container(
                              width: 250.0,
                              height: 150.0,
                              child: Form(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: _currentEmailController,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 15.0, 20.0, 15.0),
                                            filled: true,
                                            fillColor:
                                                ThemeGlobals.buttonFillColor,
                                            prefixIcon: Icon(Icons.mail),
                                            hintText: 'Email',
                                            labelText: 'Current Email*',
                                            border: OutlineInputBorder(
                                                borderRadius: ThemeGlobals
                                                    .dialogInputRadius,
                                                borderSide: BorderSide.none)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: _newEmailController,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 15.0, 20.0, 15.0),
                                            filled: true,
                                            fillColor:
                                                ThemeGlobals.buttonFillColor,
                                            prefixIcon: Icon(Icons.mail),
                                            hintText: 'Email',
                                            labelText: 'New Email*',
                                            border: OutlineInputBorder(
                                                borderRadius: ThemeGlobals
                                                    .dialogInputRadius,
                                                borderSide: BorderSide.none)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              FlatButton(
                                child: Text("Cancel",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                        fontWeight: ThemeGlobals.mediumWeight,
                                        fontFamily: 'Montserrat')),
                                color: ThemeGlobals.secondaryButtonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: ThemeGlobals.dialogButtonRadius,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("Save",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                        fontWeight: ThemeGlobals.mediumWeight,
                                        fontFamily: 'Montserrat')),
                                color: ThemeGlobals.confirmButtonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: ThemeGlobals.dialogButtonRadius,
                                ),
                                onPressed: () {
                                  _profileController.changeEmail(_currentEmailController.text, _newEmailController.text);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: RaisedButton(
                            color: Colors.blue.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: ThemeGlobals.buttonBorderRadius,
                            ),
                            child: Text('Change password',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: ThemeGlobals.secondaryTextColor,
                                    fontWeight: ThemeGlobals.mediumWeight,
                                    fontFamily: 'Montserrat')),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0))),
                                    content: Container(
                                      width: 260.0,
                                      child: Form(
                                        key: _passwordFormKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller:
                                                    _currentPasswordController,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            20.0,
                                                            15.0,
                                                            20.0,
                                                            15.0),
                                                    filled: true,
                                                    fillColor: ThemeGlobals
                                                        .buttonFillColor,
                                                    prefixIcon:
                                                        Icon(Icons.lock),
                                                    hintText: 'Password',
                                                    labelText:
                                                        'Current Password*',
                                                    border: OutlineInputBorder(
                                                        borderRadius: ThemeGlobals
                                                            .dialogInputRadius,
                                                        borderSide:
                                                            BorderSide.none)),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller: _passwordController,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            20.0,
                                                            15.0,
                                                            20.0,
                                                            15.0),
                                                    filled: true,
                                                    fillColor: ThemeGlobals
                                                        .buttonFillColor,
                                                    prefixIcon:
                                                        Icon(Icons.lock),
                                                    hintText: 'Password',
                                                    labelText: 'New Password*',
                                                    border: OutlineInputBorder(
                                                        borderRadius: ThemeGlobals
                                                            .dialogInputRadius,
                                                        borderSide:
                                                            BorderSide.none)),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller:
                                                    _passwordConfirmController,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            20.0,
                                                            15.0,
                                                            20.0,
                                                            15.0),
                                                    filled: true,
                                                    fillColor: ThemeGlobals
                                                        .buttonFillColor,
                                                    prefixIcon:
                                                        Icon(Icons.lock),
                                                    hintText: 'Password',
                                                    labelText:
                                                        'Confirm Password*',
                                                    border: OutlineInputBorder(
                                                        borderRadius: ThemeGlobals
                                                            .dialogInputRadius,
                                                        borderSide:
                                                            BorderSide.none)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                        child: Text("Cancel",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black,
                                                fontWeight:
                                                    ThemeGlobals.mediumWeight,
                                                fontFamily: 'Montserrat')),
                                        color:
                                            ThemeGlobals.secondaryButtonColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              ThemeGlobals.dialogButtonRadius,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Save",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black,
                                                fontWeight:
                                                    ThemeGlobals.mediumWeight,
                                                fontFamily: 'Montserrat')),
                                        color: ThemeGlobals.confirmButtonColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              ThemeGlobals.dialogButtonRadius,
                                        ),
                                        onPressed: () {
                                          _profileController.changePassword(
                                              _currentPasswordController.text,
                                              _passwordController.text,
                                              _passwordConfirmController.text);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              FlatButton(
                                child: Text("Cancel",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                        fontWeight: ThemeGlobals.mediumWeight,
                                        fontFamily: 'Montserrat')),
                                color: ThemeGlobals.secondaryButtonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: ThemeGlobals.dialogButtonRadius,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("Save",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                        fontWeight: ThemeGlobals.mediumWeight,
                                        fontFamily: 'Montserrat')),
                                color: ThemeGlobals.confirmButtonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: ThemeGlobals.dialogButtonRadius,
                                ),
                                onPressed: () {
                                  if (_passwordFormKey.currentState.validate()) {
                                    _passwordFormKey.currentState.save();
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    color: ThemeGlobals.dangerButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: ThemeGlobals.buttonBorderRadius,
                    ),
                    child: Text('Logout',
                        style: TextStyle(
                            fontSize: 25.0,
                            color: ThemeGlobals.secondaryTextColor,
                            fontWeight: ThemeGlobals.mediumWeight,
                            fontFamily: 'Montserrat')),
                    onPressed: () {
                      _profileController.logout();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
