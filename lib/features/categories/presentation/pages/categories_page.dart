import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/category.dart';
import '../../controllers/categories_controller.dart';
import '../widgets/category_form.dart'; 

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
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final result = await Get.dialog<Category>(
                    CategoryFormDialog(
                      courseId: courseId,
                      category: cat, 
                    ),
                  );
                  if (result != null) {
                    controller.updateCategory(result);
                  }
                },
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
            controller.addCategory(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
