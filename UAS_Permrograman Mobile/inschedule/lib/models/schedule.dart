class Schedule {
  final String id;
  final String matkul;
  final String dosen;
  final String jam;
  final String ruang;
  final String hari;
  final String? userId; // ✅ DITAMBAH: untuk identifikasi pemilik jadwal
  final DateTime createdAt;

  Schedule({
    required this.id,
    required this.matkul,
    required this.dosen,
    required this.jam,
    required this.ruang,
    required this.hari,
    this.userId, // ✅ DITAMBAH
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Schedule.fromJson(Map<String, dynamic> json, String id) {
    return Schedule(
      id: id,
      matkul: json['matkul'] ?? '',
      dosen: json['dosen'] ?? '',
      jam: json['jam'] ?? '',
      ruang: json['ruang'] ?? '',
      hari: json['hari'] ?? 'Senin',
      userId: json['userId'], // ✅ DITAMBAH: bisa null jika data lama
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matkul': matkul,
      'dosen': dosen,
      'jam': jam,
      'ruang': ruang,
      'hari': hari,
      'userId': userId, // ✅ DITAMBAH
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Schedule copyWith({
    String? id,
    String? matkul,
    String? dosen,
    String? jam,
    String? ruang,
    String? hari,
    String? userId, // ✅ DITAMBAH
    DateTime? createdAt,
  }) {
    return Schedule(
      id: id ?? this.id,
      matkul: matkul ?? this.matkul,
      dosen: dosen ?? this.dosen,
      jam: jam ?? this.jam,
      ruang: ruang ?? this.ruang,
      hari: hari ?? this.hari,
      userId: userId ?? this.userId, // ✅ DITAMBAH
      createdAt: createdAt ?? this.createdAt,
    );
  }
}