import '../models/jadwal.dart';
import 'dart:math';

final List<Jadwal> daftarJadwal = [
  Jadwal(
    mataKuliah: 'Rekayasa Perangkat Lunak',
    dosen: 'DILA NURLAILA, M.Kom',
    nip: '1571015201960020',
    kelas: 'C',
    jadwal: 'Kamis 12:30–15:00',
    ruang: 'B-603',
    peserta: 32,
  ),
  Jadwal(
    mataKuliah: 'Technopreneurship',
    dosen: 'M. YUSUF, S.Kom., M.S.I',
    nip: '1988021420191007',
    kelas: 'C',
    jadwal: 'Rabu 12:30–15:00',
    ruang: 'B-603',
    peserta: 32,
  ),
  Jadwal(
    mataKuliah: 'Pemrograman Mobile',
    dosen: 'AHMAD NASUKHA, S.Hum., M.S.I',
    nip: '19880722 202203 1 001',
    kelas: 'C',
    jadwal: 'Kamis 15:01–18:21',
    ruang: 'B-603',
    peserta: 32,
  ),
  Jadwal(
    mataKuliah: 'Testing dan Implementasi System',
    dosen: 'HERY AFRIYADI, SE., S.Kom., M.Si',
    nip: '197104152000121001',
    kelas: 'C',
    jadwal: 'Senin 12:30–15:00',
    ruang: 'B-603',
    peserta: 32,
  ),
  Jadwal(
    mataKuliah: 'Manajemen Resiko',
    dosen: 'Wahyu Anggoro, M.Kom',
    nip: '1571082309960021',
    kelas: 'C',
    jadwal: 'Rabu 15:01–17:31',
    ruang: 'B-603',
    peserta: 32,
  ),
  Jadwal(
    mataKuliah: 'Multimedia',
    dosen: 'POL METRA, M.Kom',
    nip: '19910615010122045',
    kelas: 'C',
    jadwal: 'Senin 15:01–18:21',
    ruang: 'B-603',
    peserta: 32,
  ),
];

// Jika kamu mau acak urutannya setiap kali aplikasi dijalankan:
List<Jadwal> get daftarJadwalAcak {
  final random = Random();
  final shuffled = List<Jadwal>.from(daftarJadwal);
  shuffled.shuffle(random);
  return shuffled;
}
