import 'package:get/get.dart';
import '../../categories/domain/entities/category.dart';
import '../../categories/domain/usecases/category_usecases.dart';

class CategoriesController extends GetxController {
  final CategoryUseCases useCases;

  CategoriesController({required this.useCases});

  final categories = <Category>[].obs;
  final loading = false.obs;
  final error = ''.obs;

  Future<void> load(String courseId) async {
    try {
      loading.value = true;
      error.value = '';
      final list = await useCases.listCategories(courseId);
      categories.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

Future<void> addCategory({
  required String courseId,
  required String name,
  required GroupingMethod groupingMethod,
  required int maxMembers,
}) async {
  try {
    final created = await useCases.createCategory(
      courseId: courseId,
      name: name,
      groupingMethod: groupingMethod,
      maxMembers: maxMembers,
    );
    categories.add(created);
  } catch (e) {
    error.value = e.toString();
  }
}

  Future<void> updateCategoryInList(Category category) async {
    try {
      final updated = await useCases.updateCategory(category);
      final index = categories.indexWhere((c) => c.id == updated.id);
      if (index != -1) {
        categories[index] = updated;
        categories.refresh();
      }
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> deleteCategoryFromList(String id) async {
    try {
      await useCases.deleteCategory(id);
      categories.removeWhere((c) => c.id == id);
    } catch (e) {
      error.value = e.toString();
    }
  }
}
