import 'package:flutter/material.dart';
import 'package:parknspot/view/Map.dart';
import 'package:parknspot/view/Parking.dart';
import 'package:parknspot/view/Profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  int _selectedPage = 1;
  final _pageOptions = [Parking(), MyMap(), Profile()];
  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(

        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPage,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue[800],
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.local_parking), title: Text('Parking')),
            BottomNavigationBarItem(
                icon: Icon(Icons.directions), title: Text('Map')),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle),
                title: Text('Profile')),
          ],
        ),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        // Define the default font family.
        fontFamily: 'Montserrat',
        primarySwatch: Colors.blue,
      ),
    );
  }
}
