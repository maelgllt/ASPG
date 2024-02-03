import 'package:flutter/material.dart';

import 'Auth.dart';
import 'Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseAuth.initializeSupabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF427D9D),
      body: HomePage(),
    );
  }
}
