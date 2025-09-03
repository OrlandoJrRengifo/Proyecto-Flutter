import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'di.dart';

import 'presentation/courses_cubit.dart';
import 'presentation/pages/courses_page.dart';

void main() {
  initDependencies(); // inicializa dependencias
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: BlocProvider<CoursesCubit>( 
        create: (_) => sl<CoursesCubit>()..load(),
        child: const CoursesPage(),
      ),
    );
  }
}
