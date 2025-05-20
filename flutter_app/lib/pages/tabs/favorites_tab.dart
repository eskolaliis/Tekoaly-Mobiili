import 'package:flutter/material.dart';

class FavoritesTab extends StatefulWidget {
  final List<Map<String, dynamic>> favorites;
  final void Function(Map<String, dynamic>) onToggleFavorite;

  const FavoritesTab({Key? key, required this.favorites, required this.onToggleFavorite}) : super(key: key);

  @override
  _FavoritesTabState createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  String sortOption = 'Nimi';

  Widget _buildSortDropdown(void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: DropdownButton<String>(
        value: sortOption,
        items: ['Nimi', 'Ainesosien määrä']
            .map((s) => DropdownMenuItem(value: s, child: Text('Järjestä: $s')))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sortedFavorites = List.from(widget.favorites);
    if (sortOption == 'Nimi') {
      sortedFavorites.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
    } else if (sortOption == 'Ainesosien määrä') {
      sortedFavorites.sort((a, b) => (a['ingredients'] as List).length.compareTo((b['ingredients'] as List).length));
    }

    if (sortedFavorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Ei vielä suosikkeja',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Tallenna reseptejä etusivulta ❤',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _buildSortDropdown((value) {
          if (value != null) {
            setState(() {
              sortOption = value;
            });
          }
        }),
        Expanded(
          child: ListView.builder(
            itemCount: sortedFavorites.length,
            itemBuilder: (context, index) {
              final recipe = sortedFavorites[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(recipe['name']),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ainekset:', style: Theme.of(context).textTheme.titleSmall),
                              Text(recipe['ingredients'].join(', '), style: Theme.of(context).textTheme.bodyMedium),
                              SizedBox(height: 8),
                              Text('Ohjeet:', style: Theme.of(context).textTheme.titleSmall),
                              Text((recipe['instructions'] as List).join('\n'), style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          )
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(recipe['name'], style: Theme.of(context).textTheme.titleMedium),
                            IconButton(
                              icon: Icon(Icons.favorite, color: Colors.red),
                              tooltip: 'Poista suosikeista',
                              onPressed: () => widget.onToggleFavorite(recipe),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('Ainekset: ${recipe['ingredients'].join(', ')}', style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 4),
                        Text('Ohjeet:\n${(recipe['instructions'] as List).join('\n')}', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}