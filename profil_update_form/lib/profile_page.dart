import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/storage_service.dart';
import 'widgets/profile_photo.dart';
import 'theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String gender = 'Laki-laki';
  String photo = '';
  bool isEditing = true;
  bool isFinalSaved = false;

  // =============================
  // 🎨 PENGATURAN WARNA (MUDAH DICARI)
  // =============================

  // Warna tombol
  Color buttonSaveColor = const Color(0xFFE0BBFF);     
  Color buttonEditColor = const Color(0xFFE0BBFF);     
  Color buttonFinalSaveColor = const Color(0xFFE0BBFF);

  // Warna SnackBar (Pemberitahuan)
  Color snackbarSaveColor = Colors.purpleAccent.shade100;    
  Color snackbarFinalColor = Colors.purpleAccent.shade100;   
  Color snackbarTextColor = Colors.white;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // =============================
  // ⭐ CUSTOM SNACKBAR (PEMBERITAHUAN)
  // =============================
  void showCustomSnackbar(String message, Color bgColor,
      {Color textColor = Colors.white}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // =============================
  // LOAD DATA
  // =============================
  Future<void> loadProfile() async {
    final data = await StorageService.getProfile();
    setState(() {
      _nameController.text = data['name'] ?? '';
      _emailController.text = data['email'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _bioController.text = data['bio'] ?? '';
      _dobController.text = data['dob'] ?? '';
      gender = data['gender'] ?? 'Laki-laki';
      photo = data['photo'] ?? '';
    });
  }

  // =============================
  // SIMPAN DATA NORMAL
  // =============================
  Future<void> saveProfile() async {
    final profile = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'bio': _bioController.text,
      'dob': _dobController.text,
      'gender': gender,
      'photo': photo,
    };

    await StorageService.saveProfile(profile);

    setState(() => isEditing = false);

    showCustomSnackbar(
      "Profile berhasil disimpan!",
      snackbarSaveColor,
      textColor: snackbarTextColor,
    );
  }

  // =============================
  // PILIH TANGGAL
  // =============================
  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  // =============================
  // UI
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isEditing ? buildForm() : buildSummaryView(),
      ),
    );
  }

  // =============================
  // FORM EDIT
  // =============================
  Widget buildForm() {
  if (isFinalSaved) return buildSummaryView();

  return Center(
    child: Container(
      width: 430,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfilePhoto(
                initialPhoto: photo,
                onPhotoChanged: (p) => setState(() => photo = p),
              ),

              const SizedBox(height: 20),

              buildTextField(_nameController, 'Nama Lengkap'),
              const SizedBox(height: 10),

              buildTextField(_emailController, 'Email'),
              const SizedBox(height: 10),

              buildTextField(_phoneController, 'Nomor Telepon', isNumber: true),
              const SizedBox(height: 10),

              TextFormField(
                controller: _bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Bio tidak boleh kosong' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onTap: selectDate,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Tanggal lahir wajib diisi' : null,
              ),
              const SizedBox(height: 10),

              // FIX ERROR DROPDOWN
              DropdownButtonFormField<String>(
                value: (gender == 'Laki-laki' || gender == 'Perempuan')
                    ? gender
                    : null,
                items: const [
                  DropdownMenuItem(
                      value: 'Laki-laki', child: Text('Laki-laki')),
                  DropdownMenuItem(
                      value: 'Perempuan', child: Text('Perempuan')),
                ],
                onChanged: (v) => setState(() => gender = v ?? 'Laki-laki'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Jenis Kelamin",
                ),
                validator: (value) =>
                    value == null ? "Jenis kelamin harus dipilih" : null,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveProfile();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonSaveColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  // =============================
  // TEXTFIELD COMPONENT
  // =============================
  Widget buildTextField(TextEditingController c, String label,
      {bool isNumber = false}) {
    return TextFormField(
      controller: c,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (v) => v == null || v.trim().isEmpty
          ? '$label tidak boleh kosong'
          : null,
    );
  }

  // =============================
  // RINGKASAN DATA
  // =============================
  Widget buildSummaryView() {
  return Center(
    child: Container(
      width: 430,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Center(
            child: CircleAvatar(
              radius: 55,
              backgroundImage: (photo.isNotEmpty && File(photo).existsSync())
                  ? FileImage(File(photo))
                  : const AssetImage('assets/images/Nisass.jpg')
                      as ImageProvider,
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              _nameController.text.isNotEmpty ? _nameController.text : "-",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          summaryRow("Nama Lengkap", _nameController.text),
          summaryRow("Email", _emailController.text),
          summaryRow("Nomor Telepon", _phoneController.text),
          summaryRow("Bio", _bioController.text),
          summaryRow("Tanggal Lahir", _dobController.text),
          summaryRow("Jenis Kelamin", gender),

          const SizedBox(height: 25),

          if (!isFinalSaved)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => isEditing = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonEditColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Edit"),
                  ),

                  const SizedBox(width: 16),

                  ElevatedButton(
                    onPressed: () async {
                      final data = {
                        'name': _nameController.text,
                        'email': _emailController.text,
                        'phone': _phoneController.text,
                        'bio': _bioController.text,
                        'dob': _dobController.text,
                        'gender': gender,
                        'photo': photo,
                      };

                      await StorageService.saveProfile(data);
                      setState(() => isFinalSaved = true);

                      showCustomSnackbar(
                        "Data final disimpan dan terkunci!",
                        snackbarFinalColor,
                        textColor: snackbarTextColor,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonFinalSaveColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Simpan"),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

  Widget summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value.isNotEmpty ? value : "-")),
        ],
      ),
    );
  }
}
