import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  factory TodoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TodoModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';

// class TodoModel {
//   String id;
//   String title;
//   String description;
//   bool isCompleted;

//   TodoModel({
//     required this.id,
//     required this.title,
//     required this.description,
//     this.isCompleted = false,
//   });

//   // Convert TodoModel to Map (for Firestore)
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'description': description,
//       'isCompleted': isCompleted,
//     };
//   }

//   // Create TodoModel from Firestore DocumentSnapshot
//   factory TodoModel.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
//     return TodoModel(
//       id: doc.id, // Firestore document ID
//       title: map['title'],
//       description: map['description'],
//       isCompleted: map['isCompleted'] ?? false, // Default false if null
//     );
//   }

//   // Create TodoModel from Map (for custom conversion)
//   factory TodoModel.fromMap(Map<String, dynamic> map, String docId) {
//     return TodoModel(
//       id: docId,
//       title: map['title'],
//       description: map['description'],
//       isCompleted: map['isCompleted'],
//     );
//   }
// }
