import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_auth_methods.dart';
import '../providers/todo_provider.dart';
import '../models/todo_model.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.email ?? 'User'),
              accountEmail: Text(user.uid),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.account_circle, size: 50),
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: todoProvider.todos.isEmpty
                ? const Center(
                    child: Text(
                      'No todos added yet.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: todoProvider.todos.length,
                    itemBuilder: (context, index) {
                      final todo = todoProvider.todos[index];
                      return TodoItem(todo: todo);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: 'Add Task',
              onPressed: () {
                _showAddTodoDialog(
                    context, TextEditingController(), todoProvider);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () async {
                // Perform the logout action
                await context.read<FirebaseAuthMethods>().logoutUser(context);
                Navigator.pushReplacementNamed(
                    context, '/login'); // Navigate to login screen
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddTodoDialog(
    BuildContext context,
    TextEditingController todoController,
    TodoProvider todoProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _AddTodoDialog(
            todoController: todoController, todoProvider: todoProvider);
      },
    );
  }
}

class _AddTodoDialog extends StatefulWidget {
  final TextEditingController todoController;
  final TodoProvider todoProvider;

  const _AddTodoDialog({
    required this.todoController,
    required this.todoProvider,
  });

  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<_AddTodoDialog> {
  bool _isAdding = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Todo'),
      content: _isAdding
          ? const Center(child: CircularProgressIndicator())
          : TextField(
              controller: widget.todoController,
              decoration: const InputDecoration(
                hintText: 'Enter todo',
                border: OutlineInputBorder(),
              ),
            ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () async {
            if (widget.todoController.text.isNotEmpty) {
              setState(() {
                _isAdding = true;
              });

              final newTodo = TodoModel(
                id: DateTime.now().toString(),
                title: widget.todoController.text,
                description: widget.todoController.text,
                isCompleted: false,
              );
              await widget.todoProvider.addTodo(newTodo);
              widget.todoController.clear();

              setState(() {
                _isAdding = false;
              });

              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a todo before adding it.'),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class TodoItem extends StatelessWidget {
  final TodoModel todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        title: Text(todo.title),
        subtitle: Text(todo.description),
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) async {
            final updatedTodo = TodoModel(
              id: todo.id,
              title: todo.title,
              description: todo.description,
              isCompleted: value ?? false,
            );
            await todoProvider.updateTodo(updatedTodo);
          },
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                _showEditTodoDialog(context, todo, todoProvider);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                todoProvider.deleteTodo(todo.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Todo deleted successfully.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTodoDialog(
    BuildContext context,
    TodoModel todo,
    TodoProvider todoProvider,
  ) {
    final TextEditingController titleController =
        TextEditingController(text: todo.title);
    final TextEditingController descriptionController =
        TextEditingController(text: todo.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter new title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Enter new description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                final updatedTodo = TodoModel(
                  id: todo.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  isCompleted: todo.isCompleted,
                );
                await todoProvider.updateTodo(updatedTodo);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/firebase_auth_methods.dart';
// import '../providers/todo_provider.dart';
// import '../models/todo_model.dart';
// import '../widgets/custom_button.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = context.read<FirebaseAuthMethods>().user;
//     final todoProvider = Provider.of<TodoProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Todo'),
//         centerTitle: true,
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             UserAccountsDrawerHeader(
//               accountName: Text(user.email ?? 'User'),
//               accountEmail: Text(user.uid),
//               currentAccountPicture: const CircleAvatar(
//                 child: Icon(Icons.account_circle, size: 50),
//               ),
//             ),
//             ListTile(
//               title: const Text('Logout'),
//               onTap: () {
//                 _showLogoutConfirmationDialog(context);
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: todoProvider.todos.isEmpty
//                 ? const Center(
//                     child: Text(
//                       'No todos added yet.',
//                       style: TextStyle(fontSize: 18, color: Colors.grey),
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: todoProvider.todos.length,
//                     itemBuilder: (context, index) {
//                       final todo = todoProvider.todos[index];
//                       return TodoItem(todo: todo);
//                     },
//                   ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: CustomButton(
//               text: 'Add Task',
//               onPressed: () {
//                 _showAddTodoDialog(
//                     context, TextEditingController(), todoProvider);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showLogoutConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout Confirmation'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Dismiss the dialog
//               },
//             ),
//             TextButton(
//               child: const Text('Logout'),
//               onPressed: () {
//                 // Perform the logout action
//                 context.read<FirebaseAuthMethods>().logoutUser(context);
//                 Navigator.of(context).pop(); // Dismiss the dialog after logout
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showAddTodoDialog(
//     BuildContext context,
//     TextEditingController todoController,
//     TodoProvider todoProvider,
//   ) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return _AddTodoDialog(
//             todoController: todoController, todoProvider: todoProvider);
//       },
//     );
//   }
// }

// class _AddTodoDialog extends StatefulWidget {
//   final TextEditingController todoController;
//   final TodoProvider todoProvider;

//   const _AddTodoDialog({
//     required this.todoController,
//     required this.todoProvider,
//   });

//   @override
//   _AddTodoDialogState createState() => _AddTodoDialogState();
// }

// class _AddTodoDialogState extends State<_AddTodoDialog> {
//   bool _isAdding = false;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Add Todo'),
//       content: _isAdding
//           ? const Center(child: CircularProgressIndicator())
//           : TextField(
//               controller: widget.todoController,
//               decoration: const InputDecoration(
//                 hintText: 'Enter todo',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//       actions: <Widget>[
//         TextButton(
//           child: const Text('Cancel'),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         TextButton(
//           child: const Text('Add'),
//           onPressed: () async {
//             if (widget.todoController.text.isNotEmpty) {
//               setState(() {
//                 _isAdding = true;
//               });

//               final newTodo = TodoModel(
//                 id: DateTime.now().toString(),
//                 title: widget.todoController.text,
//                 description: widget.todoController.text,
//                 isCompleted: false,
//               );
//               await widget.todoProvider.addTodo(newTodo);
//               widget.todoController.clear();

//               setState(() {
//                 _isAdding = false;
//               });

//               Navigator.of(context).pop();
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Please enter a todo before adding it.'),
//                 ),
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
// }

// class TodoItem extends StatelessWidget {
//   final TodoModel todo;

//   const TodoItem({super.key, required this.todo});

//   @override
//   Widget build(BuildContext context) {
//     final todoProvider = Provider.of<TodoProvider>(context);

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//       child: ListTile(
//         title: Text(todo.title),
//         subtitle: Text(todo.description),
//         leading: Checkbox(
//           value: todo.isCompleted,
//           onChanged: (value) async {
//             final updatedTodo = TodoModel(
//               id: todo.id,
//               title: todo.title,
//               description: todo.description,
//               isCompleted: value ?? false,
//             );
//             await todoProvider.updateTodo(updatedTodo);
//           },
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.edit, color: Colors.blue),
//               onPressed: () {
//                 _showEditTodoDialog(context, todo, todoProvider);
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () {
//                 todoProvider.deleteTodo(todo.id);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Todo deleted successfully.')),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showEditTodoDialog(
//     BuildContext context,
//     TodoModel todo,
//     TodoProvider todoProvider,
//   ) {
//     final TextEditingController titleController =
//         TextEditingController(text: todo.title);
//     final TextEditingController descriptionController =
//         TextEditingController(text: todo.description);

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Edit Todo'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter new title',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: descriptionController,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter new description',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Update'),
//               onPressed: () async {
//                 if (titleController.text.isNotEmpty &&
//                     descriptionController.text.isNotEmpty) {
//                   final updatedTodo = TodoModel(
//                     id: todo.id,
//                     title: titleController.text,
//                     description: descriptionController.text,
//                     isCompleted: todo.isCompleted,
//                   );
//                   await todoProvider.updateTodo(updatedTodo);
//                   Navigator.of(context).pop();
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please fill out all fields.'),
//                     ),
//                   );
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
