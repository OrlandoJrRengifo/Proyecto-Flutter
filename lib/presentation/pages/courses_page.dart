import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/course.dart';
import '../courses_cubit.dart';

class CoursesPage extends StatelessWidget {
const CoursesPage({super.key});

@override
Widget build(BuildContext context) {
    final cubit = context.read<CoursesCubit>();

    return Scaffold(
    appBar: AppBar(title: const Text('Cursos')),
    body: BlocBuilder<CoursesCubit, CoursesState>(
        builder: (_, state) {
        if (state.loading) return const Center(child: CircularProgressIndicator());
        if (state.error != null) return Center(child: Text('Error: ${state.error}'));
        if (state.courses.isEmpty) return const Center(child: Text('No hay cursos'));

        return ListView.builder(
            itemCount: state.courses.length,
            itemBuilder: (_, i) {
            final c = state.courses[i];
            return ListTile(
                title: Text(c.name),
                subtitle: Text('Inscritos: ${c.enrolledUserIds.length}'),
                onTap: () => cubit.enroll(c.id, 'user_demo_123'),
            );
            },
        );
        },
    ),
    floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
        final now = DateTime.now().millisecondsSinceEpoch.toString();
        cubit.addCourse(Course(
            id: now,
            name: 'Curso $now',
            professorName: 'Profesor Demo', // <-- requerido por tu modelo
            description: '',
            enrolledUserIds: const [],       // <-- si lo agregaste al modelo
        ));
        },
    ),
    );
}
}
