import 'package:flutter/material.dart';
import 'package:agripediav3/DatabaseService/add_crop_manual.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddCropDialog extends StatefulWidget {
  const AddCropDialog({super.key});

  @override
  State<AddCropDialog> createState() => _AddCropDialogState();
}

class _AddCropDialogState extends State<AddCropDialog> {
  final TextEditingController cropNameController = TextEditingController();
  final TextEditingController hardwareIDController = TextEditingController();
  DateTime? plantingDate;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
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
      content: Column(
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
          ),
          const SizedBox(height: 15),
          ListTile(
            title: Text(plantingDate == null
                ? "Select Planting Date"
                : "Planting Date: ${plantingDate!.toLocal()}",
              style: TextStyle(
                color: Colors.lightGreen[900]!,
              ),
            ),
            trailing: Icon(Icons.calendar_today, color: Colors.lightGreen[900],),
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
          onPressed: () async {
            String cropName = cropNameController.text.trim();
            String hardwareID = hardwareIDController.text.trim();
            if (cropName.isNotEmpty && plantingDate != null && hardwareID.isNotEmpty) {
              await addCropToUser(cropName, plantingDate!, hardwareID, selectedImage);
              Navigator.pop(context);
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
