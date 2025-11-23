import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Aplikasi'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image.asset(
              'assets/uin_sts_logo.png',
              height: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              'Aplikasi Campus Feedback ini dikembangkan untuk membantu kampus '
              'mengumpulkan pendapat dan masukan dari mahasiswa secara mudah, '
              'interaktif, dan terstruktur.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.purpleAccent.shade100),
                title: const Text('Dosen Pengampu'),
                subtitle: const Text('Nama Dosen - Mata Kuliah'),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.school, color: Colors.purpleAccent.shade100),
                title: const Text('Pengembang'),
                subtitle: const Text('Nama Mahasiswa - NIM'),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.purpleAccent.shade100),
                title: const Text('Tahun Akademik'),
                subtitle: const Text('2025/2026'),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent.shade100,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali ke Beranda'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}