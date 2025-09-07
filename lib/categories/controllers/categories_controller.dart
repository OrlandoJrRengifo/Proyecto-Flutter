import 'package:get/get.dart';
import '/categories/domain/entities/category.dart';
import '/categories/domain/usecases/create_category.dart';
import '/categories/domain/usecases/list_categories.dart';
import '/categories/domain/usecases/get_category.dart';
import '/categories/domain/usecases/update_category.dart';
import '/categories/domain/usecases/delete_category.dart';

class CategoriesController extends GetxController {
  final CreateCategory createCategory;
  final ListCategories listCategories;
  final GetCategory getCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;

  CategoriesController({
    required this.createCategory,
    required this.listCategories,
    required this.getCategory,
    required this.updateCategory,
    required this.deleteCategory,
  });

  // Estado observable
  var categories = <Category>[].obs;
  var loading = false.obs;
  var error = ''.obs;

  //carga todas las categorías desde el backend
  Future<void> load(String courseId) async {
    try {
      loading.value = true;
      error.value = '';
      final list = await listCategories(courseId);
      categories.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      final created = await createCategory(category);
      categories.add(created);
    } catch (e) {
      error.value = e.toString();
    }
  }
}
