import '../entities/category.dart';
import '../repositories/category_repository.dart';

class UpdateCategory {
  final CategoryRepository repository;
  UpdateCategory(this.repository);

  Future<Category> call(Category category) {
    return repository.update(category);
  }
}
