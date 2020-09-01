import 'package:flutter/material.dart';
import 'package:multiplicaciones_paso_a_paso/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Multiplicaciones',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
