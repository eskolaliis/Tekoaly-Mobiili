import 'package:flutter/material.dart';

class FavoritesTab extends StatelessWidget {
  final List<Map<String, dynamic>> favorites;
  final void Function(Map<String, dynamic>) onToggleFavorite;

  const FavoritesTab({Key? key, required this.favorites, required this.onToggleFavorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Ei vielä suosikkeja',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tallenna reseptejä etusivulta ❤',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final recipe = favorites[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(recipe['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => onToggleFavorite(recipe),
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
    );
  }
}