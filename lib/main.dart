import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'di.dart' as di;
import '/presentation/pages/categories_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String demoCourseId = 'Programcion Movil';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => di.createCategoriesCubit(),
        child: CategoriesPage(courseId: demoCourseId),
      ),
    );
  }
}
