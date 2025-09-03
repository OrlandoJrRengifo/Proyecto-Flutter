import '../entities/category.dart';
import '../repositories/category_repository.dart';

class CreateCategory {
  final CategoryRepository repository;
  CreateCategory(this.repository);

  Future<Category> call({
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
}
