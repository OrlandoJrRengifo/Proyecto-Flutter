import '../repositories/category_repository.dart';
import 'dart:math';

class FormRandomGroups {
  final CategoryRepository repository;
  FormRandomGroups(this.repository);

  /// students: lista de ids de alumnos
  Future<List<List<String>>> call(String categoryId, List<String> students) async {
    final cat = await repository.getById(categoryId);
    if (cat == null) return [];

    final rng = Random();
    final shuffled = List<String>.from(students)..shuffle(rng);
    final List<List<String>> groups = [];

    int i = 0;
    while (i < shuffled.length) {
      final end = (i + cat.maxMembers).clamp(0, shuffled.length);
      groups.add(shuffled.sublist(i, end));
      i = end;
    }
    return groups;
  }
}
