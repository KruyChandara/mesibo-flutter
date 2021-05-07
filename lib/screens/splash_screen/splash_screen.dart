import 'package:flutter/material.dart';
import 'package:flutter_test_app/screens/login/login_screen.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 2,
        navigateAfterSeconds: new LoginScreen(),
        title: new Text('Welcome Back'),
        image: Image(image: AssetImage('assets/images/rotate-logo.gif')),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 110.0,
        loaderColor: Colors.orange[500]);
  }
}
