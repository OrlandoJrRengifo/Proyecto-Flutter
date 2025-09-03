import '../entities/category.dart';
import '../repositories/category_repository.dart';

class ListCategories {
  final CategoryRepository repository;
  ListCategories(this.repository);

  Future<List<Category>> call(String courseId) {
    return repository.listByCourse(courseId);
  }
}
