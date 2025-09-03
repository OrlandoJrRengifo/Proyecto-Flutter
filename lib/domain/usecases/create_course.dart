import '../../models/course.dart';
import '../../data/repositories/course_repository_impl.dart';

class CreateCourse {
final CourseRepositoryImpl repo;
CreateCourse(this.repo);

Future<Course> call(Course course) => repo.createCourse(course);
}
