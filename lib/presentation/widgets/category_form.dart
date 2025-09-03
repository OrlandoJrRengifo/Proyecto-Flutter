import 'package:flutter/material.dart';
import '../../../domain/entities/category.dart';

class CategoryFormDialog extends StatefulWidget {
  final Category? category;
  final String? courseId;
  const CategoryFormDialog({this.category, this.courseId, Key? key}) : super(key: key);

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
    _maxMembers = TextEditingController(text: (widget.category?.maxMembers ?? 2).toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? 'Crear categoría' : 'Editar categoría'),
      content: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(controller: _name, decoration: InputDecoration(labelText: 'Nombre')),
          DropdownButtonFormField<GroupingMethod>(
            value: _method,
            items: GroupingMethod.values
                .map((g) => DropdownMenuItem(value: g, child: Text(g.toString().split('.').last)))
                .toList(),
            onChanged: (v) => setState(() => _method = v!),
            decoration: InputDecoration(labelText: 'Método'),
          ),
          TextFormField(
            controller: _maxMembers,
            decoration: InputDecoration(labelText: 'Miembros máximos (X)'),
            keyboardType: TextInputType.number,
            validator: (v) => (int.tryParse(v ?? '') ?? 0) > 0 ? null : 'Mayor que 0',
          ),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final cat = Category(
                id: widget.category?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                courseId: widget.category?.courseId ?? widget.courseId ?? 'unknown',
                name: _name.text,
                groupingMethod: _method,
                maxMembers: int.parse(_maxMembers.text),
              );
              Navigator.of(context).pop(cat);
            }
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
