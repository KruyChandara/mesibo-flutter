import 'package:flutter/material.dart';
import 'package:flutter_test_app/screens/app_controller.dart';

void main() {
  runApp(FirstMesiboApp());
}

/// Home widget to display video chat option.
class FirstMesiboApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppController();
  }
}