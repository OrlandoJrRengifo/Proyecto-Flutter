import 'package:get/get.dart';
import '../domain/entities/course.dart';
import '../domain/usecases/course_usecases.dart';

class CoursesController extends GetxController {
  final CourseUseCases useCases;
  
  CoursesController({required this.useCases});
  
  final RxList<Course> courses = <Course>[].obs;
  final RxBool loading = false.obs;
  final RxString error = ''.obs;
  
  // ID del usuario actual (de prueba por ahora, despues puede venir de auth)
  final int currentUserId = 1;
  
  Future<void> loadCourses() async {
    try {
      loading.value = true;
      error.value = '';
      
      final result = await useCases.listCoursesByTeacher(currentUserId);
      courses.assignAll(result);
      
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }
  
  Future<void> addCourse({
    required String name,
    required String code,
    required int maxStudents,
  }) async {
    try {
      loading.value = true;
      error.value = '';
      
      final newCourse = await useCases.createCourse(
        name: name,
        code: code,
        teacherId: currentUserId,
        maxStudents: maxStudents,
      );
      
      courses.add(newCourse);
      
    } catch (e) {
      error.value = e.toString();
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
      
      
    } catch (e) {
      error.value = e.toString();
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
      
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }
  Future<bool> canCreateMore() async {
    return await useCases.canCreateMore(currentUserId);
  }
}