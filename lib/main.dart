import 'package:flutter/material.dart';
import 'package:texas_holdem_app/pages/login.dart';
import 'widgets/drawer.dart';

void main() {
  runApp(const GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // scaffoldBackgroundColor: Colors.grey[900],
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
      ),
      home: const PokerAppMainScreen(),
    );
  }
}

/// The main screen.
class PokerAppMainScreen extends StatefulWidget {
  const PokerAppMainScreen({super.key});

  @override
  State<PokerAppMainScreen> createState() => _PokerAppMainScreenState();
}

class _PokerAppMainScreenState extends State<PokerAppMainScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Poker Pals'),
      ),
      // drawer: const NavigationDrawer(),
      body: const LoginPage());
}
