import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoService {
  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('todos');

    if (jsonString == null) return [];

    List data = json.decode(jsonString);
    return data.map((e) => Todo.fromJson(e)).toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString =
        json.encode(todos.map((t) => t.toJson()).toList());
    await prefs.setString('todos', jsonString);
  }
}