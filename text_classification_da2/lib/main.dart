import 'package:flutter/material.dart';
import 'package:tflite_flutter_plugin_example/classifier.dart';
import 'package:tflite_flutter_plugin_example/login.dart';
import 'package:tflite_flutter_plugin_example/messages.dart';
import 'package:translator/translator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
