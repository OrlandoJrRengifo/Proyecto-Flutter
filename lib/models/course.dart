// Modelo de datos para un curso
class Course {
  final String id;
  final String name;
  final String professorName;
  final String description;
  final List<String> enrolledUserIds;  

  const Course({
    required this.id,
    required this.name,
    required this.professorName,
    this.description = '',
    this.enrolledUserIds = const [],   
  });
}
