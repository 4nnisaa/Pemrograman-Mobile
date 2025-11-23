import 'package:flutter/material.dart';
import 'feedback_result_page.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _komentarController = TextEditingController();
  double _rating = 3.0;

  @override
  void dispose() {
    _namaController.dispose();
    _komentarController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeedbackResultPage(
            nama: _namaController.text,
            komentar: _komentarController.text,
            rating: _rating,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🌸 Latar belakang gradasi pink lembut
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8BBD0), // pink muda
              Color(0xFFF06292), // pink cerah
              Color(0xFFEC407A), // pink tua
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🌸 Header cantik
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade200.withOpacity(0.3),
                        offset: const Offset(0, 3),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: const Text(
                    '💌 Form Feedback',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),

                // 🌸 Kartu putih lembut
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  color: Colors.white,
                  shadowColor: Colors.pinkAccent.withOpacity(0.4),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Input nama
                          TextFormField(
                            controller: _namaController,
                            decoration: InputDecoration(
                              labelText: 'Nama',
                              labelStyle: TextStyle(
                                color: Colors.pink.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                              prefixIcon: const Icon(Icons.person, color: Colors.pinkAccent),
                              filled: true,
                              fillColor: Colors.pink.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Input komentar
                          TextFormField(
                            controller: _komentarController,
                            decoration: InputDecoration(
                              labelText: 'Komentar',
                              labelStyle: TextStyle(
                                color: Colors.pink.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                              prefixIcon: const Icon(Icons.comment, color: Colors.pinkAccent),
                              filled: true,
                              fillColor: Colors.pink.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Komentar tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Rating slider
                          const Text(
                            'Rating:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Slider(
                            value: _rating,
                            min: 1.0,
                            max: 5.0,
                            divisions: 4,
                            label: _rating.toStringAsFixed(1),
                            activeColor: Colors.pinkAccent,
                            inactiveColor: Colors.pink.shade100,
                            onChanged: (value) {
                              setState(() {
                                _rating = value;
                              });
                            },
                          ),
                          Text(
                            'Rating: ${_rating.toStringAsFixed(1)} / 5.0',
                            style: const TextStyle(fontSize: 16),
                          ),

                          const SizedBox(height: 30),

                          // Tombol kirim
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                              ),
                              onPressed: _submitFeedback,
                              child: const Text(
                                'Kirim Feedback',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
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
      ),
    );
  }
}
