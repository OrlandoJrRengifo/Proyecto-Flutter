import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/app_database.dart';

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
import 'courses/presentation/controller/course_controller.dart'; 
import 'courses/presentation/pages/courses_page.dart';

// SQFLite para web (para pruebas)
//import 'package:flutter/foundation.dart' show kIsWeb;
//import 'dart:io' show Platform;
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';


// Inscripciones
import 'features/RegToCourse/domain/repositories/i_user_course_repository.dart';
import 'features/RegToCourse/domain/usecases/user_course_usecase.dart';
import 'features/RegToCourse/data/datasources/i_user_course_source.dart';
import 'features/RegToCourse/data/datasources/user_course_sqflite_source.dart';
import 'features/RegToCourse/data/repositories/user_course_repository.dart';
import 'features/RegToCourse/presentation/controller/user_course_controller.dart';
// ==================== Autenticación ====================
import 'features/auth/data/datasources/auth_sqflite_source.dart';
import 'features/auth/data/datasources/i_auth_source.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_usecase.dart';
import 'features/auth/presentation/controller/auth_controller.dart';
import 'features/auth/presentation/pages/loginScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance;

  // ==================== Autenticación ====================
  // Registrar primero todo lo relacionado con auth
  Get.put<IAuthenticationSource>(AuthSqfliteSource(), permanent: true);
  Get.put(AuthRepository(Get.find<IAuthenticationSource>()), permanent: true);
  Get.put(AuthenticationUseCase(Get.find<AuthRepository>()), permanent: true);
  Get.put(AuthenticationController(Get.find<AuthenticationUseCase>()), permanent: true);

  // Ahora que AuthenticationController existe, se puede registrar CoursesController
  

  // ==================== Categorías ====================
  Get.lazyPut<ICategoryLocalDataSource>(() => CategoryLocalDataSourceSqflite(), fenix: true);
  Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find()), fenix: true);
  Get.lazyPut(() => CategoryUseCases(Get.find()), fenix: true);
  Get.put(CategoriesController(useCases: Get.find()), permanent: true);

  // ==================== Cursos ====================
  Get.lazyPut<ICourseLocalDataSource>(() => CourseLocalDataSourceSqflite(), fenix: true);
  Get.lazyPut<CourseRepository>(() => CourseRepositoryImpl(Get.find()), fenix: true);
  Get.lazyPut(() => CourseUseCases(Get.find()), fenix: true);
  Get.put(CoursesController(useCases: Get.find()), permanent: true);

  // ==================== Inscripciones ====================
  Get.lazyPut<IUserCourseSource>(() => UserCourseSqfliteSource(), fenix: true);
  Get.lazyPut<IUserCourseRepository>(() => UserCourseRepository(Get.find()), fenix: true);
  Get.lazyPut(() => UserCourseUseCase(Get.find()), fenix: true);
  Get.put(UserCourseController(Get.find()), permanent: true);

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
      home: const LoginScreen(),
    );
  }
}
