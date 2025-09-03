import 'package:flutter/material.dart';
import 'screens/courses_screen.dart';
import 'services/auth_service.dart';

void main() {
  // Intento de autentación de usuario
  AuthService.login();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Cursos',
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
      home: const CoursesScreen(),
    );
  }
}
