import 'package:flutter/material.dart';
import 'package:parknspot/view/SplashScreen.dart';
import 'package:parknspot/ThemeGlobals.dart';
import 'package:parknspot/controller/LoginController.dart';
import 'package:parknspot/controller/MapController.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parknspot/controller/RegisterController.dart';
import 'package:parknspot/view/Map.dart';
import 'package:parknspot/view/Parking.dart';
import 'package:parknspot/view/Profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  State<StatefulWidget> createState() {
    return Main();
  }
}

class Main extends State<MyApp> {
  CurrentPage _pageView = CurrentPage.Splashscreen;
  bool _checkedLogin = false;
  bool _loginVisible = true;
  bool _bottomNavBarVisible = false;

  int _currentPage = 1;
  PageController _pageController = PageController(
    initialPage: 1,
  );

  LoginController _loginController;
  RegisterController _registerController;


  Main() {
    _registerController = new RegisterController(this);
    _loginController = new LoginController(this);
    _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Park\'n\'Spot',
      home: Scaffold(
        body: _getPageBody(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: AppBar()
        ),
        bottomNavigationBar: _bottomNavBarVisible ? BottomNavigationBar(
          currentIndex: _currentPage,
          onTap: _onNavigationTap,
          selectedItemColor: ThemeGlobals.parknspotMain,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.local_parking), title: Text('Parking')),
            BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Map')),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle),
                title: Text('Profile')),
          ],
        ) : null,
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Montserrat',
        primarySwatch: Colors.blue,
      ),
    );
  }

  Widget _getPageBody() {
    if (CurrentPage.MainApp == _pageView) {
      return PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: _onPageChanged,
        children: <Widget>[Parking(), MyMap(), Profile(_loginController)],
      );
    }
    else if (CurrentPage.Login == _pageView) {
      return _loginController.getView();
    }
    else if (CurrentPage.Register == _pageView) {
      return _registerController.getView();
    }
    else if (CurrentPage.ForgotPassword == _pageView) {
      return _loginController.getResetView();
    }
    else if (CurrentPage.Splashscreen == _pageView) {
      return SplashScreen();
    }
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void _onNavigationTap(int newPage) {
    switch (newPage) {
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

  LoginController getLoginController() {
    return _loginController;
  }

  void showMap() {
    //Navigate to map screen
  }

  void successfulLogin() {
    setState(() {
      _pageView = CurrentPage.MainApp;
      _bottomNavBarVisible = true;
    });
  }

  void showLogin() {
    setState(() => _pageView = CurrentPage.Login);
  }

  void showRegister() {
    setState(() => _pageView = CurrentPage.Register);
  }

  void showResetPassword() {
    setState(() => _pageView = CurrentPage.ForgotPassword);
  }

  static void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        fontSize: 16.0
    );
  }

  void _checkLogin() async {
    bool loggedIn = await _loginController.checkLoggedIn();

    if (loggedIn) {
      successfulLogin();
    }
    else {
      setState(() {
        _pageView = CurrentPage.Login;
      });
    }
  }
}

enum CurrentPage {
  MainApp,
  Login,
  Register,
  Splashscreen,
  ForgotPassword
}