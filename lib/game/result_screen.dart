import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String resultMessage;

  ResultScreen({required this.resultMessage});
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
            : const Text('Results'),
        centerTitle: true,

      ),
      body: Center(
        child: Text(
          resultMessage,
          style: TextStyle(fontSize: 24, color: resultMessage == "You Passed!" ? Colors.green : Colors.red),
        ),
      ),
    );
  }
}

