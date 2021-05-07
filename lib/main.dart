import 'package:flutter/material.dart';
import 'package:flutter_test_app/screens/app_controller.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Uncomment this to use the auth emulator for testing
  // await FirebaseAuth.instance.useEmulator('http://localhost:9099');
  runApp(FirstMesiboApp());
}

/// Home widget to display video chat option.
class FirstMesiboApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppController();
  }
}
