import 'package:flutter/material.dart';
import "package:swadesh_challenge/Home/home_page.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: Colors.black)),
      home: const HomePage(),
    );
  }
}
