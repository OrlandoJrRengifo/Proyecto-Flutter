import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'categories/domain/usecases/category_usecases.dart';
import 'categories/data/repositories/category_repository_impl.dart';
import 'categories/data/datasources/in_memory_category_datasource.dart';
import 'categories/controllers/categories_controller.dart';
import 'categories/presentation/pages/categories_page.dart';
import 'categories/domain/repositories/category_repository.dart';


void main() {

  //Categorías - Inyección de dependencias con GetX
  // DataSource
  Get.lazyPut(() => InMemoryCategoryDataSource());

  // Repository (recibe datasource)
  Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find()));

  // Usecases (reciben repository)
  Get.lazyPut(() => CategoryUseCases(Get.find()));

  // Controller (recibe los usecases)
  Get.lazyPut(() => CategoriesController(useCases: Get.find()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String demoCourseId = 'Programacion Movil';

  @override
  Widget build(BuildContext context) {
   return GetMaterialApp(
      title: 'Sistema de Cursos',
      home: CategoriesPage(courseId: "Programacion Movil"),
    );
  }
}
