import 'package:flutter/material.dart';


class SettingsTab extends StatelessWidget {
  final VoidCallback onClearFavorites;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsTab({
    Key? key,
    required this.onClearFavorites,
    required this.isDarkMode,
    required this.onThemeChanged,
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
          Text(
            'Versio 1.0',
            style: TextStyle(fontSize: 14),
          ),
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
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onClearFavorites,
            icon: Icon(Icons.delete),
            label: Text('Tyhjennä suosikit'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}