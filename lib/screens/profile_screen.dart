import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fmobile/models/text_box.dart';
import 'package:flutter/material.dart';
import 'package:fmobile/screens/mydrawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _EditProfileScreenState();
}
class _EditProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Edit $field',
          style: TextStyle(color: Colors.grey[700]),
        ),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter Your new $field",
            hintStyle: TextStyle(color: Colors.grey[700]),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (newValue.trim().length > 0) {
                await usersCollection.doc(user.email).update({field: newValue});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$field updated successfully')),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: MyDrawer(),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(user.email)
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                              child: Icon(
                                Icons.person,
                                size: 30,
                              ),
                              maxRadius: 30),
                          Text(
                            user.email!,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 126, 87, 194),
                                fontSize: 22),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextBox(
                        sectionName: 'First name',
                        text: userData['first name'] ?? '',
                        onPressed: () => editField('first name'),
                      ),
                      TextBox(
                        sectionName: 'Last name',
                        text: userData['last name'],
                        onPressed: () => editField('last name'),
                      ),
                      TextBox(
                        sectionName: 'Phone number',
                        text: userData['phone number'],
                        onPressed: () => editField('phone number'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error' + snapshot.error.toString()),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
        ));
  }
}
