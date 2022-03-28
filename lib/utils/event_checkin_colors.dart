import 'package:flutter/material.dart';

class EventCheckinColors {
  static const primary = Colors.red;
  static const secondary = Color(0xffffc107);
  static const success = Color(0xff4caf50);
  static const warning = Color(0xffff9800);
  static const danger = Color(0xfff44336);
  static const info = Color(0xff2196f3);
  static const light = Color(0xfff1f1f1);
  static const dark = Color(0xff212121);

  static const primaryLight = Color(0xFF00bcd4);
  static const secondaryLight = Color(0xffffc107);
  static const successLight = Color(0xff4caf50);
  static const warningLight = Color(0xffff9800);
  static const dangerLight = Color(0xfff44336);
  static const infoLight = Color(0xff2196f3);
  static const lightLight = Color(0xfff1f1f1);
  static const darkLight = Color(0xff212121);

  static const primaryDark = Color(0xFF00bcd4);
  static const secondaryDark = Color(0xffffc107);
  static const successDark = Color(0xff4caf50);
  static const warningDark = Color(0xffff9800);
  static const dangerDark = Color(0xfff44336);
  static const infoDark = Color(0xff2196f3);
  static const lightDark = Color(0xfff1f1f1);
  static const darkDark = Color(0xff212121);

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
  static const secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, primary],
  );
  static const successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, secondary],
  );
  static const warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warning, secondary],
  );
  static const dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [danger, secondary],
  );
  static const infoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [info, secondary],
  );
  static const lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [light, secondary],
  );
  static const darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [dark, secondary],
  );

  static const tick = Colors.greenAccent;
  static const cross = Colors.redAccent;
  static const background = Colors.white;
}
