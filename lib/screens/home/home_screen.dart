import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Home widget to display video chat option.
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    return
      Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Chats"),
        ),
        body: Center(
          child: HomeWidget(args: args),
        ),
      );

  }
}

/// Widget to display start video call layout.
class HomeWidget extends StatefulWidget {
  final String args;
  HomeWidget({Key key, @required this.args}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState(args);
}

class _HomeWidgetState extends State<HomeWidget> {

  final String args;
  _HomeWidgetState(this.args);


  static const platform = const MethodChannel("mesibo.flutter.io/messaging");
  static const EventChannel eventChannel =
      EventChannel('mesibo.flutter.io/mesiboEvents');
  String _mesiboStatus = 'Mesibo status: Not Connected.';
  TextEditingController messageController = new TextEditingController();

  @override
  void initState() {
    if(this.args == "123456"){
      _loginUser1();
    }else{
      _loginUser2();
    }
    super.initState();
    messageController = TextEditingController(text: '');
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
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
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Card(
          child: ListTile(
              title: Text('Dara'),
              trailing: IconButton(
                icon: Icon(Icons.call, color: Colors.blueGrey),
                onPressed: _audioCall,
              ),
              onTap: _launchMessagingUI,
              leading: CircleAvatar(
                backgroundImage: AssetImage("assets/images/user1.jpg"),
              )),
        ),
        Card(
          child: ListTile(
            title: Text('Richard'),
            onTap: _launchMessagingUI,
            trailing: IconButton(
              icon: Icon(Icons.call, color: Colors.blueGrey),
              onPressed: _audioCall,
            ),
            leading: CircleAvatar(
                backgroundImage: AssetImage("assets/images/user2.jpg")),
          ),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _sendMessage() async {
    print("Send Message clicked");
    await platform
        .invokeMethod('sendMessage', {"message": messageController.text});
    messageController.text = "";
  }

  void _launchMessagingUI() async {
    print("LaunchMesibo clicked");
    await platform.invokeMethod("launchMessagingUI");
  }

  void _loginUser1() async {
    print("Login As user1");
    await platform.invokeMethod("loginUser1");
  }

  void _loginUser2() async {
    print("Login As user2");
    await platform.invokeMethod("loginUser2");
  }

  void _audioCall() async {
    print("AudioCall clicked");
    await platform.invokeMethod("audioCall");
  }

  void _videoCall() async {
    print("VideoCall clicked");
    await platform.invokeMethod("videoCall");
  }
}

/// Widget to display start video call title.
class InfoTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Text(
          "This is Sample Flutter App that uses Mesibo for Messaging and Audio/Video calls .",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
