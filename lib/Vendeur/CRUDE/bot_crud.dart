import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BotCRUD extends StatelessWidget {
  const BotCRUD({Key? key}) : super(key: key);

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
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
            child: Text('ChatBot CRUD'),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _launchURL(''),
              child: const Text(''),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchURL(''),
              child: const Text('Navigate to Google Cloud Console'),
            ),
          ],
        ),
      ),
    );
  }
}

