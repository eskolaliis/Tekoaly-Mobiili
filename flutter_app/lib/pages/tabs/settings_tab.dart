import 'package:flutter/material.dart';


class SettingsTab extends StatelessWidget {
  final VoidCallback onClearFavorites;

  const SettingsTab({Key? key, required this.onClearFavorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 80, color: Colors.blueGrey),
          SizedBox(height: 16),
          Text(
            'Ruokainspiraattori',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Versio 1.0\n\nTämä sovellus ehdottaa reseptejä antamiesi ainesosien perusteella. Kehitetty kurssiprojektina.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
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