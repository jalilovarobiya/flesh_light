import 'package:flutter/material.dart';
import 'package:platformaga_xos_kodlar/flesh_light.dart';

void main() {
  runApp(const FleshLightApp());
}

class FleshLightApp extends StatelessWidget {
  const FleshLightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: FleshLight());
  }
}
