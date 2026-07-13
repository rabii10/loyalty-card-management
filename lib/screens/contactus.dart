import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce/provider/product_provider.dart';
import 'package:e_commerce/model/usermodel.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> _aiResponses = {
    "Greetings": "Hello! How can I assist you today?",
    "Thanks": "Thank you for your message. We will get back to you shortly.",
    "Order": "Thank you for your interest in ordering. We will assist you shortly.",
    "Complaint": "We apologize for any inconvenience caused. Please provide details and we will address it promptly."
  };

  void _sendToFirestore(String message) {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("Message").doc(user?.uid).set({
      "Message": message,
    });
  }

  void _handleValidation() {
    if (_formKey.currentState!.validate()) {
      String userMessage = _messageController.text.trim();
      _sendToFirestore(userMessage);
      String aiResponse = _simulateAIResponse(userMessage);
      _showResponseDialog(aiResponse);
    }
  }

  String _simulateAIResponse(String message) {
    if (message.toLowerCase().contains("order")) {
      return _aiResponses["Order"]!;
    } else if (message.toLowerCase().contains("complaint")) {
      return _aiResponses["Complaint"]!;
    } else {
      return _aiResponses["Thanks"]!;
    }
  }

  void _showResponseDialog(String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("AI Response"),
          content: Text(response),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xfff8f8f8),
        title: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 25,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 27),
        height: 600,
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Sent Us Your Message",
                style: TextStyle(
                  color: Color(0xff746bc9),
                  fontSize: 28,
                ),
              ),
              Container(
                height: 200,
                child: TextFormField(
                  controller: _messageController,
                  expands: true,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Message",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _handleValidation,
                child: Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}





