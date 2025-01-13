import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agripediav3/Authentication/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

Future<void> addCropToUser(
    String cropName,
    DateTime plantingDate,
    String hardwareID,
    String cropType,
    File? cropImage,
    ) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    print('No user is logged in. Please Sign-in');
    return;
  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  // Check if hardware ID exists in any user's crops
  QuerySnapshot hardwareQuery = await db.collectionGroup('crops')
      .where('hardwareID', isEqualTo: hardwareID)
      .get();

  if (hardwareQuery.docs.isNotEmpty) {
    // If hardware ID exists, check if it belongs to the current user
    for (var doc in hardwareQuery.docs) {
      String ownerUID = doc.reference.parent.parent?.id ?? '';
      if (ownerUID == user.uid) {
        throw Exception('This hardware ID is already linked to another crop in your account.');
      } else {
        // Use cropType from the original owner for consistency
        cropType = doc.get('cropType');
      }
    }
  }

  // Reference to user's crop subcollection
  DocumentReference userDoc = db.collection('users').doc(user.uid);
  CollectionReference cropsCollection = userDoc.collection('crops');

  String? imageUrl;
  if (cropImage != null) {
    final storageRef = FirebaseStorage.instance.ref()
        .child('crop_images/${user.uid}/${cropName}_${DateTime.now().millisecondsSinceEpoch}.jpg');

    await storageRef.putFile(cropImage);
    imageUrl = await storageRef.getDownloadURL();
  }

  // Add the new crop document
  await cropsCollection.add({
    'cropName': cropName,
    'plantingDate': plantingDate,
    'hardwareID': hardwareID,
    'cropType': cropType,
    'imageUrl': imageUrl,
  });

  print("Crop added to $user successfully!");
}
