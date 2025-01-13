import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String userId;
  String? userName;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      userId = currentUser.uid;
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(userId).get();
      setState(() {
        userName = userDoc['name'];
      });
    }
  }

  Future<void> _editUserName() async {
    TextEditingController controller =
    TextEditingController(text: userName ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  await _firestore
                      .collection('users')
                      .doc(userId)
                      .update({'name': newName});
                  setState(() {
                    userName = newName;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCrop(String cropId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('crops')
        .doc(cropId)
        .delete();
  }

  Future<void> _editCrop(String cropId, String currentName) async {
    TextEditingController controller =
    TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Crop Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new crop name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  await _firestore
                      .collection('users')
                      .doc(userId)
                      .collection('crops')
                      .doc(cropId)
                      .update({'cropName': newName});
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[100],
        title: Text(
          "Settings",
          style: TextStyle(
            color: Colors.lightGreen[900],
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: userName == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(3),
                  width: 324,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Username: $userName',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lightGreen[900]),
                      ),
                      IconButton(
                        icon: Icon(
                            Icons.edit,
                            color: Colors.lightGreen[900],
                        ),
                        iconSize: 20,
                        onPressed: _editUserName,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(userId)
                  .collection('crops')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        LottieBuilder.asset(
                          'assets/lottie/cattu.json',
                          height: 150,
                          width: 150,
                        ),
                        Text(
                          "No crops found, add a crop to view crop analysis!",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.lightGreen[900],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                List<QueryDocumentSnapshot> crops = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: crops.length,
                  itemBuilder: (context, index) {
                    var crop = crops[index];
                    String cropId = crop.id;
                    String cropName = crop['cropName'];

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(crop['imageUrl']),
                          ),
                          title: Text(cropName),
                          subtitle: Text(
                              'Hardware ID: ${crop['hardwareID']}',
                            style: TextStyle(
                              color: Colors.lightGreen[900],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.lightGreen[900]),
                                onPressed: () =>
                                    _editCrop(cropId, cropName),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  bool confirm = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Crop'),
                                      content: Text(
                                          'Are you sure you want to delete this crop?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm) {
                                    _deleteCrop(cropId);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
