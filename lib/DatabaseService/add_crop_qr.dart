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
  DateTime? plantingDate;

  @override
  void dispose() {
    cropNameController.dispose();
    super.dispose();
  }

  void _onQRViewCreated(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final scannedValue = barcodes.first.rawValue;
      if (scannedValue != null && mounted) {
        setState(() {
          scannedHardwareID = scannedValue;
        });
        await Future.delayed(Duration(milliseconds: 100)); // Ensure navigation timing
        if (mounted) {
          _showCropDialog();
        }
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showCropDialog() {
    if (!mounted) return; // Ensure the widget is still active
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Add Crop Details"),
          content: StatefulBuilder(
            builder: (dialogContext, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  selectedImage != null
                      ? Image.file(selectedImage!, height: 100)
                      : TextButton.icon(
                    onPressed: () async {
                      await _pickImage();
                      if (mounted) setDialogState(() {});
                    },
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
                      if (selectedDate != null && mounted) {
                        setState(() {
                          plantingDate = selectedDate;
                        });
                        setDialogState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  Text("Hardware ID: $scannedHardwareID"),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveCrop();
                if (mounted) Navigator.of(dialogContext).pop();
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

      String? imageUrl;
      if (selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('crop_images/${user.uid}/${cropNameController.text}_${DateTime.now().millisecondsSinceEpoch}.jpg');
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
