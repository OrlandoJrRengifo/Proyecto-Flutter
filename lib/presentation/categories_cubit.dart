import 'package:bloc/bloc.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/create_category.dart';
import '../../domain/usecases/list_categories.dart';
import '../../domain/usecases/get_category.dart';
import '../../domain/usecases/update_category.dart';
import '../../domain/usecases/delete_category.dart';

class CategoriesState {
  final List<Category> categories;
  final bool loading;
  final String? error;
  CategoriesState({required this.categories, this.loading = false, this.error});
  CategoriesState copyWith({List<Category>? categories, bool? loading, String? error}) {
    return CategoriesState(
      categories: categories ?? this.categories,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class CategoriesCubit extends Cubit<CategoriesState> {
  final CreateCategory createCategory;
  final ListCategories listCategories;
  final GetCategory getCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;

  CategoriesCubit({
    required this.createCategory,
    required this.listCategories,
    required this.getCategory,
    required this.updateCategory,
    required this.deleteCategory,
  }) : super(CategoriesState(categories: []));

  Future<void> load(String courseId) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final list = await listCategories(courseId);
      emit(state.copyWith(categories: list, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> create({
    required String courseId,
    required String name,
    required GroupingMethod groupingMethod,
    required int maxMembers,
  }) async {
    try {
      await createCategory(
        courseId: courseId,
        name: name,
        groupingMethod: groupingMethod,
        maxMembers: maxMembers,
      );
      await load(courseId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> update(Category category) async {
    try {
      await updateCategory(category);
      await load(category.courseId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> delete(String id, String courseId) async {
    try {
      await deleteCategory(id);
      await load(courseId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
