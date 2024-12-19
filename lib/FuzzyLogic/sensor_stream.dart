import 'package:agripediav3/FuzzyLogic/fuzzy_db.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SensorStream extends StatefulWidget {
  final String cropId;
  const SensorStream({super.key, required this.cropId});

  @override
  State<SensorStream> createState() => _SensorStreamState();
}

class _SensorStreamState extends State<SensorStream> {
  late Stream<QuerySnapshot> liveDataStream;

  String? cropName;
  String soil = '';
  String temperature = '';
  String light = '';
  String humidity = '';

  @override
  void initState(){
    super.initState();
    liveDataStream = FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('crops')
    .doc(widget.cropId)
    .collection('liveData')
    .limit(1)
    .snapshots();

    liveDataStream.listen((snapshot){
      if (snapshot.docs.isNotEmpty){
        final latestData = snapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          soil = latestData['soil'].toString();
          temperature = latestData['temperature'].toString();
          light = latestData['light'].toString();
          humidity = latestData['humidity'].toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
