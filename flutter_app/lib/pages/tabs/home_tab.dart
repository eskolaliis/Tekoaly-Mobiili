import 'package:flutter/material.dart';
import '../../widgets/ingredient_list.dart';
import '../../widgets/suggestion_list.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> _ingredients = [];
  final TextEditingController _controller = TextEditingController();
  List<String> _suggestions = [];

  void _addIngredient() {
    final input = _controller.text.trim();
    if (input.isNotEmpty) {
      setState(() {
        _ingredients.add(input);
        _controller.clear();
      });
    }
  }

  void _getSuggestions() {
    // Tämä on mockup. Korvataan backend-kutsulla myöhemmin.
    setState(() {
      _suggestions = [
        "Pikapasta munalla ja juustolla",
        "Kasviswokki riisillä",
        "Paistettu leipäjuusto ja salaatti"
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Lisää ainesosa',
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: _addIngredient,
              ),
            ),
            onSubmitted: (_) => _addIngredient(),
          ),
          SizedBox(height: 10),
          IngredientList(
            ingredients: _ingredients,
            onRemove: (ingredient) {
              setState(() {
                _ingredients.remove(ingredient);
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _getSuggestions,
            child: Text('Ehdota reseptejä'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SuggestionList(suggestions: _suggestions),
          )
        ],
      ),
    );
  }
}
