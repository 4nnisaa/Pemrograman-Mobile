import 'package:flutter/material.dart';

class FeedbackResultPage extends StatelessWidget {
  final String nama;
  final String komentar;
  final double rating;

  const FeedbackResultPage({
    super.key,
    required this.nama,
    required this.komentar,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🌸 Latar belakang gradasi pink-putih
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8BBD0), // pink muda
              Colors.white,       // putih lembut
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 💖 Header pink gradasi elegan
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFE91E63), // pink utama
                      Color(0xFFF48FB1), // pink muda
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Text(
                  '💬 Hasil Feedback',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              // 💗 Kartu hasil feedback dengan nuansa pink lembut
              Center(
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: const Color(0xFFFFF0F6), // pink pastel lembut
                  shadowColor: Colors.pinkAccent.withOpacity(0.4),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Nama: $nama',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD81B60), // pink tua
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Komentar: $komentar',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Rating: $rating / 5',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFE91E63), // pink utama
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE91E63), // pink utama
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Kembali',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
