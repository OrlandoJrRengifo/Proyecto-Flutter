// Modelo de datos para un curso

class Course {
  const Course({
    required this.id,
    required this.name,
    required this.professorName,
    this.description = '',
  });

  final String id;
  final String name;
  final String professorName;
  final String description;
}
