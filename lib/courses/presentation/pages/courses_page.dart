import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/course.dart';
import '../widgets/course_form_dialog.dart';
import '../../controllers/course_controller.dart';
import '../../../../categories/presentation/pages/categories_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late final CoursesController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CoursesController>();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Cursos"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text("Error: ${controller.error}"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadCourses(),
                  child: const Text("Reintentar"),
                ),
              ],
            ),
          );
        }
        
        if (controller.courses.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No tienes cursos creados",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  "Puedes crear hasta 3 cursos",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.courses.length,
          itemBuilder: (context, index) {
            final course = controller.courses[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    course.name.isNotEmpty ? course.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
                title: Text(
                  course.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text("Código: ${course.code}"),
                    Text("Cupos: ${course.maxStudents} estudiantes"),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await Get.dialog<bool>(
                      AlertDialog(
                        title: const Text("Eliminar curso"),
                        content: Text(
                          "¿Seguro que deseas eliminar '${course.name}'?\n\n"
                          "Esta acción también eliminará todas las categorías asociadas.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () => Get.back(result: true),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text("Eliminar"),
                          ),
                        ],
                      ),
                    );
                    
                    if (confirm == true) {
                      await controller.deleteCourseFromList(course.id);
                    }
                  },
                ),
                onTap: () {
                  // Navegar a las categorías de este curso
                  Get.to(
                    () => CategoriesPage(courseId: course.id!),
                    transition: Transition.rightToLeft,
                  );
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Verificar si puede crear más cursos
          final canCreate = await controller.canCreateMore();
          if (!canCreate) {
            Get.snackbar(
              "Límite alcanzado",
              "No puedes crear más de 3 cursos",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange[100],
              colorText: Colors.orange[800],
            );
            return;
          }

          final result = await Get.dialog<Course>(
            CourseFormDialog(),
          );
          
          log("📌 Dialog result = $result");
          
          if (result != null) {
            try {
              await controller.addCourse(
                name: result.name,
                code: result.code,
                maxStudents: result.maxStudents,
              );
              
              Get.snackbar(
                "¡Éxito!",
                "Curso '${result.name}' creado correctamente",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green[100],
                colorText: Colors.green[800],
              );
            } catch (e) {
              Get.snackbar(
                "Error",
                e.toString(),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red[100],
                colorText: Colors.red[800],
              );
            }
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Crear curso"),
      ),
    );
  }
}