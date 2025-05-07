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
  late Stream<QuerySnapshot> liveDataStream = Stream.empty();
  String? cropName;
  bool loading = true;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    fetchCropName();
    fetchLiveDataStream();
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
        print("date today: $formattedDate");
      });
    } catch (e) {
      print('Error fetching crop name: $e');
    }
  }

  void fetchLiveDataStream() async {
    try {
      DocumentSnapshot cropDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('crops')
          .doc(widget.cropId)
          .get();

      String hardwareID = cropDoc['hardwareID'];

      setState(() {
        liveDataStream = FirebaseFirestore.instance
            .collection(hardwareID)
            .orderBy('createdAt', descending: true)
            .limit(1)
            .snapshots();
      });
    } catch (e) {
      print('Error setting up live data stream: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash_icon.png', height: 50),
            const SizedBox(width: 60),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.grey[200],
          padding: const EdgeInsets.all(5),
          child: StreamBuilder<QuerySnapshot>(
            stream: liveDataStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              var doc = snapshot.data!.docs.first;
              var liveData = doc.data() as Map<String, dynamic>;

              double soilMoisture1 = double.tryParse(liveData['soilMoisture1'].toString()) ?? 0.0;
              double soilMoisture2 = double.tryParse(liveData['soilMoisture2'].toString()) ?? 0.0;
              double soilMoisture3 = double.tryParse(liveData['soilMoisture3'].toString()) ?? 0.0;
              double soilAverage = (soilMoisture1 + soilMoisture2 + soilMoisture3) / 3;

              String temperature = liveData['temperature'].toString();
              String light = liveData['lightIntensity'].toString();
              String humidity = liveData['humidity'].toString();

              List<String> parts = doc.id.split('-');
              String extractedDate = "${parts[0]}-${parts[1]}-${parts[2]}";
              String extractedHour = parts[3];

              return Column(
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
                          extractedDate,
                          style: const TextStyle(
                            color: Color.fromRGBO(38, 50, 56, 1),
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          extractedHour,
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
                        value: soilAverage.toStringAsFixed(2),
                        loading: false,
                      ),
                      const SizedBox(width: 13),
                      FactorWidget(
                        title: 'Temperature',
                        icon: 'assets/images/Analysis-temp.png',
                        color: const Color.fromRGBO(224, 22, 22, 1),
                        value: temperature,
                        loading: false,
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
                        loading: false,
                      ),
                      const SizedBox(width: 13),
                      FactorWidget(
                        title: 'Humidity',
                        icon: 'assets/images/Analysis-humid.png',
                        color: const Color.fromRGBO(0, 105, 46, 1),
                        value: humidity,
                        loading: false,
                      ),
                    ],
                  ),
                ],
              );
            },
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
      color: Colors.grey[200],
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
                    fontWeight: FontWeight.w700,
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
