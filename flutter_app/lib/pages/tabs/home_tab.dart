import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/ingredient_list.dart';

class HomeTab extends StatefulWidget {
  final List<Map<String, dynamic>> favorites;
  final void Function(Map<String, dynamic>) onAddFavorite;

  const HomeTab({Key? key, required this.favorites, required this.onAddFavorite}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> _ingredients = [];
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _suggestions = [];

  void _addIngredient() {
    final input = _controller.text.trim();
    if (input.isNotEmpty) {
      setState(() {
        _ingredients.add(input);
        _controller.clear();
      });
    }
  }

  Future<void> _getSuggestions() async {
    final url = Uri.parse('http://127.0.0.1:5000/generate');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ingredients': _ingredients}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List recipes = data['recipes'];

        setState(() {
          _suggestions = recipes.cast<Map<String, dynamic>>();
        });
      } else {
        setState(() {
          _suggestions = [
            {
              'name': 'Virhe',
              'ingredients': [],
              'instructions': ['Virhe haettaessa reseptiä.']
            }
          ];
        });
      }
    } catch (e) {
      setState(() {
        _suggestions = [
          {
            'name': 'Yhteysvirhe',
            'ingredients': [],
            'instructions': ['Yhteys epäonnistui: $e']
          }
        ];
      });
    }
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
            child: ListView.builder(
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final recipe = _suggestions[index];
                if (recipe['name'] == 'Virhe' || recipe['name'] == 'Yhteysvirhe') {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe['name'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red),
                          ),
                          SizedBox(height: 8),
                          Text('Ainekset:', style: Theme.of(context).textTheme.bodyMedium),
                          Text(''),
                          SizedBox(height: 4),
                          Text('Ohjeet:', style: Theme.of(context).textTheme.bodyMedium),
                          Text((recipe['instructions'] as List).join('\n'), style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  );
                }
                final isFavorite = widget.favorites.any((fav) => fav['name'] == recipe['name']);

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              recipe['name'],
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (isFavorite) {
                                    widget.onAddFavorite({
                                      ...recipe,
                                      'remove': true,
                                    });
                                  } else {
                                    widget.onAddFavorite(recipe);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('Ainekset: ${recipe['ingredients'].join(', ')}'),
                        SizedBox(height: 4),
                        Text('Ohjeet:\n${(recipe['instructions'] as List).join('\n')}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
