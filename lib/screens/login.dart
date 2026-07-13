import 'package:e_commerce/screens/signup.dart';
import 'package:e_commerce/widgets/changescreen.dart';
import 'package:e_commerce/widgets/mytextformField.dart';
import 'package:e_commerce/widgets/passwordtextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Vendeur/seller_login_form.dart';
import '../widgets/mybutton.dart';
import 'homepage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool isLoading = false;
String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
final TextEditingController email = TextEditingController();
final TextEditingController userName = TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final TextEditingController password = TextEditingController();

bool obserText = true;

class _LoginState extends State<Login> {
  void submit(context) async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email.text, password: password.text);
      print(result);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on PlatformException catch (error) {
      var message = "Please Check Your Internet Connection ";
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          duration: Duration(milliseconds: 800),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          duration: Duration(milliseconds: 800),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );

    }

    setState(() {
      isLoading = false;
    });
  }

  void validation(BuildContext context) async {
    if (email.text.isEmpty && password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Both Fields Are Empty"),
        ),
      );
    } else if (email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (!regExp.hasMatch(email.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter a Valid Email"),
        ),
      );
    } else if (password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Is Empty"),
        ),
      );
    } else if (password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Is Too Short"),
        ),
      );
    } else {
      submit(context);
    }
  }
  Widget _buildAllPart() {
    return Expanded(
      flex: 3,
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: <Widget>[
                Text(
                  "Login",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextFormField(
                  name: "Email",
                  controller: email,
                ),
                SizedBox(
                  height: 10,
                ),
                PasswordTextFormField(
                  obserText: obserText,
                  name: "Password",
                  controller: password,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      obserText = !obserText;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                isLoading == false
                    ? MyButton(
                  onPressed: () {
                    validation(context);
                  },
                  name: "Login",
                )
                    : Center(
                  child: CircularProgressIndicator(),
                ),
                SizedBox(
                  height: 10,
                ),

                ChangeScreen(
                    name: "SignUp",
                    whichAccount: "I Have Not Account!",
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => SignUp(),
                        ),
                      );
                    }),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SellerLoginForm()),
                    );
                  },
                  child: Text(
                    "Are you a seller?",
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildAllPart(),
            ],
          ),
        ),
      ),
    );
  }
}