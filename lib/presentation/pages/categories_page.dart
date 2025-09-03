import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../categories_cubit.dart';
import '../widgets/category_form.dart';
import '../../../domain/entities/category.dart';

class CategoriesPage extends StatelessWidget {
  final String courseId;
  const CategoriesPage({required this.courseId, Key? key}) : super(key: key); //se le pasa por codigo desde el main

  @override
  Widget build(BuildContext context) {
    context.read<CategoriesCubit>().load(courseId);

    return Scaffold(
      appBar: AppBar(title: Text('Categorias')),
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state.loading) return Center(child: CircularProgressIndicator());
          return ListView(
            children: [
              for (final c in state.categories)
                ListTile(
                  title: Text(c.name),
                  subtitle: Text('${c.groupingMethod} • ${c.maxMembers}'),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        final updated = await showDialog<Category>(
                            context: context,
                            builder: (_) => CategoryFormDialog(category: c));
                        if (updated != null) {
                          await context.read<CategoriesCubit>().update(updated);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => context.read<CategoriesCubit>().delete(c.id, courseId),
                    ),
                  ]),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCat = await showDialog<Category?>(
              context: context, builder: (_) => CategoryFormDialog(courseId: courseId));
          if (newCat != null) {
            await context.read<CategoriesCubit>().create(
                  courseId: newCat.courseId,
                  name: newCat.name,
                  groupingMethod: newCat.groupingMethod,
                  maxMembers: newCat.maxMembers,
                );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
