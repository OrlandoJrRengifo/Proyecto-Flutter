import './data/datasources/in_memory_category_datasource.dart';
import './data/repositories/category_repository_impl.dart';
import './domain/usecases/create_category.dart';
import './domain/usecases/list_categories.dart';
import './domain/usecases/get_category.dart';
import './domain/usecases/update_category.dart';
import './domain/usecases/delete_category.dart';
import './presentation/categories_cubit.dart';

final inMemoryDatasource = InMemoryCategoryDataSource();
final categoryRepository = CategoryRepositoryImpl(inMemoryDatasource);

// usecases
final createCategoryUC = CreateCategory(categoryRepository);
final listCategoriesUC = ListCategories(categoryRepository);
final getCategoryUC = GetCategory(categoryRepository);
final updateCategoryUC = UpdateCategory(categoryRepository);
final deleteCategoryUC = DeleteCategory(categoryRepository);

CategoriesCubit createCategoriesCubit() => CategoriesCubit(
  createCategory: createCategoryUC,
  listCategories: listCategoriesUC,
  getCategory: getCategoryUC,
  updateCategory: updateCategoryUC,
  deleteCategory: deleteCategoryUC,
);
