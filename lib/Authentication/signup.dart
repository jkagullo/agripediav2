import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // signup function
  Future<String?> signUpUser({required String name, required String email, required String password}) async {
    try {
      // create a new user with Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // create a new user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
        });

        return null;
      }else{
        return 'User registration failed.';
      }
    }on FirebaseAuthException catch (e){
      // handle firebase authentication errors
      if (e.code == 'email-already-in-use'){
        return 'This email is already in use.';
      }else if (e.code == 'weak-password'){
        return 'The password is too weak.';
      }else{
        return e.message ?? 'An error occurred.';
      }
    }catch (e){
      return 'An unknown error occurred.';
    }
  }
}