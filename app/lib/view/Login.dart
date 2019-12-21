import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parknspot/controller/LoginController.dart';
import 'package:parknspot/view/Navigation.dart';
import 'package:parknspot/view/Register.dart';

class Login extends StatefulWidget {
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {

  LoginController _loginController = new LoginController();

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  bool _checkForUser = false;

  void _checkLogin(BuildContext context) async {
    LoginController loginController = new LoginController();
    bool loggedIn = await loginController.checkLoggedIn();

    if (loggedIn) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Navigation()));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_checkForUser) {
      _checkForUser = true;
      _checkLogin(context);
    }

    return Scaffold(
      body: Center(
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
                            color: Colors.grey,
                            blurRadius:
                                5.0, // has the effect of softening the shadow
                            spreadRadius:
                                0.5, // has the effect of extending the shadow
                            offset: Offset(
                              0.0, // horizontal, move right 10
                              0.0, // vertical, move down 10
                            ),
                          )
                        ],
                      ),
                      child: Image.asset(
                        'assets/loginAnimation.gif',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70.0,
                  ),
                  TextFormField(
                    controller: _emailController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: "email",
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide.none)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      }),
                  //Space between; TO BE ADDED TO GLOBALS
                  SizedBox(
                    height: 15.0,
                  ),
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
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide.none)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      color: Colors.blue.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text('Login',
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat')),
                      onPressed: () async {
                        bool loggedIn = await _loginController.loginUser(_emailController.text, _passwordController.text);
                        if (loggedIn) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navigation()));
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                      hoverColor: Colors.teal,
                      child: Center(
                        child: Text('Don\'t have an account? Sign up',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Montserrat')),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
