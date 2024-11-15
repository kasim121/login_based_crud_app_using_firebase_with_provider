import 'package:auth_app/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/todo_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/firebase_auth_methods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
        // Provider to listen to authentication state changes
        StreamProvider<User?>(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Firebase Methods',
        debugShowCheckedModeBanner: false,
        theme: systemLightTheme,
        home: const AuthStateChanges(),
        routes: {
          '/login': (context) => const LoginScreen(),
          // Other routes go here
        },
      ),
    );
  }
}

class AuthStateChanges extends StatelessWidget {
  const AuthStateChanges({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseCurrentUser = context.watch<User?>();

    // Navigate to HomeScreen if user is logged in, else LoginScreen
    if (firebaseCurrentUser != null) {
      return const HomeScreen();
    }
    return const LoginScreen();
  }
}
