import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agripediav3/Authentication/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

Future<void> addCropToUser(String cropName, DateTime plantingDate, String hardwareID, File? cropImage) async {
  // get currently logged in user
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    print('No user is logged in. Please Sign-in');
    return;
  }

  // Reference to user's crop subcollection
  DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
  CollectionReference cropsCollection = userDoc.collection('crops');

  String? imageUrl;
  if (cropImage != null) {
    // upload image to firebase storage
    final storageRef = FirebaseStorage.instance.ref()
        .child('crop_images/${user.uid}/${cropName}_${DateTime.now().millisecondsSinceEpoch}.jpg');

    await storageRef.putFile(cropImage);
    imageUrl = await storageRef.getDownloadURL();
  }

  // add the new crop document
  await cropsCollection.add({
    'cropName': cropName,
    'plantingDate': plantingDate,
    'hardwareID': hardwareID,
    'imageUrl': imageUrl,
  });

  print("Crop added to $user successfully!");
}