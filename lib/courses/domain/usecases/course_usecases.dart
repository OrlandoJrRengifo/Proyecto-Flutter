import '../entities/course.dart';
import '../repositories/course_repository.dart';

class CourseUseCases {
  final CourseRepository repository;
  
  CourseUseCases(this.repository);

  Future<Course> createCourse({
    required String name,
    required String code,
    required int teacherId,
    required int maxStudents,
  }) async {
    // Limite de 3 cursos por usuario
    final currentCount = await repository.countByTeacher(teacherId);
    if (currentCount >= 3) {
      throw Exception('No es posible crear más de 3 cursos');
    }

    return repository.create(
      Course(
        name: name,
        code: code,
        teacherId: teacherId,
        maxStudents: maxStudents,
      ),
    );
  }

  Future<void> deleteCourse(int id) => repository.delete(id);
  
  Future<Course?> getCourse(int id) => repository.getById(id);
  
  Future<List<Course>> listCoursesByTeacher(int teacherId) => 
      repository.listByTeacher(teacherId);
  
  Future<Course> updateCourse(Course course) => repository.update(course);

  Future<bool> canCreateMore(int teacherId) async {
    final count = await repository.countByTeacher(teacherId);
    return count < 3;
  }
}
