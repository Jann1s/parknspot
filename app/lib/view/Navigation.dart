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
  int _currentPage = 1;

  PageController _pageController = PageController(
    initialPage: 1,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: onPageChanged,
          children: <Widget>[
            Parking(), MyMap(), Profile()
          ],
        ),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: AppBar()
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage,
          onTap: onNavigationTap,
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

  void onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void onNavigationTap(int newPage) {
    switch(newPage) {
      case 0:
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
        );
        _currentPage = 0;
        break;
      case 1:
        _pageController.animateToPage(
          1,
          duration: Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
        );
        _currentPage = 1;
        break;
      case 2:
        _pageController.animateToPage(
          2,
          duration: Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
        );
        _currentPage = 2;
        break;
      default:
        break;
    }
  }
}
