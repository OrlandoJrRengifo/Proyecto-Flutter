import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    int? id,
    required int courseId,
    required String name,
    required GroupingMethod groupingMethod,
    int? maxGroupSize,
    DateTime? createdAt,
  }) : super(
          id: id,
          courseId: courseId,
          name: name,
          groupingMethod: groupingMethod,
          maxGroupSize: maxGroupSize,
          createdAt: createdAt,
        );

  factory CategoryModel.fromMap(Map<String, dynamic> m) {
    return CategoryModel(
      id: m['id'] is int ? m['id'] as int : (m['id'] != null ? int.parse(m['id'].toString()) : null),
      courseId: m['courseId'] is int ? m['courseId'] as int : int.parse(m['courseId'].toString()),
      name: m['name'] as String,
      groupingMethod: (m['grouping_method'] as String?) == 'random' 
          ? GroupingMethod.random 
          : GroupingMethod.selfAssigned,
      maxGroupSize: m['max_group_size'] != null ? (m['max_group_size'] as int?) : null,
      createdAt: m['created_at'] != null ? DateTime.parse(m['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'courseId': courseId,
      'name': name,
      'grouping_method': groupingMethod == GroupingMethod.random ? 'random' : 'self_assigned',
      'max_group_size': maxGroupSize,
    };
    
    if (id != null) map['id'] = id;
    return map;
  }

  CategoryModel copyWith({
    int? id,
    int? courseId,
    String? name,
    GroupingMethod? groupingMethod,
    int? maxGroupSize,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      name: name ?? this.name,
      groupingMethod: groupingMethod ?? this.groupingMethod,
      maxGroupSize: maxGroupSize ?? this.maxGroupSize,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}