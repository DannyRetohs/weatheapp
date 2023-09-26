import 'package:flutter/material.dart';
import 'package:weatherapp/ui/login_screen.dart';
import 'package:weatherapp/ui/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      color: Colors.deepPurpleAccent,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: "/login",
      routes: {
        '/login': (context) => const LoginScreen(),
        '/Welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}

