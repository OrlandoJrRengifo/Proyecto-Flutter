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

// SQFLite para web (para pruebas)
//import 'package:flutter/foundation.dart' show kIsWeb;
//import 'dart:io' show Platform;
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

// ==================== Autenticación ====================
import 'features/auth/data/datasources/auth_sqflite_source.dart';
import 'features/auth/data/datasources/i_auth_source.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_usecase.dart';
import 'features/auth/presentation/controller/auth_controller.dart';
import 'features/auth/presentation/pages/loginScreen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

/*
  // sqflite para web
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb; // IndexedDB en navegador
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi; // FFI en desktop
  } else {
    // Android / iOS ya usa el `sqflite` normal
  }
*/

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
      //debugShowCheckedModeBanner: false,
      // Pantalla inicial: Login
      //home: const LoginScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CourseDashboard(), 
    );
  }
}
