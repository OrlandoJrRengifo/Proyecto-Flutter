import 'package:bloc/bloc.dart';
import '../models/course.dart';
import '../domain/usecases/create_course.dart';
import '../domain/usecases/list_courses.dart';
import '../domain/usecases/enroll_user_in_course.dart';

class CoursesState {
final List<Course> courses;
final bool loading;
final String? error;

CoursesState({
    required this.courses,
    this.loading = false,
    this.error,
});

CoursesState copyWith({
    List<Course>? courses,
    bool? loading,
    String? error,
}) {
    return CoursesState(
    courses: courses ?? this.courses,
    loading: loading ?? this.loading,
    error: error,
    );
}
}

class CoursesCubit extends Cubit<CoursesState> {
final CreateCourse createCourseUC;
final ListCourses listCoursesUC;
final EnrollUserInCourse enrollUC;

CoursesCubit({
    required this.createCourseUC,
    required this.listCoursesUC,
    required this.enrollUC,
}) : super(CoursesState(courses: []));

Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    try {
    final list = await listCoursesUC();
    emit(state.copyWith(courses: list, loading: false));
    } catch (e) {
    emit(state.copyWith(loading: false, error: e.toString()));
    }
}

Future<void> addCourse(Course c) async {
    try {
    await createCourseUC(c);
    await load();
    } catch (e) {
    emit(state.copyWith(error: e.toString()));
    }
}

Future<void> enroll(String courseId, String userId) async {
    try {
    await enrollUC(courseId, userId);
    await load();
    } catch (e) {
    emit(state.copyWith(error: e.toString()));
    }
}
}
