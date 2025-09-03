import 'package:flutter/material.dart';
import 'screens/courses_screen.dart';
import 'services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/presentation/pages/categories_page.dart';
import 'di.dart' as di;
import 'presentation/pages/loginScreen.dart';


void main() {
  // Intento de autentación de usuario
  AuthService.login();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final String demoCourseId = '101';

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Home
    //return MaterialApp(
    //  title: 'Sistema de Cursos',
    //  theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
    //  home: const CoursesScreen(),
    //);
    //Login
    return const MaterialApp(home: LoginScreen());
    //CRUD Categorias
    //return MaterialApp(
    //  home: BlocProvider(
    //    create: (_) => di.createCategoriesCubit(),
    //    child: CategoriesPage(courseId: demoCourseId),
    //  ),
    //);
  }
}
