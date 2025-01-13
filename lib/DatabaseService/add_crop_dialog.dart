import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agripediav3/DatabaseService/add_crop_manual.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddCropDialog extends StatefulWidget {
  final String? initialHardwareID;
  const AddCropDialog({super.key, this.initialHardwareID});

  @override
  State<AddCropDialog> createState() => _AddCropDialogState();
}

class _AddCropDialogState extends State<AddCropDialog> {
  final TextEditingController cropNameController = TextEditingController();
  final TextEditingController hardwareIDController = TextEditingController();
  DateTime? plantingDate;
  String? selectedCropType;
  File? selectedImage;
  bool isLoading = false; // Flag to show loading indicator
  final ImagePicker _picker = ImagePicker();

  final List<String> cropTypes = ['Pepper', 'Tomato', 'Potato', 'Cucumber'];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> checkAndAutofillHardwareID(String hardwareID) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Query Firestore for the hardwareID within the 'crops' subcollection
      QuerySnapshot hardwareSnapshot = await FirebaseFirestore.instance
          .collectionGroup('crops') // Use collectionGroup to search within all 'crops' subcollections
          .where('hardwareID', isEqualTo: hardwareID)
          .get();

      print("Hardware snapshot count: ${hardwareSnapshot.docs.length}");
      hardwareSnapshot.docs.forEach((doc) {
        print("Hardware data: ${doc.data()}");
      });

      if (hardwareSnapshot.docs.isNotEmpty) {
        // Assume the first matching document
        Map<String, dynamic> cropData = hardwareSnapshot.docs.first.data() as Map<String, dynamic>;

        // Retrieve and validate the crop type
        String? autofilledCropType = cropData['cropType'] as String?;
        setState(() {
          // Update dropdown value only if it's valid
          if (autofilledCropType != null && cropTypes.contains(autofilledCropType)) {
            selectedCropType = autofilledCropType;
            print("Selected crop type: $selectedCropType");
          } else {
            selectedCropType = null;
          }
        });
      } else {
        print("no selected crop type");
        // Reset the crop type if no match is found
        setState(() {
          selectedCropType = null;
        });
      }
    } catch (e) {
      print('Error during hardwareID check: $e');
      // Optionally handle errors here, like showing a SnackBar
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Crop Manually',
        style: TextStyle(
          color: Colors.lightGreen[900]!,
          fontSize: 22,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            selectedImage != null
                ? Image.file(selectedImage!, height: 100)
                : TextButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image, color: Colors.lightGreen[900]),
              label: Text(
                'Select Image',
                style: TextStyle(color: Colors.lightGreen[900]),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: cropNameController,
              decoration: InputDecoration(
                labelText: 'Crop Name',
                labelStyle: TextStyle(
                  color: Colors.lightGreen[900]!,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightGreen[900]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightGreen[900]!,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedCropType,
              items: cropTypes
                  .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Select Crop Type',
                labelStyle: TextStyle(color: Colors.lightGreen[900]),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightGreen[900]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightGreen[900]!),
                ),
              ),
              onChanged: isLoading
                  ? null // Disable selection while loading
                  : (value) {
                setState(() {
                  selectedCropType = value;
                });
              },
            ),
            const SizedBox(height: 15),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: hardwareIDController,
                  decoration: InputDecoration(
                    labelText: 'Hardware ID',
                    labelStyle: TextStyle(
                      color: Colors.lightGreen[900]!,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.lightGreen[900]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.lightGreen[900]!,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    checkAndAutofillHardwareID(value);
                  },
                ),
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.lightGreen[900],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            ListTile(
              title: Text(
                plantingDate == null
                    ? "Select Planting Date"
                    : "Planting Date: ${plantingDate!.toLocal()}",
                style: TextStyle(
                  color: Colors.lightGreen[900]!,
                ),
              ),
              trailing: Icon(Icons.calendar_today, color: Colors.lightGreen[900]),
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.red[900],
            ),
          ),
        ),
        TextButton(
          onPressed: isLoading
              ? null // Disable confirm button while loading
              : () async {
            String cropName = cropNameController.text.trim();
            String hardwareID = hardwareIDController.text.trim();

            if (cropName.isNotEmpty &&
                plantingDate != null &&
                hardwareID.isNotEmpty &&
                selectedCropType != null) {
              try {
                await addCropToUser(
                  cropName,
                  plantingDate!,
                  hardwareID,
                  selectedCropType!,
                  selectedImage,
                );
                Navigator.pop(context);
              } catch (e) {
                // Catching the exception thrown when hardware ID is already linked
                if (e is Exception) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            } else {
              // Handle empty fields
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please fill all fields")),
              );
            }
          },
          child: Text(
            'Confirm',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

