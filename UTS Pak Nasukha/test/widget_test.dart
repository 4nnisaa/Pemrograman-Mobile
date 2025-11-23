import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_campus_feedback/main.dart';

void main() {
  testWidgets('Widget test check', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusFeedbackApp());

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);

    // Cek tombol isi kuesioner tampil
    expect(find.text('Isi Kuesioner'), findsOneWidget);
    expect(find.text('Lihat Feedback'), findsOneWidget);
    expect(find.text('Tentang Aplikasi'), findsOneWidget);
  });
}