import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final currentUser = FirebaseAuth.instance.currentUser!.email;

  Future<Map<String, dynamic>?> getProfile() async {
    final docRef =
        FirebaseFirestore.instance.collection("profile").doc(currentUser);
    final snapshot = await docRef.get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          height: 10,
        ),
        Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(
          height: 10,
        ),
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('images/profile_icon.png'),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'FirstName LastName',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ]),
    );
  }
}
