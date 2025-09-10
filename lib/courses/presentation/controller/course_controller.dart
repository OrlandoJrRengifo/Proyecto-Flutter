import 'package:get/get.dart';
import '../../domain/entities/course.dart';
import '../../domain/usecases/course_usecases.dart';
import '../../../features/auth/presentation/controller/auth_controller.dart';

class CoursesController extends GetxController {
  final CourseUseCases useCases;
  late final AuthenticationController _authController;

  CoursesController({required this.useCases}) {
    _authController = Get.find<AuthenticationController>();
  }

  final RxList<Course> courses = <Course>[].obs;
  final RxBool loading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Se ejecuta cada vez que cambia el usuario logueado
    ever(_authController.currentUser, (user) {
      if (user != null) {
        loadCourses(); // Cargar cursos automáticamente
      } else {
        courses.clear(); // Limpiar lista si no hay usuario
      }
    });

    // Cargar cursos si ya hay usuario logueado al iniciar
    if (_authController.currentUser.value != null) {
      loadCourses();
    }
  }

  /// Carga los cursos del usuario logueado
  Future<void> loadCourses() async {
    final user = _authController.currentUser.value;
    if (user == null) {
      error.value = "Usuario no logueado";
      return;
    }

    try {
      loading.value = true;
      error.value = '';

      final result = await useCases.listCoursesByTeacher(user.id!);
      courses.assignAll(result);

      print("✅ Cursos cargados para el usuario ${user.name}: ${courses.map((c) => c.name).toList()}");
    } catch (e) {
      error.value = e.toString();
      print("❌ Error al cargar cursos: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> addCourse({
    required String name,
    required String code,
    required int maxStudents,
  }) async {
    final userId = _authController.currentUser.value?.id;
    if (userId == null) {
      error.value = "Usuario no logueado";
      return;
    }

    try {
      loading.value = true;
      error.value = '';

      final newCourse = await useCases.createCourse(
        name: name,
        code: code,
        teacherId: userId,
        maxStudents: maxStudents,
      );

      courses.add(newCourse);
      print("✅ Curso agregado: ${newCourse.name}");
    } catch (e) {
      error.value = e.toString();
      print("❌ Error al agregar curso: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateCourseInList(Course course) async {
    try {
      loading.value = true;
      error.value = '';

      final updated = await useCases.updateCourse(course);
      final index = courses.indexWhere((c) => c.id == updated.id);
      if (index != -1) {
        courses[index] = updated;
      }

      print("✅ Curso actualizado: ${updated.name}");
    } catch (e) {
      error.value = e.toString();
      print("❌ Error al actualizar curso: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteCourseFromList(int? id) async {
    if (id == null) return;

    try {
      loading.value = true;
      error.value = '';

      await useCases.deleteCourse(id);
      courses.removeWhere((c) => c.id == id);

      print("✅ Curso eliminado con id=$id");
    } catch (e) {
      error.value = e.toString();
      print("❌ Error al eliminar curso: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<bool> canCreateMore() async {
    final userId = _authController.currentUser.value?.id;
    if (userId == null) return false;

    try {
      return await useCases.canCreateMore(userId);
    } catch (e) {
      print("❌ Error al verificar si puede crear más cursos: $e");
      return false;
    }
  }
}
