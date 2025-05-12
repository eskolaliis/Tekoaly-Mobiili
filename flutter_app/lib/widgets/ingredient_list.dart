import 'package:flutter/material.dart';

class IngredientList extends StatelessWidget {
  final List<String> ingredients;
  final void Function(String) onRemove;

  const IngredientList({
    Key? key,
    required this.ingredients,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: ingredients.map((ingredient) {
        return Chip(
          label: Text(ingredient),
          deleteIcon: Icon(Icons.close),
          onDeleted: () => onRemove(ingredient),
        );
      }).toList(),
    );
  }
}
