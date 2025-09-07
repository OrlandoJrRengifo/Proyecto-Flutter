import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategory {
  final CategoryRepository repository;
  GetCategory(this.repository);

  Future<Category?> call(String id) {
    return repository.getById(id);
  }
}
