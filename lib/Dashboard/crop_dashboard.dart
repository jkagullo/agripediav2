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
  late Stream<DocumentSnapshot> liveDataStream = Stream.empty(); // Initialize with an empty stream
  String? cropName;
  bool loading = true;
  String soil1 = '';
  String soil2 = '';
  String soil3 = '';
  String soilFinal = '';
  String temperature = '';
  String light = '';
  String humidity = '';
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String date = '';
  String hour = '';
  String hId = '';

  @override
  void initState() {
    super.initState();
    fetchCropName();
    fetchLiveData();
  }

  // comment to push
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

  void fetchLiveData() async {
    try {
      // Fetch the hardwareID from the user's crops collection
      DocumentSnapshot cropDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('crops')
          .doc(widget.cropId)
          .get();

      String hardwareID = cropDoc['hardwareID']; // Get the hardwareID
      hId = hardwareID;

      // Query to get the latest document from the hardware collection
      QuerySnapshot dateSnapshot = await FirebaseFirestore.instance
          .collection(hardwareID)
          .orderBy('createdAt', descending: true) // Order by createdAt in descending order
          .limit(1) // Get only the latest document
          .get();

      if (dateSnapshot.docs.isEmpty) {
        print('No live data found');
        return;
      }

      // Get the latest document
      DocumentSnapshot latestDateDoc = dateSnapshot.docs.first;

      // Extract the document ID (e.g., "2025-01-06-01:03")
      String documentID = latestDateDoc.id;

      // Split the document ID to extract date and hour
      List<String> parts = documentID.split('-');
      String extractedDate = "${parts[0]}-${parts[1]}-${parts[2]}"; // "2025-01-06"
      String extractedHour = parts[3]; // "01:03"

      // Extract live data from the document
      Map<String, dynamic> liveData = latestDateDoc.data() as Map<String, dynamic>;
      double soilMoisture1 = double.tryParse(liveData['soilMoisture1'].toString()) ?? 0.0;
      double soilMoisture2 = double.tryParse(liveData['soilMoisture2'].toString()) ?? 0.0;
      double soilMoisture3 = double.tryParse(liveData['soilMoisture3'].toString()) ?? 0.0;

      double soilAverage = (soilMoisture1 + soilMoisture2 + soilMoisture3) / 3;

      // Update the state with the fetched data
      setState(() {
        date = extractedDate; // Update date
        hour = extractedHour; // Update hour
        soil1 = soilMoisture1.toStringAsFixed(2);
        soil2 = soilMoisture2.toStringAsFixed(2);
        soil3 = soilMoisture3.toStringAsFixed(2);
        soilFinal = soilAverage.toStringAsFixed(2);
        temperature = liveData['temperature'].toString();
        light = liveData['lightIntensity'].toString();
        humidity = liveData['humidity'].toString();
      });

      print('Date: $date');
      print('Hour: $hour');
      print('Soil: $soilFinal');
      print('Temperature: $temperature');
      print('Light: $light');
      print('Humidity: $humidity');
    } catch (e) {
      print('Error fetching live data: $e');
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
            SizedBox(width: 60),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.grey[200],
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
                      date.isNotEmpty ? date : 'Loading...',
                      style: const TextStyle(
                        color: Color.fromRGBO(38, 50, 56, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      hour.isNotEmpty ? hour : 'Loading...',
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
                    value: soilFinal,
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
