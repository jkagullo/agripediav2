import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

class DetectionScreen extends StatefulWidget {
  final File imageFile;
  final String hardwareID;

  const DetectionScreen({required this.imageFile, required this.hardwareID});

  @override
  _DetectionPageState createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionScreen> {
  late Interpreter _interpreter;
  String? _detectionResult;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _performDetection();
  }

  final Map<String, String> diseaseRecommendations = {
    'bacterial_spot': 'Use copper-based fungicides and avoid overhead irrigation.',
    'early_blight': 'Apply fungicides and practice crop rotation.',
    'late_blight': 'Remove infected plants and use resistant varieties.',
    'leaf_Mold': 'Ensure proper ventilation and reduce humidity.',
    'septoria_leaf_spot': 'Use fungicides and remove infected leaves.',
    'spider_mites': 'Spray with insecticidal soap or neem oil.',
    'target_Spot': 'Apply fungicides and avoid water stress.',
    'yellow_Leaf_Curl_Virus': 'Control whiteflies and use resistant varieties.',
    'mosaic_virus': 'Remove infected plants and control aphids.',
    'healthy': 'No action needed. Keep monitoring your crop.',
  };

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/october24.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<List<List<List<double>>>> _preprocessImage(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes)!;
    final resizedImage = img.copyResize(image, width: 256, height: 256);

    return List.generate(
      256,
          (y) => List.generate(
        256,
            (x) {
          final pixel = resizedImage.getPixel(x, y);
          return [
            pixel.r / 255.0, // Get red component
            pixel.g / 255.0, // Get green component
            pixel.b / 255.0, // Get blue component
          ];
        },
      ),
    );
  }


  Future<void> _performDetection() async {
    try {
      final input = await _preprocessImage(widget.imageFile);
      final output = List.filled(1, List.filled(10, 0.0));

      _interpreter.run([input], output);

      final probabilities = output[0];
      final labelIndex = probabilities.indexOf(probabilities.reduce((a, b) => a > b ? a : b));
      final labels = await _loadLabels();
      setState(() {
        _detectionResult = labels[labelIndex];
      });

      await _uploadDetectionResult(widget.imageFile, labels[labelIndex]);
    } catch (e) {
      print('Detection error: $e');
      setState(() {
        _detectionResult = 'Error detecting disease';
      });
    }
  }

  Future<List<String>> _loadLabels() async {
    final labelsData = await rootBundle.loadString('assets/disease_labels.txt');
    return labelsData.split('\n');
  }


  Future<void> _uploadDetectionResult(File imageFile, String result) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final uuid = Uuid().v4();
      final imageRef = storageRef.child('detection/${widget.hardwareID}/$uuid.jpg');

      await imageRef.putFile(imageFile);
      final imageUrl = await imageRef.getDownloadURL();

      setState(() {
        _uploadedImageUrl = imageUrl;
      });

      final firestore = FirebaseFirestore.instance;
      final timestamp = DateTime.now();
      final date = DateFormat('yyyy-MM-dd').format(timestamp);
      final time = DateFormat('HH:mm').format(timestamp);

      // Initialize hardware document if it doesn't exist
      final hardwareDocRef = firestore.collection('Detection').doc(widget.hardwareID);
      final hardwareSnapshot = await hardwareDocRef.get();
      if (!hardwareSnapshot.exists) {
        await hardwareDocRef.set({'initialized': true});
      }

      // Initialize date document if it doesn't exist
      final dateDocRef = hardwareDocRef.collection('dates').doc(date);
      final dateSnapshot = await dateDocRef.get();
      if (!dateSnapshot.exists) {
        await dateDocRef.set({'initialized': true});
      }

      final normalizedResult = result.trim().toLowerCase();
      print("normalized result: $normalizedResult");
      final recommendation = diseaseRecommendations[normalizedResult] ?? 'No recommendation available.';

      // Upload detection result
      final hourDocRef = dateDocRef.collection('hours').doc(time);
      await hourDocRef.set({
        'image': imageUrl,
        'result': result,
        'recommendation': recommendation,
        'createdAt': timestamp,
      });

      print('Detection result uploaded successfully.');
    } catch (e) {
      print('Error uploading detection result: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Disease Detection')),
      body: Center(
        child: _detectionResult == null
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_uploadedImageUrl != null)
              Image.network(_uploadedImageUrl!),
            Text('Detection Result: $_detectionResult'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
