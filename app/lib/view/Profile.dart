import 'package:flutter/material.dart';
import 'package:parknspot/controller/LoginController.dart';
import 'package:parknspot/view/Login.dart';
import 'package:parknspot/view/Map.dart';

class Profile extends StatefulWidget {
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  LoginController _loginController = new LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Text(
                  'Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30,),
                ),
              ),
              Container(
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut eleifend ut dolor ut faucibus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nunc nec mollis tellus, vel dapibus sapien. In pulvinar fermentum vulputate. Maecenas auctor nisi eu mauris volutpat placerat. Maecenas et metus at dui vehicula scelerisque. Sed cursus mi nibh, ac ornare tellus consectetur in.',
                  textAlign: TextAlign.justify,
                ),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
              ),
              Expanded(child: Container(),),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.blue.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text('Change email',
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat')),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context)
                        {
                          return AlertDialog(
                            content: Form(
                              key: _emailFormKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.person),
                                        hintText: 'Email',
                                        labelText: 'Current Email*',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.person),
                                        hintText: 'Email',
                                        labelText: 'New Email*',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),

                                    child: RaisedButton(
                                      child: Text("Submit"),
                                      color: Colors.green[300],
                                      onPressed: () {
                                        if (_emailFormKey.currentState.validate()) {
                                          _emailFormKey.currentState.save();
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.blue.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text('Change password',
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat')),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context)
                        {
                          return AlertDialog(
                            content: Form(
                              key: _passwordFormKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.lock),
                                        hintText: 'Password',
                                        labelText: 'Current Password*',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.lock),
                                        hintText: 'Password',
                                        labelText: 'New Password*',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.lock),
                                        hintText: 'Password',
                                        labelText: 'Confirm Password*',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                      child: Text("Submit"),
                                      color: Colors.green[300],
                                      onPressed: () {
                                        if (_passwordFormKey.currentState.validate()) {
                                          _passwordFormKey.currentState.save();
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.redAccent.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text('Logout',
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat')),
                    onPressed: () {
                      _loginController.logout();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login()));
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