import 'package:flutter/material.dart';
import '../models/jadwal.dart';

class DosenDetailPage extends StatelessWidget {
  final Jadwal jadwal;

  const DosenDetailPage({super.key, required this.jadwal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🌸 Latar belakang gradasi ungu lembut
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD9C3FF), Color(0xFFF1E6FF)], // ungu pastel → lavender
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
                // 🔙 Tombol kembali di pojok atas
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF7B1FA2), size: 26),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(height: 10),

                // 🧑 Avatar dosen dengan efek bayangan
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurpleAccent.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 70,
                    backgroundColor: Color(0xFF7B1FA2),
                    child: Icon(Icons.person, size: 70, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 20),

                // 🏷 Nama Dosen
                Text(
                  jadwal.dosen,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2),
                    letterSpacing: 0.8,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 6),
                Text(
                  'NIP: ${jadwal.nip}',
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),

                const SizedBox(height: 25),
                const Divider(color: Color(0xFF7B1FA2), thickness: 1.2),

                // 📘 Informasi lengkap dengan card modern
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        InfoTile(icon: Icons.book, title: 'Mata Kuliah', value: jadwal.mataKuliah),
                        InfoTile(icon: Icons.class_, title: 'Kelas', value: jadwal.kelas),
                        InfoTile(icon: Icons.access_time, title: 'Jadwal', value: jadwal.jadwal),
                        InfoTile(icon: Icons.meeting_room, title: 'Ruang', value: jadwal.ruang),
                        InfoTile(
                            icon: Icons.people,
                            title: 'Peserta',
                            value: '${jadwal.peserta} mahasiswa'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 🌷 Tombol kembali ke daftar
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B1FA2),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                    shadowColor: Colors.deepPurpleAccent,
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

// 🌼 Widget untuk menampilkan info
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
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF7B1FA2), size: 26),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5E35B1)),
      ),
      subtitle: Text(value, style: const TextStyle(color: Colors.black87)),
    );
  }
}
