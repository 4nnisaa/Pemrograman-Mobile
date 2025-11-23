import 'package:flutter/material.dart';
import '../data/dummy_jadwal.dart';
import '../models/jadwal.dart';
import 'dosen_detail_page.dart';

class JadwalListPage extends StatelessWidget {
  const JadwalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Kuliah Ganjil 2025/2026'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarJadwal.length,
        itemBuilder: (context, index) {
          Jadwal data = daftarJadwal[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                data.dosen,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${data.mataKuliah}\n${data.jadwal}'),
              isThreeLine: true,
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DosenDetailPage(jadwal: data),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
