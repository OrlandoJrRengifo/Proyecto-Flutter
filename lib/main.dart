import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ==================== Categorías ====================
import 'features/categories/domain/usecases/create_category.dart';
import 'features/categories/domain/usecases/list_categories.dart';
import 'features/categories/domain/usecases/get_category.dart';
import 'features/categories/domain/usecases/update_category.dart';
import 'features/categories/domain/usecases/delete_category.dart';
import 'features/categories/data/repositories/category_repository_impl.dart';
import 'features/categories/data/datasources/in_memory_category_datasource.dart';
import 'features/categories/controllers/categories_controller.dart';
import 'features/categories/presentation/pages/categories_page.dart';
import 'features/categories/domain/repositories/category_repository.dart';

// ==================== Autenticación ====================
import 'features/auth/data/datasources/auth_sqflite_source.dart';
import 'features/auth/data/datasources/i_auth_source.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_usecase.dart';
import 'features/auth/presentation/controller/auth_controller.dart';
import 'features/auth/presentation/pages/loginScreen.dart';


void main() {
  // ==================== Categorías ====================
  Get.lazyPut(() => InMemoryCategoryDataSource());
  Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find()));
  Get.lazyPut(() => CreateCategory(Get.find()));
  Get.lazyPut(() => ListCategories(Get.find()));
  Get.lazyPut(() => GetCategory(Get.find()));
  Get.lazyPut(() => UpdateCategory(Get.find()));
  Get.lazyPut(() => DeleteCategory(Get.find()));
  Get.lazyPut(() => CategoriesController(
        createCategory: Get.find(),
        listCategories: Get.find(),
        getCategory: Get.find(),
        updateCategory: Get.find(),
        deleteCategory: Get.find(),
      ));

  // ==================== Autenticación ====================
  Get.put<IAuthenticationSource>(AuthenticationLocalSource());
  Get.put(AuthRepository(Get.find<IAuthenticationSource>()));
  Get.put(AuthenticationUseCase(Get.find<AuthRepository>()));
  Get.put(AuthenticationController(Get.find<AuthenticationUseCase>()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sistema de Cursos',
      debugShowCheckedModeBanner: false,
      // Pantalla inicial: Login
      home: const LoginScreen(),
    );
  }
}
