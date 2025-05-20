import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart'; 

// Käynnistää sovelluksen
void main() {
  runApp(RuokaApp());
}

// Tämä on sovelluksen juurikomponentti
class RuokaApp extends StatefulWidget {
  @override
  _RuokaAppState createState() => _RuokaAppState();
}

class _RuokaAppState extends State<RuokaApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // Asetetaan tumma tai vaalea tila kun sovellus avautuu
    _loadTheme();
  }

  // Asetetaan tumma tai vaalea tila kun sovellus avautuu
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  // Vaihdetaan teemaa ja tallennetaan valinta
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
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // Tässä määritellään sovelluksen teema ja aloitussivu
      home: RuokaHomePage(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}