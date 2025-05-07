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
  String? selectedCropType;

  final List<String> cropTypes = ['Pepper', 'Tomato', 'Potato', 'Cucumber'];

  @override
  void dispose() {
    cropNameController.dispose();
    super.dispose();
  }

  Future<void> _onQRViewCreated(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final scannedValue = barcodes.first.rawValue;
      if (scannedValue != null && mounted) {
        setState(() {
          scannedHardwareID = scannedValue;
        });

        // Check if hardwareID already exists for the current user
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        try {
          // Check current user's crops
          final userCropsSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('crops')
              .where('hardwareID', isEqualTo: scannedHardwareID)
              .get();

          if (userCropsSnapshot.docs.isNotEmpty) {
            // HardwareID already exists for this user
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("This hardware ID is already associated with your crops.")),
            );
            return;
          }

          // Check if hardwareID exists for other users
          final hardwareSnapshot = await FirebaseFirestore.instance
              .collectionGroup('crops')
              .where('hardwareID', isEqualTo: scannedHardwareID)
              .get();

          if (hardwareSnapshot.docs.isNotEmpty) {
            // Autofill crop type from another user's data
            final cropData = hardwareSnapshot.docs.first.data();
            setState(() {
              selectedCropType = cropData['cropType'] as String?;
            });
          } else {
            // No matching hardwareID found, let user select crop type
            setState(() {
              selectedCropType = null;
            });
          }

          await Future.delayed(Duration(milliseconds: 100)); // Ensure navigation timing
          // Show the add crop dialog
          if (mounted) {
            Future.delayed(Duration(milliseconds: 100), () => _showCropDialog());
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error fetching data: $e")),
          );
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

  Future<void> _showCropDialog() {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            bool isLoading = false;

            Future<void> _saveCrop() async {
              if (scannedHardwareID == null ||
                  cropNameController.text.isEmpty ||
                  plantingDate == null ||
                  selectedCropType == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all fields")),
                );
                return;
              }

              setDialogState(() {
                isLoading = true;
              });

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

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('crops')
                    .doc()
                    .set({
                  'cropName': cropNameController.text,
                  'plantingDate': plantingDate,
                  'hardwareID': scannedHardwareID,
                  'cropType': selectedCropType,
                  'imageUrl': imageUrl ?? '',
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Crop added successfully")),
                );

                // Dispose the Scan QR page correctly
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop(); // Close the dialog
                }
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop(); // Close the AddCropQR screen
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error adding crop: $e")),
                );
              } finally {
                setDialogState(() {
                  isLoading = false;
                });
              }
            }

            return AlertDialog(
              title: Text('Add Crop', style: TextStyle(color: Colors.lightGreen[900], fontSize: 22)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    selectedImage != null
                        ? Image.file(selectedImage!, height: 100)
                        : TextButton.icon(
                      onPressed: isLoading
                          ? null
                          : () async {
                        await _pickImage();
                        setDialogState(() {});
                      },
                      icon: const Icon(Icons.image),
                      label: Text('Select Image', style: TextStyle(color: Colors.lightGreen[900])),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: cropNameController,
                      decoration: InputDecoration(
                        labelText: "Crop Name",
                        labelStyle: TextStyle(color: Colors.lightGreen[900]),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightGreen[900]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightGreen[900]!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedCropType,
                      items: cropTypes
                          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      decoration: InputDecoration(
                        labelText: 'Select Crop Type',
                        labelStyle: TextStyle(color: Colors.lightGreen[900]),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightGreen[900]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightGreen[900]!),
                        ),
                      ),
                      onChanged: isLoading
                          ? null
                          : (value) {
                        setDialogState(() {
                          selectedCropType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    ListTile(
                      title: Text(
                          plantingDate == null ? "Select Planting Date" : "Planting Date: ${plantingDate!.toLocal()}"),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: isLoading
                          ? null
                          : () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          setDialogState(() {
                            plantingDate = selectedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    Text("Hardware ID: $scannedHardwareID"),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : _saveCrop,
                  child: isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveCrop() async {
    if (scannedHardwareID == null ||
        cropNameController.text.isEmpty ||
        plantingDate == null ||
        selectedCropType == null) {
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

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('crops')
          .doc()
          .set({
        'cropName': cropNameController.text,
        'plantingDate': plantingDate,
        'hardwareID': scannedHardwareID,
        'cropType': selectedCropType,
        'imageUrl': imageUrl ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Crop added successfully")),
      );

      // Ensure proper navigation
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Close the dialog
      }
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Close the AddCropQR screen
      }
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
