import 'package:flutter/material.dart';
import 'package:agripediav3/Authentication/login.dart';
import 'package:agripediav3/Authentication/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final LoginService _loginService = LoginService();
  String? _username;
  String? _imageUrl;

  @override
  void initState(){
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        _username = userDoc['name'];
        _imageUrl = userDoc['imageUrl'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35.0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.lightGreen[50],
                    radius: 35,
                    backgroundImage:
                    _imageUrl != null ? NetworkImage(_imageUrl!)
                    : AssetImage('assets/images/default_profile.jpg') as ImageProvider,
                  ),
                  SizedBox(width: 10), // Add space between avatar and text
                  Text(
                    _username != null ? 'Hi, $_username' : 'Welcome, User',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen[900],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.logout,color: Colors.lightGreen[900],
                  ),
                  onPressed: () async {
                    await _loginService.signOutUser();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
