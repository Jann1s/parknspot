import 'package:flutter/material.dart';
import 'package:parknspot/view/Map.dart';
import 'package:parknspot/view/Parking.dart';
import 'package:parknspot/view/Profile.dart';

class Navigation extends StatefulWidget {
  State<StatefulWidget> createState() {
    return NavigationState();
  }
}

class NavigationState extends State<Navigation> {
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
      home: Scaffold(
        body: _pageOptions[_selectedPage],
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: AppBar()
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPage,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue[800],
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.local_parking), title: Text('Parking')),
            BottomNavigationBarItem(
                icon: Icon(Icons.map), title: Text('Map')),
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
