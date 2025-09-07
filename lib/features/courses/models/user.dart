// Modelo de datos para un usuario

import 'course.dart';

abstract class User {
  const User({required this.id, required this.name, required this.email});

  final String id;
  final String name;
  final String email;
}

class Student extends User {
  const Student({
    required super.id,
    required super.name,
    required super.email,
    required this.enrolledCourses,
  });

  final List<CourseEnrollment> enrolledCourses;
}

class Professor extends User {
  const Professor({
    required super.id,
    required super.name,
    required super.email,
    required this.teachingCourses,
  });

  final List<Course> teachingCourses;
}

class CourseEnrollment {
  const CourseEnrollment({required this.course, required this.progress});

  final Course course;
  final int
  progress; // Progreso del 0 al 100 para representar el avance del estudiante con la barra de progreso
}
