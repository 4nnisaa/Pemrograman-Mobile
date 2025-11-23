import 'package:flutter/material.dart';
import 'feedback_form_page.dart';
import 'feedback_list_page.dart';
import 'about_page.dart';
import 'model/feedback_item.dart';
import 'feedback_detail_page.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<FeedbackItem> feedbackItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Feedback'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent.shade100,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              widget.toggleTheme();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(widget.isDarkMode
                      ? 'Dark mode diaktifkan'
                      : 'Light mode diaktifkan'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/flutter_logo.png', height: 120),
              const SizedBox(height: 20),
              const Text(
                'Selamat Datang di Aplikasi Kuesioner Kampus!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent.shade100,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  final newItem = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FeedbackFormPage()),
                  );

                  if (newItem != null && newItem is FeedbackItem) {
                    setState(() => feedbackItems.add(newItem));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FeedbackDetailPage(
                          item: newItem,
                          onDelete: () {
                            setState(() => feedbackItems.remove(newItem));
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feedback berhasil disimpan!')),
                    );
                  }
                },
                icon: const Icon(Icons.add_comment),
                label: const Text('Isi Kuesioner'),
              ),
              const SizedBox(height: 10),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent.shade100,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedbackListPage(items: feedbackItems)),
                  );
                },
                icon: const Icon(Icons.list),
                label: const Text('Lihat Feedback'),
              ),
              const SizedBox(height: 10),

              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.purpleAccent.shade100),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()));
                },
                icon: Icon(Icons.info_outline, color: Colors.purpleAccent.shade100),
                label: Text('Tentang Aplikasi', style: TextStyle(color: Colors.purpleAccent.shade100)),
              ),
              const Spacer(),

              const Text(
                '“Coding adalah seni memecahkan masalah dengan logika dan kreativitas.”',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}