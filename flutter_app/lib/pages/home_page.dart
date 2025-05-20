import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tabs/home_tab.dart';
import 'tabs/favorites_tab.dart';
import 'tabs/settings_tab.dart';

// Sovellus käynnistyy
void main() {
  runApp(RuokaApp());
}

class RuokaApp extends StatefulWidget {
  @override
  _RuokaAppState createState() => _RuokaAppState();
}

class _RuokaAppState extends State<RuokaApp> {
  bool _isDarkMode = false;

  // Haetaan tallennettu teema-asetus kun sovellus käynnistyy
  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  // Haetaan tallennettu teema-asetus kun sovellus käynnistyy
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  // Tallennetaan uusi teema-asetus (tumma tai vaalea)
  void _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruokavinkki',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: RuokaHomePage(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

// Tämä luokka sisältää välilehdet: Etusivu, Suosikit ja Asetukset
class RuokaHomePage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleTheme;

  const RuokaHomePage({
    Key? key,
    required this.isDarkMode,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  _RuokaHomePageState createState() => _RuokaHomePageState();
}

class _RuokaHomePageState extends State<RuokaHomePage> {
  List<Map<String, dynamic>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Määritellään mitä jokainen välilehti näyttää
  List<Widget> _buildPages() {
    return [
      HomeTab(
        favorites: _favorites,
        onAddFavorite: _toggleFavorite,
      ),
      FavoritesTab(
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
      ),
      SettingsTab(
        onClearFavorites: _clearFavorites,
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onToggleTheme,
        hasFavorites: _favorites.isNotEmpty,
      ),
    ];
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? stored = prefs.getString('favorites');
    if (stored != null) {
      final List<dynamic> decoded = jsonDecode(stored);
      setState(() {
        _favorites = decoded.cast<Map<String, dynamic>>();
      });
    }
  }

  void _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_favorites);
    await prefs.setString('favorites', encoded);
  }

  // Lisätään tai poistetaan resepti suosikeista
  void _toggleFavorite(Map<String, dynamic> recipe) {
    setState(() {
      final exists = _favorites.any((r) => r['name'] == recipe['name']);
      if (exists) {
        _favorites.removeWhere((r) => r['name'] == recipe['name']);
      } else {
        _favorites.add(recipe);
      }
      _saveFavorites();
    });
  }

  // Tyhjennetään kaikki suosikit
  void _clearFavorites() {
    setState(() {
      _favorites.clear();
      _saveFavorites();
    });
  }

  // Vaihdetaan välilehti kun alavalikkoa painetaan
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  // Sovelluksen yläpalkki, runko ja alavalikko
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ruokavinkki')),
      body: _buildPages()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Etusivu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Suosikit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Asetukset',
          ),
        ],
      ),
    );
  }
}