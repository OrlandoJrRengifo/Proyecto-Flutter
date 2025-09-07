import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.id,
    required super.courseId,
    required super.name,
    required super.groupingMethod,
    required super.maxMembers,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> m) {
    return CategoryModel(
      id: m['id'] as String,
      courseId: m['courseId'] as String,
      name: m['name'] as String,
      groupingMethod: m['groupingMethod'] == 'random'
          ? GroupingMethod.random
          : GroupingMethod.selfAssigned,
      maxMembers: m['maxMembers'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'name': name,
      'groupingMethod': groupingMethod == GroupingMethod.random ? 'random' : 'selfAssigned',
      'maxMembers': maxMembers,
    };
  }
}
