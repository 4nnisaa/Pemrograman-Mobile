import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final nimController = TextEditingController();
  final kelasController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      nameController.text = data['name'] ?? '';
      nimController.text = data['nim'] ?? '';
      kelasController.text = data['kelas'] ?? '';
    }
  }

  Future<void> saveProfile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .set({
      'email': user!.email,
      'name': nameController.text,
      'nim': nimController.text,
      'kelas': kelasController.text,
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            TextField(
              controller: nimController,
              decoration: const InputDecoration(labelText: 'NIM'),
            ),
            TextField(
              controller: kelasController,
              decoration: const InputDecoration(labelText: 'Kelas'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: saveProfile,
              child: const Text('Simpan Profil'),
            ),
          ],
        ),
      ),
    );
  }
}
