import 'package:agripediav3/Authentication/login_screen.dart';
import 'package:agripediav3/Components/my_button.dart';
import 'package:agripediav3/Components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:agripediav3/Authentication/signup.dart';
import 'package:image_picker/image_picker.dart'; // import image picker
import 'package:firebase_storage/firebase_storage.dart'; // import firebase storage
import 'dart:io'; // import file handling

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final SignUpService _signUpService = SignUpService();

  bool isLoading = false;
  File? _imageFile; // variable to hold
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // method to upload the imamge to Firebase Storage
  Future<String?> _uploadImage() async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  //method to handle signup
  void signUserUp() async {
    setState((){
      isLoading = true;
    });

    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(username.isNotEmpty && email.isNotEmpty && password.isNotEmpty){
      String? imageUrl = await _uploadImage(); // upload image to firebase storage
      String? errorMessage = await _signUpService.signUpUser(
        name: username,
        email: email,
        password: password,
        imageUrl: imageUrl,
      );

      if (errorMessage == null) {
        //navigate to login screen after successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }else{
        // show error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Ok"),
              ),
            ],
          ),
        );
      }
    }else{
      // show validation error if fields are empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("error"),
          content: Text("All fields are required"),
          actions:[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Ok"),
            ),
          ],
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Sign Up to Agripedia",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Your first step to home farming!",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : AssetImage('assets/images/default_profile.jpg'),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 60,
                      child: IconButton(
                          onPressed: () {
                            _pickImage();
                          },
                          icon: Icon(
                            Icons.add_a_photo,
                          ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: usernameController,
                  hintText: "Username",
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                isLoading
                    ? CircularProgressIndicator()
                    : MyButton(
                  onTap: signUserUp,
                  text: "Sign Up",
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0); // Slide from right to left
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
