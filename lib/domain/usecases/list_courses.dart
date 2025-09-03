import '../../models/course.dart';
import '../../data/repositories/course_repository_impl.dart';

class ListCourses {
final CourseRepositoryImpl repo;
ListCourses(this.repo);

Future<List<Course>> call() => repo.listCourses();
}
