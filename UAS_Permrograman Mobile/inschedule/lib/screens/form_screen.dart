import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../models/schedule.dart';

class FormScreen extends StatefulWidget {
  final Schedule? schedule;
  const FormScreen({super.key, this.schedule});

  @override
  State<FormScreen> createState() =>
      _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController matkul;
  late TextEditingController dosen;
  late TextEditingController jam;
  late TextEditingController ruang;
  String hari = 'Senin';

  @override
  void initState() {
    super.initState();
    matkul =
        TextEditingController(text: widget.schedule?.matkul ?? '');
    dosen =
        TextEditingController(text: widget.schedule?.dosen ?? '');
    jam =
        TextEditingController(text: widget.schedule?.jam ?? '');
    ruang =
        TextEditingController(text: widget.schedule?.ruang ?? '');
    hari = widget.schedule?.hari ?? 'Senin';
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.schedule != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF701239),
        title: Text(
          isEdit ? 'Edit Jadwal' : 'Tambah Jadwal',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field('Mata Kuliah', matkul),
              _field('Dosen', dosen),
              _field('Jam', jam),
              _field('Ruang', ruang),

              const SizedBox(height: 12),

              DropdownButtonFormField(
                value: hari,
                items: [
                  'Senin',
                  'Selasa',
                  'Rabu',
                  'Kamis',
                  'Jumat',
                  'Sabtu',
                ]
                    .map((d) =>
                        DropdownMenuItem(
                          value: d,
                          child: Text(d),
                        ))
                    .toList(),
                onChanged: (v) =>
                    setState(() => hari = v!),
                decoration:
                    const InputDecoration(
                  labelText: 'Hari',
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                child: Text(
                  isEdit ? 'Simpan Perubahan' : 'Tambah Jadwal',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  if (!_formKey.currentState!
                      .validate()) return;

                  final provider =
                      context.read<
                          ScheduleProvider>();

                  if (isEdit) {
                    provider.updateSchedule(
                      id: widget.schedule!.id,
                      matkul: matkul.text,
                      dosen: dosen.text,
                      jam: jam.text,
                      ruang: ruang.text,
                      hari: hari,
                    );
                  } else {
                    provider.addSchedule(
                      matkul: matkul.text,
                      dosen: dosen.text,
                      jam: jam.text,
                      ruang: ruang.text,
                      hari: hari,
                    );
                  }

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
      String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        decoration:
            InputDecoration(labelText: label),
        validator: (v) =>
            v == null || v.isEmpty
                ? 'Wajib diisi'
                : null,
      ),
    );
  }
}
