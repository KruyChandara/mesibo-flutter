import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class ScreenArguments {
  final String loggedUser;
  final String token;
  final String mail;

  ScreenArguments(this.loggedUser, this.token, this.mail);

  toMap() {
    return {"loggedUser": loggedUser, "token": token, "mail": mail};
  }
}

final Map users = {
  'Dara': ScreenArguments(
      "Dara",
      "13f1fcbeb57785f42fda7d4486b84d81ff6ad01379415fedd306c73",
      "darasmilelip@gmail.com"),
  'Richard': ScreenArguments(
      "Richard",
      "5971263380fde38969cbe536bd00315b7429feadfb6b9b2c2e44308754",
      "richard@mail.com"),
  'Toni': ScreenArguments("Toni",
      "9ae5b1946e613d9f15031630ed915dcaa987fcdce56ebb308755", "toni@mail.com"),
  'Setha': ScreenArguments(
      "Setha",
      "122fcba2fe35708bca9cd74cbc19bcd1e1a1818e5c825e99308756",
      "setha@mail.com"),
  'BoPark': ScreenArguments(
      "Bo Park",
      "f4a07186d59e8f3faab69e30ad2046b71b75d4da559dd11071e22308757",
      "bopark@mail.com"),
  'SoPheak': ScreenArguments(
      "SoPheak",
      "cbc5a041f4157984cdee96e71ab7a1712daa1443e5deee55308758",
      "sopheak@mail.com"),
};

class MyApp extends StatelessWidget {
  final User user;

  MyApp({this.user});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PinCodeVerificationScreen(
          user: user), // a random number, please don't call xD
    );
  }
}

class PinCodeVerificationScreen extends StatefulWidget {
  final User user;

  PinCodeVerificationScreen({this.user});

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  static const platform = const MethodChannel("mesibo.flutter.io/messaging");
  static const EventChannel eventChannel =
      EventChannel('mesibo.flutter.io/mesiboEvents');
  String _mesiboStatus = 'Mesibo status: Not Connected.';

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    super.initState();
  }

  void _onEvent(Object event) {
    setState(() {
      _mesiboStatus = "" + event.toString();
    });
  }

  void _onError(Object error) {
    setState(() {
      _mesiboStatus = 'Mesibo status: unknown.';
    });
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  void verify({code: String}) async {
    String username = "";
    switch (code) {
      case "111111":
        username = "Dara";
        break;
      case "222222":
        username = "Richard";
        break;
      case "333333":
        username = "BoPark";
        break;
      case "444444":
        username = "Toni";
        break;
      case "555555":
        username = "SoPheak";
        break;
      default:
        username = "Setha";
    }
    List<Map> allUsers = [];
    users.forEach((k, v) => allUsers.add(v.toMap()));
    Map loggedUser = users[username].toMap();
    Navigator.pushNamed(context, "/home",
        arguments: ScreenArguments(
            loggedUser["loggedUser"], loggedUser["token"], loggedUser["mail"]));
    await platform.invokeMethod(
        "loginUser", {'loggedUser': loggedUser, 'allUsers': allUsers});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Image(image: AssetImage('assets/images/logo.png'))),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: "",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v.length < 3) {
                          return "I'm from validator";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor:
                            hasError ? Colors.orange : Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Colors.white,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                    children: [
                      TextSpan(
                          text: " RESEND",
                          recognizer: onTapRecognizer,
                          style: TextStyle(
                              color: Color(0xFF91D3B3),
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ]),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      formKey.currentState.validate();
                      // conditions for validating
                      if (currentText.length != 6 ||
                          currentText != "222222" &&
                              currentText != "111111" &&
                              currentText != "444444" &&
                              currentText != "555555" &&
                              currentText != "666666" &&
                              currentText != "333333") {
                        errorController.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() {
                          hasError = true;
                        });
                      } else {
                        setState(() {
                          hasError = false;
                        });
                        verify(code: currentText);
                      }
                    },
                    child: Center(
                        child: Text(
                      "VERIFY".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue[100],
                          offset: Offset(1, -2),
                          blurRadius: 5),
                    ]),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: FlatButton(
                    child: Text("Clear"),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  )),
                  Flexible(
                      child: FlatButton(
                    child: Text("Set Text"),
                    onPressed: () {
                      textEditingController.text = "123456";
                    },
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
