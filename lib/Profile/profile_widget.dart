import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
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
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  SizedBox(width: 10), // Add space between avatar and text
                  Text(
                    'Welcome, Kyle!',
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
                  onPressed: () {
                    // Add logout functionality here
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
