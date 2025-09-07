import '../entities/category.dart';
import '../repositories/category_repository.dart';
import 'dart:math';

class CategoryUseCases {
  final CategoryRepository repository;

  CategoryUseCases(this.repository);

  Future<Category> createCategory({
    required String courseId,
    required String name,
    required GroupingMethod groupingMethod,
    required int maxMembers,
  }) async {
    final category = Category(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      courseId: courseId,
      name: name,
      groupingMethod: groupingMethod,
      maxMembers: maxMembers,
    );
    return repository.create(category);
  }

  Future<void> deleteCategory(String id) => repository.delete(id);

  Future<Category?> getCategory(String id) => repository.getById(id);

  Future<List<Category>> listCategories(String courseId) =>
      repository.listByCourse(courseId);

  Future<Category> updateCategory(Category category) =>
      repository.update(category);

  Future<List<List<String>>> formRandomGroups(
      String categoryId, List<String> students) async {
    final cat = await repository.getById(categoryId);
    if (cat == null) return [];

    final rng = Random();
    final shuffled = List<String>.from(students)..shuffle(rng);
    final groups = <List<String>>[];

    int i = 0;
    while (i < shuffled.length) {
      final end = (i + cat.maxMembers).clamp(0, shuffled.length);
      groups.add(shuffled.sublist(i, end));
      i = end;
    }
    return groups;
  }
}
