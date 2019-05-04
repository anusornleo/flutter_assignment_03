import 'package:flutter/material.dart';
import 'package:health_app/ui/todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment_03',
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'SF-Pro-Text8'),
      debugShowCheckedModeBanner: false,
      home: new TodoScreen(),
    );
  }
}
