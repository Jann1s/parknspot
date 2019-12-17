import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parknspot/view/Navigation.dart';

class Register extends StatefulWidget {
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
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
                    child: Text('Register',
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat')),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  TextFormField(
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
                          return 'Email is required';
                        }
                        return null;
                      }),
                  //Space between; TO BE ADDED TO GLOBALS

                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
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
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Confirm Password",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Password confirmation is required';
                      }
                      return null;
                    },
                  ),
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
                      child: Text('Register',
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat')),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Navigation()));
                      },
                    ),
                  ),
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
