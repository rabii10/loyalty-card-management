import 'package:flutter/material.dart';

class ScoreScreen extends StatelessWidget {
  final int score;

  ScoreScreen({required this.score});
  bool isSearchClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellowAccent,
        title: isSearchClicked
            ? Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 95, 226, 77),
            borderRadius: BorderRadius.circular(20.0),
          ),
        )
            : const Text('Score'),
        centerTitle: true,
      ),

      body: Center(
        child: Text(
          'Your score is: $score',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
