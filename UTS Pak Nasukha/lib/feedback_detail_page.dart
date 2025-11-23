import 'package:flutter/material.dart';
import 'model/feedback_item.dart';

class FeedbackDetailPage extends StatelessWidget {
  final FeedbackItem item;
  final VoidCallback onDelete;

  const FeedbackDetailPage({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Feedback'),
        backgroundColor: Colors.purpleAccent.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama: ${item.nama}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('NIM: ${item.nim}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 6),
                Text('Fakultas: ${item.fakultas}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 6),
                Text('Fasilitas: ${item.fasilitas.join(', ')}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 6),
                Text('Nilai Kepuasan: ${item.nilaiKepuasan.round()}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 6),
                Text('Jenis Feedback: ${item.jenisFeedback}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 6),
                Text('Pesan Tambahan: ${item.pesanTambahan}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 6),
                Text('Setuju Syarat: ${item.setuju ? "Ya" : "Tidak"}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent.shade100),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Kembali'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Hapus Feedback'),
                            content: const Text('Apakah Anda yakin ingin menghapus feedback ini?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  onDelete();
                                  Navigator.pop(context);
                                },
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}