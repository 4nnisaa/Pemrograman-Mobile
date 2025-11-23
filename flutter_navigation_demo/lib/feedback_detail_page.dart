import 'package:flutter/material.dart';

class FeedbackDetailPage extends StatelessWidget {
  final String data;
  const FeedbackDetailPage({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Feedback'),
        backgroundColor: const Color(0xFFE2C8FF), // UNGU
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F2FF), // UNGU ATAS
              Color(0xFFF1E6FF), // UNGU TENGAH
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE2C8FF), // UNGU
                        Color(0xFFCEB2FF), // UNGU LEBIH GELAP
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE2C8FF).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        data.isEmpty ? Icons.inbox_outlined : Icons.mark_email_read,
                        size: 64,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data.isEmpty ? 'Belum Ada Feedback' : 'Feedback Terkirim!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.isEmpty
                            ? 'Silakan kirim feedback pertama Anda'
                            : 'Terima kasih atas kontribusinya!',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE6E0F8).withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFE2C8FF), // UNGU
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.format_quote,
                        size: 32,
                        color: Color(0xFFE2C8FF), // UNGU
                      ),
                      const SizedBox(height: 16),

                      if (data.isEmpty) ...[
                        const Column(
                          children: [
                            Icon(
                              Icons.sentiment_dissatisfied,
                              size: 48,
                              color: Color(0xFFE2C8FF), // UNGU
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Kotak Masih Kosong\n\n'
                              'Belum ada feedback yang diterima. '
                              'Klik tombol "Isi Feedback" di halaman home '
                              'untuk mengirim feedback pertama Anda!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF888888),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F2FF), // BACKGROUND UNGU
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Color(0xFFE2C8FF), // UNGU
                            ),
                          ),
                          child: Text(
                            data,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF555555),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FFF0),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF98FB98),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green[700],
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Feedback berhasil diterima',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF228B22),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),
                      const Icon(
                        Icons.format_quote,
                        size: 32,
                        color: Color(0xFFE2C8FF), // UNGU
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),

                if (data.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFFFFA500),
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Feedback Anda sangat berharga untuk pengembangan aplikasi ini.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFB8860B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      if (data.isEmpty) ...[
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE2C8FF), // UNGU
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          icon: const Icon(Icons.add_comment),
                          label: const Text('Buat Feedback Pertama'),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: const BorderSide(color: Color(0xFFE2C8FF)), // UNGU
                                ),
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Kembali'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.popUntil(context, (route) => route.isFirst);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE2C8FF), // UNGU
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                                icon: const Icon(Icons.home),
                                label: const Text('Ke Home'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFF1E6FF), // GARIS UNGU
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 16,
                        color: Color(0xFFE2C8FF), // UNGU
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Privacy Protected • Pink Theme',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE2C8FF), // UNGU
                        ),
                      ),
                    ],
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