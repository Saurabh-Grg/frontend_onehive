import 'package:flutter/material.dart';
import 'package:onehive_frontend/providers/user_provider.dart';
import 'package:onehive_frontend/screens/login_form.dart';
import 'package:onehive_frontend/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class OneHive extends StatelessWidget {
  OneHive({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OneHive',
      theme: ThemeData(
          primarySwatch: Colors.orange
      ),
      home: WelcomeScreen(),
      routes: {
        '/login': (context) => LoginForm(),
      },
    );
  }
}

void main() {
  runApp(
    MultiProvider( // Use MultiProvider to provide multiple providers
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()), // Initialize UserProvider
      ],
      child: OneHive(),
    ),
  );
}