import 'package:flutter/material.dart';

// Tämä on tekstikenttä, johon käyttäjä voi kirjoittaa uuden ainesosan
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
    // Tekstikenttä, jossa on lisäyspainike oikeassa reunassa
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Lisää ainesosa',
        suffixIcon: IconButton(
          icon: Icon(Icons.add),
          onPressed: onAdd,
        ),
      ),
      // Kun käyttäjä painaa enteriä, lisätään ainesosa
      onSubmitted: (_) => onAdd(),
    );
  }
}