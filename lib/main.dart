import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:agripediav3/Authentication/login_screen.dart';
import 'package:agripediav3/HomePage/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<User?> _checkAuthState() async {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _checkAuthState(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasData){
            return MyHomePage();
          }  else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
