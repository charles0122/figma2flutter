import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Figma2Flutter Demo',
        home: Scaffold(
          appBar: AppBar(title: const Text('Figma2Flutter')),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
        
              ],
            ),
          ),
        ),
      );
  }
}

