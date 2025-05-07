import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MoodSenseApp());

class MoodSenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodSense',
      home: MoodHomePage(),
    );
  }
}

class MoodHomePage extends StatefulWidget {
  @override
  _MoodHomePageState createState() => _MoodHomePageState();
}

class _MoodHomePageState extends State<MoodHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  Future<void> _analyzeMood() async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/analyze'), // vaihdetaan myöhemmin
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': _controller.text}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _result = jsonDecode(response.body)['mood'];
      });
    } else {
      setState(() {
        _result = 'Virhe analyysissä';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MoodSense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Kirjoita fiiliksesi tähän',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _analyzeMood,
              child: Text('Analysoi tunnelma'),
            ),
            SizedBox(height: 16),
            Text(
              'Tulos: $_result',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}