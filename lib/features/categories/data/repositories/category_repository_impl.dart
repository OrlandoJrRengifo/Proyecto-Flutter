import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/in_memory_category_datasource.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final InMemoryCategoryDataSource datasource;
  CategoryRepositoryImpl(this.datasource);

  @override
  Future<Category> create(Category category) async {
    final model = CategoryModel(
      id: category.id,
      courseId: category.courseId,
      name: category.name,
      groupingMethod: category.groupingMethod,
      maxMembers: category.maxMembers,
    );
    return datasource.create(model);
  }

  @override
  Future<void> delete(String id) => datasource.delete(id);

  @override
  Future<Category?> getById(String id) => datasource.getById(id);

  @override
  Future<List<Category>> listByCourse(String courseId) async {
    final list = await datasource.listByCourse(courseId);
    return list;
  }

  @override
  Future<Category> update(Category category) async {
    final model = CategoryModel(
      id: category.id,
      courseId: category.courseId,
      name: category.name,
      groupingMethod: category.groupingMethod,
      maxMembers: category.maxMembers,
    );
    return datasource.update(model);
  }
}
