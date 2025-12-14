import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';
import '../widgets/todo_item.dart';
import '../widgets/empty_state.dart';
import '../utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];
  List<Todo> filteredTodos = [];
  String currentFilter = AppConstants.filterAll;
  bool isLoading = true;

  final TodoService _todoService = TodoService();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadTodos() async {
    setState(() => isLoading = true);
    todos = await _todoService.loadTodos();
    _applyFilter();
    setState(() => isLoading = false);
  }

  void _applyFilter() {
    switch (currentFilter) {
      case AppConstants.filterDone:
        filteredTodos = todos.where((todo) => todo.isCompleted).toList();
        break;
      case AppConstants.filterNotDone:
        filteredTodos = todos.where((todo) => !todo.isCompleted).toList();
        break;
      default:
        filteredTodos = List.from(todos);
    }
    
    filteredTodos.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  void _saveTodos() {
    _todoService.saveTodos(todos);
  }

  void _showAddTodoDialog() {
    _textController.clear();
    
    showDialog(
      context: context,
      builder: (context) => _buildTodoDialog(
        title: AppConstants.addTodoTitle,
        onSave: _addTodo,
      ),
    );
  }

  void _addTodo() {
    final title = _textController.text.trim();
    if (title.isEmpty) return;

    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
    );

    setState(() {
      todos.insert(0, newTodo);
      _applyFilter();
    });

    _saveTodos();
    Navigator.pop(context);
  }

  void _showEditTodoDialog(Todo todo) {
    _textController.text = todo.title;
    
    showDialog(
      context: context,
      builder: (context) => _buildTodoDialog(
        title: AppConstants.editTodoTitle,
        onSave: () => _updateTodo(todo),
      ),
    );
  }

  Widget _buildTodoDialog({required String title, required VoidCallback onSave}) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _textController,
                autofocus: true,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Tulis tugas kamu di sini...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: AppColors.textColor),
                onSubmitted: (_) => onSave(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      side: const BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(AppConstants.cancelText),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 2,
                    ),
                    child: const Text(AppConstants.saveText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateTodo(Todo todo) {
    final newTitle = _textController.text.trim();
    if (newTitle.isEmpty) return;

    setState(() {
      final index = todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        todos[index] = todo.copyWith(
          title: newTitle,
          updatedAt: DateTime.now(),
        );
        _applyFilter();
      }
    });

    _saveTodos();
    Navigator.pop(context);
  }

  void _toggleTodoStatus(Todo todo) {
    setState(() {
      final index = todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        todos[index] = todo.copyWith(
          isCompleted: !todo.isCompleted,
          updatedAt: DateTime.now(),
        );
        _applyFilter();
      }
    });
    _saveTodos();
  }

  void _showDeleteConfirmation(Todo todo) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.dangerColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                AppConstants.confirmDeleteTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.confirmDeleteMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(AppConstants.cancelText),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _deleteTodo(todo);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dangerColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(AppConstants.deleteText),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      todos.removeWhere((t) => t.id == todo.id);
      _applyFilter();
    });
    _saveTodos();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tugas berhasil dihapus!'),
        backgroundColor: AppColors.successColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _clearAllTodos() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_forever_rounded,
                color: AppColors.dangerColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Hapus Semua Tugas?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Semua tugas akan dihapus permanen!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(AppConstants.cancelText),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          todos.clear();
                          filteredTodos.clear();
                        });
                        _saveTodos();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dangerColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Hapus Semua'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filter, String text) {
    final isSelected = currentFilter == filter;
    return FilterChip(
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          currentFilter = filter;
          _applyFilter();
        });
      },
      label: Text(text),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.primaryColor,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.white,
      selectedColor: AppColors.primaryColor,
      checkmarkColor: Colors.white,
      side: BorderSide(color: AppColors.primaryColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppConstants.appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.appBarGradient,
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (todos.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: _clearAllTodos,
              tooltip: 'Hapus Semua',
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),

      body: Column(
        children: [
          // Filter Section
          if (!isLoading && todos.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterChip(AppConstants.filterAll, 'Semua'),
                  _buildFilterChip(AppConstants.filterNotDone, 'Aktif'),
                  _buildFilterChip(AppConstants.filterDone, 'Selesai'),
                ],
              ),
            ),

          // Todo List
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : filteredTodos.isEmpty
                    ? EmptyState(
                        message: currentFilter == AppConstants.filterAll
                            ? AppConstants.emptyTodoMessage
                            : currentFilter == AppConstants.filterDone
                                ? 'Belum ada tugas yang selesai 🌟'
                                : 'Semua tugas sudah selesai! 🎉',
                        icon: currentFilter == AppConstants.filterAll
                            ? Icons.celebration_outlined
                            : currentFilter == AppConstants.filterDone
                                ? Icons.incomplete_circle_outlined
                                : Icons.check_circle_outline,
                      )
                    : ListView.builder(
                        itemCount: filteredTodos.length,
                        itemBuilder: (context, index) {
                          final todo = filteredTodos[index];
                          return TodoItem(
                            todo: todo,
                            onToggle: (value) => _toggleTodoStatus(todo),
                            onEdit: () => _showEditTodoDialog(todo),
                            onDelete: () => _showDeleteConfirmation(todo),
                          );
                        },
                      ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}