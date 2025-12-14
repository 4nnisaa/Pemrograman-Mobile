import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../utils/constants.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(bool?) onToggle;
  final Function() onEdit;
  final Function() onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: todo.isCompleted 
            ? LinearGradient(
                colors: [Colors.grey[200]!, Colors.grey[100]!],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : AppGradients.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: todo.isCompleted ? Colors.grey[300] : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Checkbox(
              value: todo.isCompleted,
              onChanged: onToggle,
              activeColor: AppColors.primaryColor,
              shape: const CircleBorder(),
              side: BorderSide(
                color: todo.isCompleted ? Colors.grey : AppColors.primaryColor,
                width: 2,
              ),
            ),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              color: todo.isCompleted ? Colors.grey[600] : Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: todo.isCompleted ? Colors.grey[500] : Colors.white70,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Dibuat: ${_formatDate(todo.createdAt)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: todo.isCompleted ? Colors.grey[500] : Colors.white70,
                    ),
                  ),
                ],
              ),
              if (todo.updatedAt != null)
                Row(
                  children: [
                    Icon(
                      Icons.update,
                      size: 12,
                      color: todo.isCompleted ? Colors.grey[500] : Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Diupdate: ${_formatDate(todo.updatedAt!)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: todo.isCompleted ? Colors.grey[500] : Colors.white70,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: todo.isCompleted ? Colors.grey[600] : Colors.white,
                  size: 20,
                ),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: todo.isCompleted ? Colors.grey[600] : Colors.white,
                  size: 20,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}