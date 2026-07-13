import 'package:e_commerce/game/question_crud_screen.dart';
import 'package:e_commerce/game/winners_list.dart';
import 'package:flutter/material.dart';
import 'losers_list.dart';


class VendorHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
          ),
          child: Center(
            child: Text('Game CRUD'),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuestionCrudScreen()),
                );
              },
              child: Text('Manage Questions'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WinnersList()),
                );
              },
              child: Text('Winners List'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LosersList()),
                );
              },
              child: Text('Losers List'),
            ),
          ],
        ),
      ),
    );
  }
}
