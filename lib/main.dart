import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'categories/domain/usecases/create_category.dart';
import 'categories/domain/usecases/list_categories.dart';
import 'categories/domain/usecases/get_category.dart';
import 'categories/domain/usecases/update_category.dart';
import 'categories/domain/usecases/delete_category.dart';
import 'categories/data/repositories/category_repository_impl.dart';
import 'categories/data/datasources/in_memory_category_datasource.dart';
import 'categories/controllers/categories_controller.dart';
import 'categories/presentation/pages/categories_page.dart';
import 'categories/domain/repositories/category_repository.dart';
import 'screens/courses_screen.dart';
import 'services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/presentation/pages/categories_page.dart';
import 'di.dart' as di;
import 'presentation/pages/loginScreen.dart';

void main() {

  //Categorías - Inyección de dependencias con GetX
  // DataSource
  Get.lazyPut(() => InMemoryCategoryDataSource());

  // Repository (recibe datasource)
  Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find()));

  // Usecases (reciben repository)
  Get.lazyPut(() => CreateCategory(Get.find()));
  Get.lazyPut(() => ListCategories(Get.find()));
  Get.lazyPut(() => GetCategory(Get.find()));
  Get.lazyPut(() => UpdateCategory(Get.find()));
  Get.lazyPut(() => DeleteCategory(Get.find()));

  // Controller (recibe los usecases)
  Get.lazyPut(() => CategoriesController(
        createCategory: Get.find(),
        listCategories: Get.find(),
        getCategory: Get.find(),
        updateCategory: Get.find(),
        deleteCategory: Get.find(),
      ));

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
