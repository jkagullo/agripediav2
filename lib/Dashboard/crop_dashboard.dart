import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CropDashboard extends StatefulWidget {
  final String cropId;

  const CropDashboard({Key? key, required this.cropId}) : super(key: key);

  @override
  _CropDashboardState createState() => _CropDashboardState();
}

class _CropDashboardState extends State<CropDashboard> {
  late Stream<QuerySnapshot> liveDataStream;
  String? cropName;
  bool loading = true;
  String soil = '';
  String temperature = '';
  String light = '';
  String humidity = '';
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    fetchCropName();
    liveDataStream = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('crops')
        .doc(widget.cropId)
        .collection('liveData')
        .limit(1)
        .snapshots();

    // Listen for updates to live data
    liveDataStream.listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
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

  Future<void> fetchCropName() async {
    try {
      DocumentSnapshot cropDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('crops')
          .doc(widget.cropId)
          .get();

      setState(() {
        cropName = cropDoc['cropName'];
        loading = false;
      });
    } catch (e) {
      print('Error fetching crop name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[50],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash_icon.png', height: 50),
            SizedBox(width: 60),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.lightGreen[50],
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Container(
                alignment: const Alignment(-0.8, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        color: Color.fromRGBO(38, 50, 56, 1),
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      cropName ?? 'Loading...',
                      style: const TextStyle(
                        color: Color.fromRGBO(38, 50, 56, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Color.fromRGBO(38, 50, 56, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FactorWidget(
                    title: 'Water',
                    icon: 'assets/images/Analysis-water.png',
                    color: const Color.fromRGBO(30, 136, 229, 1),
                    value: soil,
                    loading: loading,
                  ),
                  const SizedBox(width: 13),
                  FactorWidget(
                    title: 'Temperature',
                    icon: 'assets/images/Analysis-temp.png',
                    color: const Color.fromRGBO(224, 22, 22, 1),
                    value: temperature,
                    loading: loading,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FactorWidget(
                    title: 'Light',
                    icon: 'assets/images/Analysis-sun.png',
                    color: const Color.fromRGBO(253, 192, 55, 1),
                    value: light,
                    loading: loading,
                  ),
                  const SizedBox(width: 13),
                  FactorWidget(
                    title: 'Humidity',
                    icon: 'assets/images/Analysis-humid.png',
                    color: const Color.fromRGBO(0, 105, 46, 1),
                    value: humidity,
                    loading: loading,
                  ),
                ],
              ),
              const SizedBox(height: 13),
            ],
          ),
        ),
      ),
    );
  }

  Widget FactorWidget({
    required String title,
    required String icon,
    required Color color,
    required String value,
    required bool loading,
  }) {
    return Container(
      height: 185,
      width: 165,
      color: const Color.fromRGBO(246, 245, 245, 1),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 165,
              width: 165,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: color.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                child: Image.asset(
                  icon,
                  height: 50,
                  width: 44,
                ),
              ),
            ),
          ),
          Positioned(
            top: 80,
            right: 0,
            left: 0,
            child: Column(
              children: [
                if (loading)
                  const Center(child: CircularProgressIndicator())
                else
                  Text(
                    value.isNotEmpty ? value : 'No data',
                    style: TextStyle(
                      fontSize: value.isNotEmpty ? 35 : 13,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                      color: const Color.fromRGBO(38, 50, 56, 1),
                    ),
                  ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    color: Color.fromRGBO(38, 50, 56, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
