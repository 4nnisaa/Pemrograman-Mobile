import 'package:flutter/material.dart';
import 'feedback_detail_page.dart';
import 'model/feedback_item.dart';

class FeedbackListPage extends StatefulWidget {
  final List<FeedbackItem> items;
  const FeedbackListPage({super.key, required this.items});

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  Color _getIconColor(String jenis) {
    switch (jenis) {
      case 'Apresiasi':
        return Colors.green;
      case 'Saran':
        return Colors.purpleAccent.shade100;
      case 'Keluhan':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Feedback'), backgroundColor: Colors.purpleAccent.shade100),
      body: widget.items.isEmpty
          ? const Center(child: Text('Belum ada feedback.'))
          : ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      Icons.feedback,
                      color: _getIconColor(item.jenisFeedback),
                    ),
                    title: Text(item.nama),
                    subtitle: Text('${item.fakultas} • Kepuasan: ${item.nilaiKepuasan.round()}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FeedbackDetailPage(
                            item: item,
                            onDelete: () {
                              setState(() => widget.items.removeAt(index));
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}