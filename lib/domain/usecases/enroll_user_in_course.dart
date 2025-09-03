import '../../data/repositories/course_repository_impl.dart';

class EnrollUserInCourse {
final CourseRepositoryImpl repo;
EnrollUserInCourse(this.repo);

Future<void> call(String courseId, String userId) => repo.enrollUser(courseId, userId);
}
