import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch Todos from Firebase
  Future<List<TodoModel>> fetchTodos() async {
    try {
      QuerySnapshot snapshot = await _db.collection('todos').get();
      List<TodoModel> todos = snapshot.docs
          .map((doc) => TodoModel.fromFirestore(doc)) // Use fromFirestore here
          .toList();
      return todos;
    } catch (e) {
      throw Exception('Failed to fetch todos: $e');
    }
  }

  // Add a new Todo
  Future<void> addTodo(TodoModel todo) async {
    try {
      await _db.collection('todos').add(todo.toMap());
    } catch (e) {
      throw Exception('Failed to add todo: $e');
    }
  }

  // Update a Todo
  Future<void> updateTodo(TodoModel todo) async {
    try {
      await _db.collection('todos').doc(todo.id).update(todo.toMap());
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  // Delete a Todo
  Future<void> deleteTodo(String id) async {
    try {
      await _db.collection('todos').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }
}
