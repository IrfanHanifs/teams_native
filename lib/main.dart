import 'package:flutter/material.dart';
import 'package:teams_native/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fluid HR Login',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Roboto', // Using standard Roboto, but design looks like Inter or similar
      ),
      home: const LoginPage(),
    );
  }
}
