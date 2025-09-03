import '../models/category_model.dart';

class InMemoryCategoryDataSource {
  final List<CategoryModel> _store = [];

  Future<CategoryModel> create(CategoryModel category) async {
    _store.add(category);
    return category;
  }

  Future<CategoryModel?> getById(String id) async {
    return _store.firstWhere((c) => c.id == id); //orElse: () => null);
  }

  Future<List<CategoryModel>> listByCourse(String courseId) async {
    return _store.where((c) => c.courseId == courseId).toList();
  }

  Future<CategoryModel> update(CategoryModel category) async {
    final idx = _store.indexWhere((c) => c.id == category.id);
    if (idx == -1) throw Exception('Category not found');
    _store[idx] = category;
    return category;
  }

  Future<void> delete(String id) async {
    _store.removeWhere((c) => c.id == id);
  }
}
