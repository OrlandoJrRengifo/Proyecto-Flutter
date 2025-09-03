import '../../models/course.dart';

class InMemoryCourseDataSource {
final List<Course> _store = [];

Future<List<Course>> listAll() async => _store;

Future<Course> create(Course course) async {
    _store.add(course);
    return course;
}

Future<Course?> getById(String id) async {
    try {
    return _store.firstWhere((c) => c.id == id);
    } catch (_) {
    return null;
    }
}

Future<Course> update(Course course) async {
    final idx = _store.indexWhere((c) => c.id == course.id);
    if (idx == -1) throw Exception('Course not found');
    _store[idx] = course;
    return course;
}

Future<void> delete(String id) async {
    _store.removeWhere((c) => c.id == id);
}

Future<void> enrollUser(String courseId, String userId) async {
    final course = await getById(courseId);
    if (course == null) throw Exception('Course not found');
    if (!course.enrolledUserIds.contains(userId)) {
    course.enrolledUserIds.add(userId);
    }
}
}
