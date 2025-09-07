import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/category.dart';
import '/categories/controllers/categories_controller.dart';
import '/categories/presentation/widgets/category_form.dart'; 

class CategoriesPage extends StatelessWidget {
  final String courseId;
  const CategoriesPage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoriesController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Categorías")),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.isNotEmpty) {
          return Center(child: Text("Error: ${controller.error}"));
        }
        if (controller.categories.isEmpty) {
          return const Center(child: Text("No hay categorías"));
        }
        return ListView.builder(
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final cat = controller.categories[index];
           return ListTile(
              title: Text(cat.name),
              subtitle: Text("Max: ${cat.maxMembers}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Get.dialog<Category>(
                        CategoryFormDialog(
                          courseId: courseId,
                          category: cat,
                        ),
                      );
                      if (result != null) {
                        controller.updateCategoryInList(result);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await Get.dialog<bool>(
                        AlertDialog(
                          title: const Text("Eliminar"),
                          content: Text("¿Seguro que deseas eliminar '${cat.name}'?"),
                          actions: [
                            TextButton(onPressed: () => Get.back(result: false), child: const Text("Cancelar")),
                            TextButton(onPressed: () => Get.back(result: true), child: const Text("Eliminar")),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        controller.deleteCategoryFromList(cat.id);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.dialog<Category>(
            CategoryFormDialog(courseId: courseId),
          );
          if (result != null) {
            controller.addCategory(
              courseId: result.courseId,
              name: result.name,
              groupingMethod: result.groupingMethod,
              maxMembers: result.maxMembers,
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
