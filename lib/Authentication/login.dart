import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sigin in function
  Future<String?> signInUser({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // after signing in, check if the user exists in the firestore
      User? user = userCredential.user;
      if (user != null) {
        //get user document in firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists){
          return null; // login successful
        }else{
          return 'User does not exist';
        }
      }else {
        return 'Authentication failed';
      }

    } on FirebaseAuthException catch (e){
      // return the error message to be displayed
      if (e.code == 'user-not-found'){
        return 'No user found for that email,';
      } else if (e.code == 'wrong-password'){
        return 'Wrong password provided.';
      } else{
        return e.message ?? 'An error occurred.';
      }
    }
  }
}

