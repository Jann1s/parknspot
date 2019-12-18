import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
              'Profile',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            RaisedButton (
              color: Colors.green[300],
              child: Text('Change Email'),
              onPressed:() {
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
            RaisedButton (
              color: Colors.green[300],
              child: Text('Change Password'),
              onPressed:() {
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
            RaisedButton (
              color: Colors.red[300],
              child: Text('Logout'),
              onPressed:() {

              },
            
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}