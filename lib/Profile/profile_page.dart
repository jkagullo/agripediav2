import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:agripediav3/Authentication/login_screen.dart';
import 'package:agripediav3/Profile/profile_page_update.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _username;
  String? _email;
  String? _profileImageUrl;
  final ProfilePageUpdate _profileService = ProfilePageUpdate();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _profileService.getUserData();
    setState(() {
      _username = userData['username']; // From 'name' in Firestore
      _email = userData['email']; // FirebaseAuth email
      _profileImageUrl = userData['imageUrl']; // From 'imageUrl'
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfileImage() async {
    if (_imageFile != null) {
      final uploadedUrl = await _profileService.uploadProfileImage(_imageFile!);
      await _profileService.updateUserData({'imageUrl': uploadedUrl}); // Use 'imageUrl'
      setState(() {
        _profileImageUrl = uploadedUrl;
      });
    }
  }

  Future<void> _showEditDialog(String title, String currentValue, Function(String) onSave) async {
    TextEditingController controller = TextEditingController(text: currentValue);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUsername(String newUsername) async {
    await _profileService.updateUserData({'username': newUsername});
    await _loadUserData();
  }

  Future<void> _updateEmail(String newEmail) async {
    await _profileService.updateUserEmail(newEmail);
    await _loadUserData();
  }

  Future<void> _updatePassword(String newPassword) async {
    await _profileService.updateUserPassword(newPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[50],
        title: Text(
          'Profile Settings',
          style: TextStyle(
            color: Colors.lightGreen[900],
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 10),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!) // Display the picked image if available
                        : (_profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!) // Display the profile image from Firestore
                        : AssetImage('assets/images/default_profile.jpg')) as ImageProvider,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 60,
                    child: IconButton(
                      onPressed: _pickImage,
                      icon: Icon(Icons.add_a_photo, color: Colors.lightGreen[800]),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Change Profile Picture', style: TextStyle(color: Colors.lightGreen[900], fontSize: 20)),
                IconButton(
                  onPressed: _saveProfileImage,
                  icon: Icon(Icons.save, color: Colors.lightGreen[800]),
                ),
              ],
            ),
            Divider(color: Colors.grey, thickness: 1.0),
            _buildEditableRow('Username', _username ?? '', _updateUsername),
            _buildEditableRow('Email', _email ?? '', _updateEmail),
            _buildEditableRow('Password', '*******', _updatePassword),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await _profileService.signOutUser();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 35.0),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[800],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'Logout',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableRow(String label, String value, Function(String) onSave) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: TextStyle(color: Colors.lightGreen[900], fontSize: 20, fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: () => _showEditDialog(label, value, onSave),
            icon: Icon(Icons.settings, color: Colors.lightGreen[800]),
          ),
        ],
      ),
    );
  }
}
