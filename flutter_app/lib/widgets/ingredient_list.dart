import 'package:flutter/material.dart';

// Tämä widget näyttää kaikki lisätyt ainesosat pieninä chippeinä
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
    // Asetellaan chipit vierekkäin ja tarvittaessa rivitetään
    return Wrap(
      spacing: 8,
      children: ingredients.map((ingredient) {
        // Jokainen ainesosa on oma chip, jossa on poistopainike (X)
        return Chip(
          label: Text(ingredient),
          deleteIcon: Icon(Icons.close),
          onDeleted: () => onRemove(ingredient),
        );
      }).toList(),
    );
  }
}
