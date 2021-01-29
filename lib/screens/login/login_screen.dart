import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

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
            children: <Widget> [
              SizedBox(
                height: 20,
              ),
              Text("Login with your phone number", style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize:
                  Theme.of(context).textTheme.headline6.fontSize)
              ),
              SizedBox(height: 30),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'eg: +85587868278',
                  labelText: "Phone number",
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(onPressed: (){
                Navigator.pushNamed(context, "/verify_otp");
              }, child: Text("Continue"))
            ],
          ),
        ),
      )
    );
  }
}
