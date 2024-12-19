import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<Map<String, dynamic>>> fetchCropForTask() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    print("No user is logged in");
    return [];
  }

  List<Map<String, dynamic>> crops = [];
  try {
    CollectionReference cropsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('crops');

    QuerySnapshot snapshot = await cropsCollection.get();
    for (var doc in snapshot.docs) {
      Map<String, dynamic> cropData = doc.data() as Map<String, dynamic>;
      cropData['cropID'] = doc.id;
      crops.add(cropData);
    }
  } catch(e) {
    print("Error fetching crop for dashboard");
  }
  return crops;
}