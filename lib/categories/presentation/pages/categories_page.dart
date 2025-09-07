import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/category.dart';
import '/categories/controllers/categories_controller.dart';
import '../widgets/category_form.dart';

class CategoriesPage extends StatefulWidget {
  final int courseId;
  const CategoriesPage({super.key, required this.courseId});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late final CategoriesController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CategoriesController>();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadCategories(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
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
              subtitle: Text(
                "Max: ${cat.maxGroupSize ?? '-'} • Método: ${cat.groupingMethod.toString().split('.').last}",
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Get.dialog<Category>(
                        CategoryFormDialog(
                          courseId: widget.courseId,
                          category: cat,
                        ),
                      );
                      
                      if (result != null) {
                        await controller.updateCategoryInList(result);
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
                            TextButton(
                              onPressed: () => Get.back(result: false),
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () => Get.back(result: true),
                              child: const Text("Eliminar"),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirm == true) {
                        await controller.deleteCategoryFromList(cat.id);
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
            CategoryFormDialog(courseId: widget.courseId),
          );
          if (result != null) {
            await controller.addCategory(
              courseId: result.courseId,
              name: result.name,
              groupingMethod: result.groupingMethod,
              maxMembers: result.maxGroupSize ?? 1,
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}