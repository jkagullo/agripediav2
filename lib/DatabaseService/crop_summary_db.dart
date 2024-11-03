import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<Map<String, dynamic>>> fetchCropSummaries() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    print("no user is logged in");
    return [];
  }

  List<Map<String, dynamic>> crops = [];
  try {
    CollectionReference cropsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('crops');

    QuerySnapshot snapshot = await cropsCollection.get();
    for (var doc in snapshot.docs){
      crops.add(doc.data() as Map<String, dynamic>);
    }
  }catch (e) {
    print("Error fetching crops");
  }
  return crops;
}