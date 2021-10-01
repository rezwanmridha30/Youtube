import 'package:flutter/material.dart';
import 'package:my_youtube_api/screens/home_screen.dart';

void main() {
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
         primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

