import 'package:e_commerce/Vendeur/seller_home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'CRUDE/crude_operation.dart';


class SellerLoginForm extends StatefulWidget {
  @override
  _SellerLoginFormState createState() => _SellerLoginFormState();
}

class _SellerLoginFormState extends State<SellerLoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoggedIn = false;
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Seller Login',style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),)),
        actions: [
          if (_isLoggedIn)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                setState(() {
                  _isLoggedIn = false;
                });
              },
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                style: TextStyle(fontSize: 16),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_usernameController.text.trim() == '' &&
                        _passwordController.text.trim() == '') {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _usernameController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                        setState(() {
                          _isLoggedIn = true;
                        });
                        print('_isLoggedIn: $_isLoggedIn');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CRUDEoperation()),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SellerHomePage()),
                        );
                        setState(() {
                          _isLoggedIn = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Logged in successfully'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to login: ${e.toString()}'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Incorrect username or password'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18,color: Colors.white),

                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Go Back To Login Page?",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Image.asset(
                'images/chariot.jpg',
                width: 100,
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}