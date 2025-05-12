import 'package:flutter/material.dart';
import 'tabs/home_tab.dart';

void main() {
  runApp(RuokaApp());
}

class RuokaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruokainspiraattori',
      home: RuokaHomePage(),
    );
  }
}

class RuokaHomePage extends StatefulWidget {
  @override
  _RuokaHomePageState createState() => _RuokaHomePageState();
}

class _RuokaHomePageState extends State<RuokaHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    HomeTab(),
    Center(child: Text('Suosikit – Tallennetut reseptit')),
    Center(child: Text('Asetukset / Tietoa')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ruokainspiraattori')),
      body: _pages[_selectedIndex],
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