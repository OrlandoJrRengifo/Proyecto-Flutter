import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Categorias
import 'categories/domain/repositories/category_repository.dart';
import 'categories/domain/usecases/category_usecases.dart';
import 'categories/data/datasources/i_category_local_datasource.dart';
import 'categories/data/datasources/category_local_datasource_sqflite.dart';
import 'categories/data/repositories/category_repository_impl.dart';
import 'categories/controllers/categories_controller.dart';
// Cursos
import 'courses/domain/repositories/course_repository.dart';
import 'courses/domain/usecases/course_usecases.dart';
import 'courses/data/datasources/i_course_local_datasource.dart';
import 'courses/data/datasources/course_local_datasource_sqflite.dart';
import 'courses/data/repositories/course_repository_impl.dart';
import 'courses/controllers/course_controller.dart'; 
import 'courses/presentation/pages/courses_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inyección de dependencias con GetX
  // Categorias
  Get.lazyPut<ICategoryLocalDataSource>(() => CategoryLocalDataSourceSqflite(), fenix: true);
  Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find()), fenix: true);
  Get.lazyPut(() => CategoryUseCases(Get.find()), fenix: true);
  Get.put(CategoriesController(useCases: Get.find()), permanent: true);
  // Cursos
  Get.lazyPut<ICourseLocalDataSource>(() => CourseLocalDataSourceSqflite(), fenix: true);
  Get.lazyPut<CourseRepository>(() => CourseRepositoryImpl(Get.find()), fenix: true);
  Get.lazyPut(() => CourseUseCases(Get.find()), fenix: true);
  Get.put(CoursesController(useCases: Get.find()), permanent: true);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sistema de Cursos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CoursesPage(), 
    );
  }
}
