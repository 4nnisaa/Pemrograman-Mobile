import 'package:flutter/material.dart';
import 'feedback_list_page.dart';
import 'model/feedback_item.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _pesanController = TextEditingController();

  String? _fakultas;
  List<String> fasilitas = ['Perpustakaan', 'Kantin', 'Kelas', 'Laboratorium'];
  List<String> fasilitasDipilih = [];
  double _nilaiKepuasan = 3;
  String _jenisFeedback = 'Saran';
  bool _setuju = false;

  void _simpanFeedback() {
    if (!_formKey.currentState!.validate()) return;

    if (!_setuju) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Persetujuan Diperlukan'),
          content: const Text('Aktifkan tombol persetujuan sebelum mengirim feedback.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    final feedback = FeedbackItem(
      nama: _namaController.text,
      nim: _nimController.text,
      fakultas: _fakultas!,
      fasilitas: fasilitasDipilih,
      nilaiKepuasan: _nilaiKepuasan,
      jenisFeedback: _jenisFeedback,
      pesanTambahan: _pesanController.text,
      setuju: _setuju,
    );

    Navigator.pop(context, feedback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Feedback Mahasiswa'), backgroundColor: Colors.purpleAccent.shade100),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Mahasiswa'),
                validator: (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nimController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'NIM'),
                validator: (value) {
                  if (value!.isEmpty) return 'NIM wajib diisi';
                  if (int.tryParse(value) == null) return 'NIM harus angka';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _fakultas,
                decoration: const InputDecoration(labelText: 'Fakultas'),
                items: [
                  'Ekonomi dan Bisnis Islam',
                  'Sains dan Teknologi',
                  'Syariah',
                  'Ushuluddin',
                  'Tarbiyah',
                  'Adab dan Humaniora',
                  'Kesehatan Masyarakat'
                ].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                onChanged: (val) => setState(() => _fakultas = val),
                validator: (val) => val == null ? 'Pilih salah satu fakultas' : null,
              ),
              const SizedBox(height: 12),
              const Text('Fasilitas yang Dinilai:'),
              Column(
                children: fasilitas.map((f) {
                  return CheckboxListTile(
                    title: Text(f),
                    value: fasilitasDipilih.contains(f),
                    onChanged: (val) {
                      setState(() {
                        if (val!) {
                          fasilitasDipilih.add(f);
                        } else {
                          fasilitasDipilih.remove(f);
                        }
                      });
                    },
                    activeColor: Colors.purpleAccent.shade100,
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              const Text('Nilai Kepuasan:'),
              Slider(
                value: _nilaiKepuasan,
                min: 1,
                max: 5,
                divisions: 4,
                label: _nilaiKepuasan.round().toString(),
                onChanged: (val) => setState(() => _nilaiKepuasan = val),
                activeColor: Colors.purpleAccent.shade100,
              ),
              const SizedBox(height: 12),
              const Text('Jenis Feedback:'),
              Column(
                children: ['Saran', 'Keluhan', 'Apresiasi'].map((jenis) {
                  return RadioListTile(
                    title: Text(jenis),
                    value: jenis,
                    groupValue: _jenisFeedback,
                    onChanged: (val) => setState(() => _jenisFeedback = val!),
                    activeColor: Colors.purpleAccent.shade100,
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pesanController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Pesan Tambahan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Saya setuju dengan syarat & ketentuan'),
                value: _setuju,
                onChanged: (val) => setState(() => _setuju = val),
                activeColor: Colors.purpleAccent.shade100,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent.shade100),
                  onPressed: _simpanFeedback,
                  child: const Text('Simpan Feedback'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}