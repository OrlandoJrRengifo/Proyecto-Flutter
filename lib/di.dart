import 'package:get_it/get_it.dart';

//  categorías
import './data/datasources/in_memory_category_datasource.dart';
import './data/repositories/category_repository_impl.dart';
import './domain/usecases/create_category.dart';
import './domain/usecases/list_categories.dart';
import './domain/usecases/get_category.dart';
import './domain/usecases/update_category.dart';
import './domain/usecases/delete_category.dart';
import './presentation/categories_cubit.dart';

// cursos
import './data/datasources/in_memory_course_datasource.dart';
import './data/repositories/course_repository_impl.dart';
import './domain/usecases/create_course.dart' as course_create;
import './domain/usecases/list_courses.dart' as course_list;
import './domain/usecases/enroll_user_in_course.dart' as course_enroll;
import './presentation/courses_cubit.dart';


final sl = GetIt.instance;

void initDependencies() {

  // CATEGORIES
  sl.registerLazySingleton(() => InMemoryCategoryDataSource());
  sl.registerLazySingleton(() => CategoryRepositoryImpl(sl()));

  sl.registerLazySingleton(() => CreateCategory(sl()));
  sl.registerLazySingleton(() => ListCategories(sl()));
  sl.registerLazySingleton(() => GetCategory(sl()));
  sl.registerLazySingleton(() => UpdateCategory(sl()));
  sl.registerLazySingleton(() => DeleteCategory(sl()));

  sl.registerFactory(() => CategoriesCubit(
        createCategory: sl(),
        listCategories: sl(),
        getCategory: sl(),
        updateCategory: sl(),
        deleteCategory: sl(),
      ));


  // COURSES
  sl.registerLazySingleton(() => InMemoryCourseDataSource());
  sl.registerLazySingleton(() => CourseRepositoryImpl(sl()));

  sl.registerLazySingleton(() => course_create.CreateCourse(sl()));
  sl.registerLazySingleton(() => course_list.ListCourses(sl()));
  sl.registerLazySingleton(() => course_enroll.EnrollUserInCourse(sl()));

  sl.registerFactory(() => CoursesCubit(
        createCourseUC: sl(),
        listCoursesUC: sl(),
        enrollUC: sl(),
      ));
}

