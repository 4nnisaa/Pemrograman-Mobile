import 'package:flutter/material.dart';
import '../utils/constants.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyState({
    super.key,
    this.message = AppConstants.emptyTodoMessage,
    this.icon = Icons.celebration_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                message,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Tap + untuk membuat tugas pertama kamu!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}