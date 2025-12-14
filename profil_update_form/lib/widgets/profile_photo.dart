import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhoto extends StatefulWidget {
  final String initialPhoto; // path foto awal
  final Function(String) onPhotoChanged; // callback saat foto berubah

  const ProfilePhoto({
    super.key,
    required this.initialPhoto,
    required this.onPhotoChanged,
  });

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  late String photo;

  @override
  void initState() {
    super.initState();
    photo = widget.initialPhoto; // set foto awal
  }

  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        photo = image.path; // update path foto
      });
      widget.onPhotoChanged(photo); // kirim ke parent
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickPhoto, // tap untuk pilih foto
      child: CircleAvatar(
        radius: 50,
        backgroundImage: photo.isNotEmpty
            ? (File(photo).existsSync()
                ? FileImage(File(photo)) // pakai file kalau ada
                : const AssetImage('assets/images/Nisass.jpg') as ImageProvider)
            : const AssetImage('assets/images/Nisass.jpg') as ImageProvider, // fallback
      ),
    );
  }
}
