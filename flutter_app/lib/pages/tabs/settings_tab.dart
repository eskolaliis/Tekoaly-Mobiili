import 'package:flutter/material.dart';


class SettingsTab extends StatelessWidget {
  final VoidCallback onClearFavorites;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final bool hasFavorites;

  const SettingsTab({
    Key? key,
    required this.onClearFavorites,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.hasFavorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _showHelpDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Käyttöohjeet'),
          content: Text(
            '1. Syötä ainesosia etusivulla\n'
            '2. Paina "Ehdota reseptejä"\n'
            '3. Lisää reseptejä suosikkeihin ❤️\n'
            '4. Katso suosikit omalla välilehdellä\n'
            '5. Tyhjennä suosikit asetuksista tarvittaessa',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          SwitchListTile(
            title: Text('Tumma tila'),
            value: isDarkMode,
            onChanged: onThemeChanged,
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _showHelpDialog(context),
            icon: Icon(Icons.help_outline),
            label: Text('Näytä käyttöohjeet'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueGrey,
              minimumSize: Size.fromHeight(48),
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Tyhjennä suosikit'),
                  content: Text(
                    hasFavorites
                        ? 'Haluatko varmasti poistaa kaikki suosikit?'
                        : 'Ei suosikkeja poistettavaksi.',
                  ),
                  actions: [
                    if (hasFavorites)
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onClearFavorites();
                        },
                        child: Text('Kyllä'),
                      ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.delete),
            label: Text('Tyhjennä suosikit'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              minimumSize: Size.fromHeight(48),
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Ruokainspiraattori'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Versio 1.0'),
                      SizedBox(height: 8),
                      Text('Tämä on opiskelijaprojekti. Kaikki tiedot tallennetaan paikallisesti.'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.info_outline),
            label: Text('Tietoa sovelluksesta'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigo,
              minimumSize: Size.fromHeight(48),
            ),
          ),
          SizedBox(height: 32),
          Center(
            child: Text(
              'Versio 1.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}