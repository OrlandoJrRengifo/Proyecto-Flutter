import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../categories/domain/entities/category.dart';

class CategoryFormDialog extends StatefulWidget {
  final Category? category;
  final String courseId;

  const CategoryFormDialog({
    this.category,
    required this.courseId,
    Key? key,
  }) : super(key: key);

  @override
  _CategoryFormDialogState createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  GroupingMethod _method = GroupingMethod.random;
  late TextEditingController _maxMembers;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.category?.name ?? '');
    _method = widget.category?.groupingMethod ?? GroupingMethod.random;
    _maxMembers =
        TextEditingController(text: (widget.category?.maxMembers ?? 2).toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? 'Crear categoría' : 'Editar categoría'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
            ),
            DropdownButtonFormField<GroupingMethod>(
              value: _method,
              items: GroupingMethod.values
                  .map((g) => DropdownMenuItem(
                        value: g,
                        child: Text(g.toString().split('.').last),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _method = v!),
              decoration: const InputDecoration(labelText: 'Método'),
            ),
            TextFormField(
              controller: _maxMembers,
              decoration: const InputDecoration(labelText: 'Miembros máximos (X)'),
              keyboardType: TextInputType.number,
              validator: (v) =>
                  (int.tryParse(v ?? '') ?? 0) > 0 ? null : 'Mayor que 0',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final cat = Category(
                id: widget.category?.id ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                courseId: widget.category?.courseId ?? widget.courseId,
                name: _name.text,
                groupingMethod: _method,
                maxMembers: int.parse(_maxMembers.text),
              );
              Get.back(result: cat);
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
