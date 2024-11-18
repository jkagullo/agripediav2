import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePageUpdate {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, String?>> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) return {};
    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data();
    return {
      'username': data?['name'], // Use 'name' for username
      'email': user.email,
      'profileImageUrl': data?['imageUrl'], // Fetch profile image URL
    };
  }

  Future<void> updateUserData(Map<String, String> updatedFields) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Ensure keys match Firestore structure
    final validFields = {
      'name': updatedFields['name'], // Update 'name' field
      'imageUrl': updatedFields['imageUrl'], // Update 'imageUrl' field
    }..removeWhere((key, value) => value == null); // Remove null values

    await _firestore.collection('users').doc(user.uid).update(validFields);
  }

  Future<String> uploadProfileImage(File image) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    try {
      // Create a reference to the storage path
      final ref = _storage.ref().child('profile_images/${user.uid}.jpg');

      // Upload the file
      final uploadTask = await ref.putFile(image);

      // Wait for the upload to complete and get the URL
      if (uploadTask.state == TaskState.success) {
        return await ref.getDownloadURL();
      } else {
        throw Exception('File upload failed');
      }
    } catch (e) {
      // Log and rethrow the error for debugging
      print('Error uploading profile image: $e');
      throw Exception('Error uploading profile image: $e');
    }
  }

  Future<void> updateUserEmail(String newEmail) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.verifyBeforeUpdateEmail(newEmail);
      await updateUserData({'email': newEmail});
    }
  }

  Future<void> updateUserPassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }

  Future<void> signOutUser() async {
    await _auth.signOut();
  }

}
