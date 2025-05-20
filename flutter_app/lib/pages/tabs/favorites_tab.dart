import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Tämä välilehti näyttää käyttäjän tallentamat suosikkireseptit
class FavoritesTab extends StatefulWidget {
  final List<Map<String, dynamic>> favorites;
  final void Function(Map<String, dynamic>) onToggleFavorite;

  const FavoritesTab({Key? key, required this.favorites, required this.onToggleFavorite}) : super(key: key);

  @override
  _FavoritesTabState createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  String sortOption = 'Nimi';

  @override
  // Ladataan suosikkeihin tallennetut kuvat kun näkymä avautuu
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('favoriteImages');
    if (stored != null) {
      final Map<String, String> paths = Map<String, String>.from(jsonDecode(stored));
      setState(() {
        for (var recipe in widget.favorites) {
          final path = paths[recipe['name']];
          if (path != null) {
            recipe['imagePath'] = path;
          }
        }
      });
    }
  }

  // Tallennetaan jokaisen reseptin kuva SharedPreferencesiin
  Future<void> _saveImages() async {
    final prefs = await SharedPreferences.getInstance();
    final paths = <String, String>{};
    for (var recipe in widget.favorites) {
      if (recipe['imagePath'] != null) {
        paths[recipe['name']] = recipe['imagePath'];
      }
    }
    await prefs.setString('favoriteImages', jsonEncode(paths));
  }

  // Putoavalikko suosikkien järjestämiseen nimen tai ainesosien määrän mukaan
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
    // Järjestetään suosikit valitun vaihtoehdon mukaan
    List<Map<String, dynamic>> sortedFavorites = List.from(widget.favorites);
    if (sortOption == 'Nimi') {
      sortedFavorites.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
    } else if (sortOption == 'Ainesosien määrä') {
      sortedFavorites.sort((a, b) => (a['ingredients'] as List).length.compareTo((b['ingredients'] as List).length));
    }

    // Jos ei ole yhtään suosikkia, näytetään tyhjätila
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
              // Näytetään jokainen suosikki reseptikorttina
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: 
                  // Klikkaamalla korttia saa näkyviin reseptin tarkemmat tiedot
                  InkWell(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Jos reseptille on lisätty kuva, näytetään se kortin yläosassa
                      if (recipe['imagePath'] != null)
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.file(
                            File(recipe['imagePath']),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 160,
                          ),
                        ),
                      Padding(
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
                            SizedBox(height: 8),
                            // Nappi kuvan lisäämiseen, vaihtamiseen tai poistamiseen
                            if (recipe['imagePath'] == null)
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final picker = ImagePicker();
                                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    final path = pickedFile.path;
                                    setState(() {
                                      recipe['imagePath'] = path;
                                    });
                                    await _saveImages();
                                  }
                                },
                                icon: Icon(Icons.add_a_photo),
                                label: Text('Lisää kuva'),
                              )
                            else
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        final path = pickedFile.path;
                                        setState(() {
                                          recipe['imagePath'] = path;
                                        });
                                        await _saveImages();
                                      }
                                    },
                                    icon: Icon(Icons.image),
                                    label: Text('Vaihda kuva'),
                                  ),
                                  SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      setState(() {
                                        recipe['imagePath'] = null;
                                      });
                                      await _saveImages();
                                    },
                                    icon: Icon(Icons.delete),
                                    label: Text('Poista kuva'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
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