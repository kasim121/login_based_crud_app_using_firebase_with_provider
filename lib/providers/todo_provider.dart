import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  final List<TodoModel> _todos = [];
  List<TodoModel> get todos => List.unmodifiable(_todos);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TodoProvider() {
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    try {
      final snapshot = await _firestore.collection('todos').get();
      _todos.clear();
      for (var doc in snapshot.docs) {
        _todos.add(TodoModel.fromFirestore(doc));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching todos: $e');
    }
  }

  Future<void> addTodo(TodoModel todo) async {
    try {
      final docRef = _firestore.collection('todos').doc(todo.id);
      await docRef.set(todo.toMap());
      _todos.add(todo);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding todo: $e');
    }
  }

  Future<void> updateTodo(TodoModel todo) async {
    try {
      final docRef = _firestore.collection('todos').doc(todo.id);
      await docRef.update(todo.toMap());
      final index = _todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        _todos[index] = todo;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating todo: $e');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final docRef = _firestore.collection('todos').doc(id);
      await docRef.delete();
      _todos.removeWhere((todo) => todo.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting todo: $e');
    }
  }
}


// import 'package:flutter/material.dart';
// import '../models/todo_model.dart';
// import '../services/firebase_todo_services.dart';

// class TodoProvider with ChangeNotifier {
//   final FirebaseService _firebaseService = FirebaseService();
//   List<TodoModel> _todos = [];

//   List<TodoModel> get todos => _todos;

//   // Fetch Todos from Firebase
//   Future<void> fetchTodos() async {
//     _todos = await _firebaseService.fetchTodos();
//     notifyListeners();
//   }

//   // Add a new Todo
//   Future<void> addTodo(TodoModel todo) async {
//     await _firebaseService.addTodo(todo);
//     _todos.add(todo);
//     notifyListeners();
//   }

//   // Update a Todo
//   Future<void> updateTodo(TodoModel todo) async {
//     await _firebaseService.updateTodo(todo);
//     int index = _todos.indexWhere((t) => t.id == todo.id);
//     if (index != -1) {
//       _todos[index] = todo;
//       notifyListeners();
//     }
//   }

//   // Delete a Todo
//   Future<void> deleteTodo(String id) async {
//     await _firebaseService.deleteTodo(id);
//     _todos.removeWhere((todo) => todo.id == id);
//     notifyListeners();
//   }
// }
