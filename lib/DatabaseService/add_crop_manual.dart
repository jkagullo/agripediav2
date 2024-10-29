import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agripediav3/Authentication/login_screen.dart';

Future<void> addCropToUser(String cropName, DateTime plantingDate, String hardwareID) async {
  // get currently logged in user
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    print('No user is logged in. Please Sign-in');
    return;
  }

  // Reference to user's crop subcollection
  DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
  CollectionReference cropsCollection = userDoc.collection('crops');

  // add the new crop document
  await cropsCollection.add({
    'cropName': cropName,
    'plantingDate': plantingDate,
    'hardwareID': hardwareID,
  });

  print("Crop added to $user successfully!");
}