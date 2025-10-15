import 'package:flutter/material.dart';
import 'atelier1.dart';
import 'atelier2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Material 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const ProfilePageM3(), // Nous commençons par l'atelier1
    );
  }
}
