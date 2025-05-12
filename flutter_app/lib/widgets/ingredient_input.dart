

import 'package:flutter/material.dart';

class IngredientInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const IngredientInput({
    Key? key,
    required this.controller,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Lisää ainesosa',
        suffixIcon: IconButton(
          icon: Icon(Icons.add),
          onPressed: onAdd,
        ),
      ),
      onSubmitted: (_) => onAdd(),
    );
  }
}