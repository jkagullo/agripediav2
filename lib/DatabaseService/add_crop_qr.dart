import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AddCropQR extends StatefulWidget {
  const AddCropQR({Key? key}) : super(key: key);

  @override
  State<AddCropQR> createState() => _AddCropQRState();
}

class _AddCropQRState extends State<AddCropQR> {
  String? scannedHardwareID;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController cropNameController = TextEditingController();
  final TextEditingController plantingDateController = TextEditingController();
  DateTime? plantingDate;

  void _onQRViewCreated(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final scannedValue = barcodes.first.rawValue;
      if (scannedValue != null) {
        setState(() {
          scannedHardwareID = scannedValue;
        });
        Navigator.of(context).pop(); // Close scanner screen
        _showCropDialog(); // Show crop details dialog
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showCropDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Crop Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              selectedImage != null
                  ? Image.file(selectedImage!, height: 100)
                  : TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Select Image'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: cropNameController,
                decoration: const InputDecoration(labelText: "Crop Name"),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text(plantingDate == null
                    ? "Select Planting Date"
                    : "Planting Date: ${plantingDate!.toLocal()}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      plantingDate = selectedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 15),
              Text("Hardware ID: $scannedHardwareID"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveCrop();
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCrop() async {
    if (scannedHardwareID == null ||
        cropNameController.text.isEmpty ||
        plantingDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('crop_images/${user.uid}/${cropNameController.text}_${DateTime.now().millisecondsSinceEpoch}.jpg');

      String? imageUrl;
      if (selectedImage != null) {
        await storageRef.putFile(selectedImage!);
        imageUrl = await storageRef.getDownloadURL();
      }

      final cropDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('crops')
          .doc();

      await cropDoc.set({
        'cropName': cropNameController.text,
        'plantingDate': plantingDate!.toIso8601String(),
        'hardwareID': scannedHardwareID,
        'imageUrl': imageUrl ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Crop added successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding crop: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: MobileScanner(onDetect: _onQRViewCreated),
    );
  }
}
