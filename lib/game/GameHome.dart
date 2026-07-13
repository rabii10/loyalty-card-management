import 'package:e_commerce/game/quiz_screen.dart';
import 'package:e_commerce/game/score_screen.dart';
import 'package:e_commerce/game/result_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Variables globales Firebase
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _db = FirebaseFirestore.instance;

class GameHome extends StatefulWidget {
  @override
  _GameHomeState createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> {
  int _score = 0;
  bool _isPassed = false;
  bool _hasPlayed = false;
  String _resultMessage = "Play to see your result";
  bool _isNewUser = false;
  Timestamp? _lastPlayDate;

  @override
  void initState() {
    super.initState();
    _checkPlayStatus();
  }

  void _checkPlayStatus() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final doc = await _db.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          _hasPlayed = data?['hasPlayed'] ?? false;
          _score = data?['score'] ?? 0;
          _isPassed = data?['isPassed'] ?? false;
          _resultMessage = _isPassed ? "You Passed!" : "You Failed!";
          _isNewUser = data?['isNewUser'] ?? false;
          _lastPlayDate = data?['lastPlayDate'];
        });

        if (_lastPlayDate != null) {
          DateTime lastPlay = _lastPlayDate!.toDate();
          DateTime now = DateTime.now();
          if (now.difference(lastPlay).inDays >= 5) {
            setState(() {
              _hasPlayed = false;
            });
          }
        }
      }
    }
  }

  void _onQuizComplete(int score, bool isPassed) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final doc = await _db.collection('users').doc(user.uid).get();
      bool isNewUser = doc.data()?['isNewUser'] ?? false;

      await _db.collection('users').doc(user.uid).set({
        'hasPlayed': true,
        'score': score,
        'isPassed': isPassed,
        'isNewUser': false,
        'lastPlayDate': Timestamp.now(),
        'timestamp': Timestamp.now(),
      });

      setState(() {
        _score = score;
        _isPassed = isPassed;
        _hasPlayed = true;
        _resultMessage = isPassed ? "You Passed!" : "You Failed!";
      });
    }
  }

  void _showGiftDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_isPassed ? "Congratulations!" : "Don't Worry!"),
          content: Text(_isPassed
              ? "Well done, you won a free gift! Come to our shop to claim your gift!"
              : "Don't worry, you'll do better next time and win a gift!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

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
            : const Text('Game Home'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/gamepad.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _menuButton("Play", _hasPlayed ? null : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen(onQuizComplete: _onQuizComplete)),
                ).then((_) {
                  _checkPlayStatus();
                });
              }),
              SizedBox(height: 20),
              _menuButton("Scores", _hasPlayed ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScoreScreen(score: _score)),
                );
              } : null),
              SizedBox(height: 20),
              _menuButton("Results", _hasPlayed ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultScreen(resultMessage: _resultMessage)),
                );
              } : null),
              SizedBox(height: 20),
              _menuButton("Gifts", _hasPlayed ? () {
                _showGiftDialog(context);
              } : null),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton(String text, Function()? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed == null ? Colors.grey : Colors.yellowAccent[700],
        minimumSize: Size(200, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}