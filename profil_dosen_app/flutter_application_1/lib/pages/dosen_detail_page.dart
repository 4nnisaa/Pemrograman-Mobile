import 'package:flutter/material.dart';
import '../models/jadwal.dart';

class DosenDetailPage extends StatelessWidget {
  final Jadwal jadwal;

  const DosenDetailPage({super.key, required this.jadwal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🌈 Latar belakang gradasi warna
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2DFDB), Color(0xFFE0F2F1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔙 Tombol kembali di atas
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.teal,
                      size: 26,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(height: 10),

                // 🧑 Avatar dosen dengan efek shadow
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, size: 70, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 20),

                // 🏷 Nama Dosen
                Text(
                  jadwal.dosen,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),
                Text(
                  'NIP: ${jadwal.nip}',
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),

                const SizedBox(height: 25),
                const Divider(color: Colors.teal, thickness: 1.2),

                // 📘 Informasi Dosen
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        InfoTile(
                          icon: Icons.book,
                          title: 'Mata Kuliah',
                          value: jadwal.mataKuliah,
                        ),
                        InfoTile(
                          icon: Icons.class_,
                          title: 'Kelas',
                          value: jadwal.kelas,
                        ),
                        InfoTile(
                          icon: Icons.access_time,
                          title: 'Jadwal',
                          value: jadwal.jadwal,
                        ),
                        InfoTile(
                          icon: Icons.meeting_room,
                          title: 'Ruang',
                          value: jadwal.ruang,
                        ),
                        InfoTile(
                          icon: Icons.people,
                          title: 'Peserta',
                          value: '${jadwal.peserta} mahasiswa',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 🔘 Tombol kembali di bawah
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text(
                    'Kembali ke Daftar Dosen',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🔹 Widget kecil untuk baris informasi dosen
class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal, size: 28),
      title: Text(
        '$title:',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(value),
    );
  }
}
