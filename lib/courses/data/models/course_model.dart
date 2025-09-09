import '../../domain/entities/course.dart';

class CourseModel extends Course {
  CourseModel({
    int? id,
    required String name,
    required String code,
    required int teacherId,
    required int maxStudents,
    DateTime? createdAt,
  }) : super(
          id: id,
          name: name,
          code: code,
          teacherId: teacherId,
          maxStudents: maxStudents,
          createdAt: createdAt,
        );

  factory CourseModel.fromMap(Map<String, dynamic> m) {
    return CourseModel(
      id: m['id'] is int ? m['id'] as int : (m['id'] != null ? int.parse(m['id'].toString()) : null),
      name: m['name'] as String,
      code: m['code'] as String,
      teacherId: m['teacher_id'] is int ? m['teacher_id'] as int : int.parse(m['teacher_id'].toString()),
      maxStudents: m['max_students'] is int ? m['max_students'] as int : int.parse(m['max_students'].toString()),
      createdAt: m['created_at'] != null ? DateTime.parse(m['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'code': code,
      'teacher_id': teacherId,
      'max_students': maxStudents,
    };
    
    if (id != null) map['id'] = id;
    return map;
  }

  CourseModel copyWith({
    int? id,
    String? name,
    String? code,
    int? teacherId,
    int? maxStudents,
    DateTime? createdAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      teacherId: teacherId ?? this.teacherId,
      maxStudents: maxStudents ?? this.maxStudents,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}