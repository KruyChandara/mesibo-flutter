import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_app/screens/verify_otp/verify_otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String actualCode;

  Future registerUser(String mobile, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: "+85587868278",
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) {
          _auth
              .signInWithCredential(authCredential)
              .then((UserCredential result) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PinCodeVerificationScreen(user: result.user)));
          }).catchError((e) {
            print('==========');
            print(e);
          });
        },
        verificationFailed: null,
        codeSent: null,
        codeAutoRetrievalTimeout: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text("Login with your phone number",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize:
                            Theme.of(context).textTheme.headline6.fontSize)),
                SizedBox(height: 30),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'eg: +85587868278',
                    labelText: "Phone number",
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                    onPressed: () async {
                      await this.registerUser("+85587868278", context);
                    },
                    child: Text("Continue"))
              ],
            ),
          ),
        ));
  }
}
