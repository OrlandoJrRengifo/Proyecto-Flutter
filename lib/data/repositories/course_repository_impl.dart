import '../../models/course.dart';
import '../datasources/in_memory_course_datasource.dart';

class CourseRepositoryImpl {
final InMemoryCourseDataSource dataSource;
CourseRepositoryImpl(this.dataSource);

Future<List<Course>> listCourses() => dataSource.listAll();
Future<Course?> getCourse(String id) => dataSource.getById(id);
Future<Course> createCourse(Course c) => dataSource.create(c);
Future<Course> updateCourse(Course c) => dataSource.update(c);
Future<void> deleteCourse(String id) => dataSource.delete(id);
Future<void> enrollUser(String courseId, String userId) =>
    dataSource.enrollUser(courseId, userId);
}
