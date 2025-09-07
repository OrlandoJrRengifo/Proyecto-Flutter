import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Domain
import 'categories/domain/repositories/category_repository.dart';
import 'categories/domain/usecases/category_usecases.dart';
// Data
import 'categories/data/datasources/i_category_local_datasource.dart';
import 'categories/data/datasources/category_local_datasource_sqflite.dart';
import 'categories/data/repositories/category_repository_impl.dart';
// Presentation
import 'categories/controllers/categories_controller.dart';
import 'categories/presentation/pages/categories_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inyección de dependencias con GetX - Categorias
  Get.lazyPut<ICategoryLocalDataSource>(() => CategoryLocalDataSourceSqflite());
  Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find()));
  Get.lazyPut(() => CategoryUseCases(Get.find()));
  Get.lazyPut(() => CategoriesController(useCases: Get.find()));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final int demoCourseId = 1;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sistema de Cursos',
      home: CategoriesPage(courseId: demoCourseId),
    );
  }
}