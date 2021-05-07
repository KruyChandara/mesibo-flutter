import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_app/screens/verify_otp/verify_otp_screen.dart';

/// Home widget to display video chat option.
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chat"),
      ),
      body: Center(
        child: HomeWidget(),
      ),
    );
  }
}

/// Widget to display start video call layout.
class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeWidgetState();
  }
}

class _HomeWidgetState extends State<HomeWidget> {
  static const platform = const MethodChannel("mesibo.flutter.io/messaging");
  TextEditingController messageController = new TextEditingController();

  @override
  initState() {
    super.initState();
    messageController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments arguments = ModalRoute.of(context).settings.arguments;
    String loggedUser = arguments.loggedUser;
    const users = [
      "Dara",
      "Richard",
      "Bo Park",
      "Ly Setha",
      "Khun Sopheak",
      "Toni"
    ];
    return Container(
      child: Column(children: [
        for (var user in users)
          if (user != loggedUser)
            Card(
              child: ListTile(
                title: Text(user),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.call, color: Colors.blueGrey),
                      onPressed: () => _audioCall(user),
                    ),
                    IconButton(
                      icon: Icon(Icons.video_call, color: Colors.blueGrey),
                      onPressed: () => _videoCall(user),
                    ),
                  ],
                ),
                onTap: () => _launchMessagingUI(user),
                leading: Icon(Icons.person, color: Colors.blueGrey),
              ),
            ),
        Text("Logged in as: " + loggedUser)
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getUserMail(String name) {
    String userMail = "darasmilelip@gmail.com";
    switch (name) {
      case "Dara":
        userMail = "darasmilelip@gmail.com";
        break;
      case "Toni":
        userMail = "toni@mail.com";
        break;
      case "Khun Sopheak":
        userMail = "sopheak@mail.com";
        break;
      case "Richard":
        userMail = "richard@mail.com";
        break;
      case "Bo Park":
        userMail = "bopark@mail.com";
        break;
      case "Ly Setha":
        userMail = "setha@mail.com";
        break;
    }
    return userMail;
  }

  void _launchMessagingUI(String user) async {
    await platform.invokeMethod(
        "launchMessagingUI", {"remoteUser": this.getUserMail(user)});
  }

  void _audioCall(String user) async {
    await platform
        .invokeMethod("audioCall", {"remoteUser": this.getUserMail(user)});
  }

  void _videoCall(String user) async {
    await platform
        .invokeMethod("videoCall", {"remoteUser": this.getUserMail(user)});
  }
}
