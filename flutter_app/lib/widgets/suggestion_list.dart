import 'package:flutter/material.dart';

// Tämä widget näyttää listan ehdotetuista resepteistä
class SuggestionList extends StatelessWidget {
  final List<String> suggestions;

  const SuggestionList({
    Key? key,
    required this.suggestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Jos ei ole yhtään ehdotusta, näytetään viesti
    if (suggestions.isEmpty) {
      return Center(
        child: Text(
          'Ei ehdotuksia vielä',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Muuten näytetään kaikki ehdotukset listana
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        // Yksi rivi: kuvake ja ehdotuksen nimi
        return ListTile(
          leading: Icon(Icons.restaurant_menu),
          title: Text(suggestions[index]),
        );
      },
    );
  }
}
