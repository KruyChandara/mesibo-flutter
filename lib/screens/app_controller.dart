import 'package:flutter/material.dart';
import 'package:flutter_test_app/screens/home/home_screen.dart';
import 'package:flutter_test_app/screens/login/login_screen.dart';
import 'package:flutter_test_app/screens/splash_screen/splash_screen.dart';
import 'package:flutter_test_app/screens/verify_otp/verify_otp_screen.dart';


class AppController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.blueGrey,
          accentColor: Colors.cyan[600],

        ),
      routes: {
        "/": (context) => SplashScreenCustom(),
        "/login": (context) => LoginScreen(),
        "/home": (context) => HomeScreen(),
        "/verify_otp": (context) => PinCodeVerificationScreen("123")
      },
      debugShowCheckedModeBanner: false,
    );
  }
}