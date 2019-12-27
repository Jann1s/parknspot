//COLORS

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ThemeGlobals {
  //COLORS
  static Color parknspotMain = Colors.blue.shade300;
  static Color primaryButtonColor = Colors.blue.shade300;
  static Color secondaryButtonColor = Colors.grey;
  static Color confirmButtonColor = Colors.green.shade300;
  static Color dangerButtonColor = Colors.redAccent.shade400;
  static Color buttonFillColor = Colors.grey.shade200;
  static Color secondaryTextColor = Colors.white;
  static Color tertiaryTextColor = Colors.grey.shade800;
  static Color shadow = Colors.grey;

  //Spacers
  static SizedBox smallSpacer = SizedBox(
    height: 15,
  );
  static SizedBox mediumSpacer = SizedBox(
    height: 70,
  );
  static SizedBox bigSpacer = SizedBox(
    height: 100,
  );

//Raius Styles
  static BorderRadius buttonBorderRadius = BorderRadius.circular(2.0);
  static BorderRadius inputFieldRadius = BorderRadius.circular(2.0);
  static BorderRadius dialogInputRadius = BorderRadius.circular(2.0);
  static BorderRadius dialogButtonRadius = BorderRadius.circular(2.0);

  //Font
  static FontWeight heading = FontWeight.bold;
  static FontWeight smallWeight = FontWeight.w200;
  static FontWeight mediumWeight = FontWeight.w500;
  static FontWeight description = FontWeight.w300;
  static FontWeight subHeading = FontWeight.w400;

  //Images
  static Image logo = Image.asset('assets/logoNoBorder.png');
  static Image animatedLogo = Image.asset(
    'assets/loginAnimation.gif',
    height: 100,
    width: 100,
  );
}
