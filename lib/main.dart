// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:note_app_1/screens/note_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NoteScreen(), debugShowCheckedModeBanner: false);
  }
}

