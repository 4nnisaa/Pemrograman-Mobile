import 'package:flutter/material.dart';
import 'pages/jadwal_list_page.dart';

void main() {
  runApp(const ProfilDosenApp());
}

class ProfilDosenApp extends StatelessWidget {
  const ProfilDosenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profil Dosen App',
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Roboto'),
      home: const JadwalListPage(),
    );
  }
}
